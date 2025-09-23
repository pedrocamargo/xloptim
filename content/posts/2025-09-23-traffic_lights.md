---
id: 1075
title: "Traffic lights for the entire world"
author: pedro
url: /osm_traffic_lights/
categories:
    - data, gis
---
Before we start, let me ask a question: How many traffic lights in the entire world are present in Open-Street Maps?

I have been working on the development of [POLARIS](https://vms.taps.anl.gov/tools/polaris/ "POLARIS") for quite some time now, and it has been quite fulfilling to see how far we were able to bring the Python package (Polaris-Studio) and QGIS plugin (QPolaris) that surround POLARIS and give the user a pretty solid user interface.

One of the distinct features of Polaris-Studio is the set of model-building tools that can ingest data from a wide range of data sources (e.g. Open-Street Maps, Overture Maps, US Census, Mobility Database) to build many of the tables that comprise a POLARIS model.

There are many challenges in relying on public APIs and open data sources for critical processes, king of which is the tremendous amount of work needed to test the code that relies on these APIs in a sensible way (i.e. not hammering the APIs, but still making sure that we get errors as soon as changes in them break our code). It has not been fun, and being the responsible person for those submodules of Polaris-Studio is a constant source of annoying work and complaints from colleagues and other users of the software.

The most frequently used of all pieces of open data leveraged by POLARIS is the set of traffic signals available in Open-Street maps, which is used every time a network geometry is edited and intersections need to be rebuilt, for which the OSM data informs which intersections are signalised and which are not. Due to the frequency of use for this data source, we had already built-in ways to cache that data in a users' system to avoid multiple downloads (i.e. delays) during network editing sprints, but we came to rely too heavily on having the OSM Overpass servers available whenever working on networks.

The complete solution we found is not particularly relevant here, but creating a dataset with traffic signals for the entire world, which are present in OSM, became my little pet project over the weekend, and it was quite interesting to work on.  I was looking for an excuse to use the [Overpass server](https://wiki.openstreetmap.org/wiki/Overpass_API "OSM Overpass") I maintain at home, synchronised to the minute with the official OSM servers. I implemented a parallelised piece of software that downloaded traffic signals for one cell of a grid at a time, covering the entire world, and saved the results to a PostGIS database. It took me a couple of hours to write the code, and the whole process took about three hours to run, which I was pretty pleased with.

I made sure to record data in a way that would allow me to update the data only for select areas of the globe if I wanted, and everything seemed to make sense, and the code below is simple enough (if only a bit too *hacky*) to be usable.

```python
from pathlib import Path
import json
import multiprocessing as mp
from datetime import date
from random import shuffle

from tqdm import tqdm
import geopandas as gpd
import numpy as np
import pandas as pd
import requests
import logging
import sys
from tempfile import gettempdir

from shapely.geometry import box
from sqlalchemy import create_engine, text

# Overpass API endpoint
OVERPASS_URL = "http://192.168.68.93:43511/api/interpreter"

QUERY_TEMPLATE = """[out:json][timeout:180];(node["highway"="traffic_signals"]["area"!~"yes"]({s},{w},{n},{e});>;);out;"""


def fetch_for_bbox(job_id):
    engine = create_engine("postgresql://postgres:postgres@192.168.68.93:5432/postgres")

    job = gpd.read_postgis(f"SELECT * from cell_downloads where cell_id='{job_id}'", engine, geom_col="geometry")
    if job.empty:
        return
    w, s, e, n = job.geometry.values[0].bounds

    query = QUERY_TEMPLATE.format(s=s, w=w, n=n, e=e)
    response = requests.post(OVERPASS_URL, data={"data": query})
    if response.status_code != 200:
        print(f"Error fetching data for cell {job_id}: {response.status_code}\n\n")
        return

    txt = response.text
    row_count = txt.count('\n') + (0 if txt.endswith('\n') or not txt else 1)
    if row_count <= 1:
        return
    df = pd.DataFrame(response.json().get("elements", []))

    def leave(engine, job_id=None):
        if job_id is not None:
            with engine.connect() as conn:
                conn.execute(
                    text("UPDATE cell_downloads SET created_at = :today WHERE cell_id = :cell_id"),
                    {"today": date.today(), "cell_id": job_id}
                )
                conn.commit()
        engine.dispose()

    if df.empty:
        leave(engine, job_id)

    if "lon" in df.columns and "lat" in df.columns:
        df["geometry"] = gpd.points_from_xy(df["lon"], df["lat"])
    else:
        return

    def to_json(val):
        try:
            data = json.loads(str(val).replace("'", '"'))
            return json.dumps(data)
        except json.JSONDecodeError:
            return None

    if 'tags' in df.columns:
        df['tags'] = df['tags'].apply(to_json)
    gdf = gpd.GeoDataFrame(df, geometry="geometry", crs=4326).assign(cell_id=job_id)
    gdf = gdf.drop(columns=["lat", "lon"]).rename(columns={"type": "item_type"})
    gdf.to_postgis("traffic_signals", engine, if_exists="append", index=False)
    leave(engine, job_id)


def partitioned_world_shape():
    partitioned_file = Path(gettempdir()) / "subdivided_world.parquet"

    if partitioned_file.exists():
        return gpd.read_parquet(partitioned_file)
    # Partitioning makes the spatial join MUCH faster
    logging.info("Downloading and partitioning world shape")
    url = "https://raw.githubusercontent.com/martynafford/natural-earth-geojson/master/10m/physical/ne_10m_land.json"
    world_land = gpd.read_file(url)
    # Write original GeoDataFrame to a temp table
    engine = create_engine("postgresql://postgres:postgres@192.168.68.93:5432/postgres")
    world_land.to_postgis("temp_input", engine, if_exists="replace", index=False)
    sql = """
    SELECT
        temp_input.*,
        (ST_Dump(ST_Subdivide(temp_input.geometry, 4096))).geom AS geom
    FROM temp_input
    """
    subdivided_world = gpd.read_postgis(sql, engine, geom_col="geom")
    with engine.begin() as conn:
        conn.execute(text("DROP TABLE IF EXISTS temp_input"))
    engine.dispose()

    subdivided_world.to_parquet(partitioned_file, index=False)
    return subdivided_world


def build_tasks():
    subdivided_world = partitioned_world_shape()
    logging.info("Building download grid")
    step = 0.5  # Going large queries start hitting timeouts, so it is better to keep it rather small
    # The ranges were defined to go from the southernmost to the northernmost habitated pieces in the world)
    latitudes = list(range(-540, 840, int(step * 10)))
    longitudes = list(range(-1800, 1800, int(step * 10)))

    latitudes = np.array(latitudes, dtype=np.float64) / 10
    longitudes = np.array(longitudes, dtype=np.float64) / 10
    lat_grid, lon_grid = np.meshgrid(latitudes, longitudes, indexing="ij")

    south = lat_grid.ravel()
    north = (lat_grid + step - 1e-8).ravel()
    west = lon_grid.ravel()
    east = (lon_grid + step - 1e-8).ravel()
    polys = [box(w, s, e, n) for w, s, e, n in zip(west, south, east, north)]
    ids = (
            10000000000000 * (south + 90)
            + 1000000000 * (north + 90)
            + 100000 * (west + 180)
            + 10 * (east + 180)
    ).astype(np.int64)

    gdf = gpd.GeoDataFrame({"cell_id": ids.astype(str), "geometry": polys}, crs=4326)

    logging.info("Geographically-filtering download grid")
    gdf = gdf.sjoin(subdivided_world, how="inner", predicate="intersects")

    engine = create_engine("postgresql://postgres:postgres@192.168.68.93:5432/postgres")

    logging.info("Data-filtering download grid")
    existing = gpd.read_postgis("SELECT * from cell_downloads", engine, geom_col="geometry")
    gdf = gdf[~gdf.cell_id.isin(existing.cell_id)]

    gdf = gdf[["cell_id", "geometry"]].drop_duplicates(subset=["cell_id"]).reset_index(drop=True)
    if gdf.shape[0]:
        gdf.to_postgis("cell_downloads", engine, if_exists="append", index=False)

    logging.info("Retrieving jobs for querying on Overpass")
    existing = pd.read_sql("SELECT distinct(cell_id) from cell_downloads where created_at is NULL", engine)
    engine.dispose(True)
    jobs = existing.cell_id.to_list()
    shuffle(jobs)
    return jobs


def rn_parallel(cores):
    jobs = build_tasks()
    logging.info(f"TASKS BUILT: {len(jobs)}")

    pool = mp.Pool(cores)
    with tqdm(total=len(jobs)) as pbar:
        for _ in pool.imap_unordered(fetch_for_bbox, jobs):
            pbar.update()
    pool.close()
    pool.join()

if __name__ == "__main__":
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
        handlers=[logging.StreamHandler(sys.stdout)]
    )
    # Windows does not allow more than 60 threads
    rn_parallel(60)

```

I would probably be happier if I had stopped here, but I wanted to revisit **[Osmium](https://osmcode.org/osmium-tool/)**, a tool I had not touched in over a decade, but I had a WSL terminal already open... So why not?  Using Osmium for this purpose required me to download the OSM *planet* file, which is snapshot of the entire contents of OSM.

The file for 15/09/2025 was smaller than one might expect, at 83 GB, but still substantial, and installing the Osmium tool on WSL Ubuntu was straightforward. Now that's when it alls becomes humiliating. Extracting all traffic lights from the planet file took **ONE** command line.

```bash
 osmium tags-filter planet-250915.osm.pbf n/highway=traffic_signals -o traffic_signals.osm.pbf
```

It is still necessary to convert the output, *traffic_signals.osm.pbf*, to a better format, but one can drag and drop this file onto QGIS and export to their preferred format, which is what I did.

With a little trivial cleaning to remove spurious data fields and add covering bounding boxes to the output to speed up file reading, one can read only the traffic lights for their study area, substantially reducing I/O time and memory requirements (not that they are significant to begin with).

```python
gdf = gpd.read_parquet(file_name)
gdf = gdf[["osm_id","name","other_tags","geometry"]]
gdf.to_parquet(file_name, index=False, write_covering_bbox=True)

# Reading the traffic lights for Queenstown, NZ -> 120ms
gdf2 = gpd.read_parquet(file_name, bbox=(168.6186, -45.0567, 168.7574, -44.9865))

# Reading the traffic lights for the entire world -> 2.5s
gdf2 = gpd.read_parquet(file_name)
```

I guess if I stopped here, this blog post would be the proverbial meeting that could have been an e-mail, so I uploaded the dataset I generated [Traffic signals (GeoParquet)](http://xl-optim.com/files/traffic_signals_from_planet_250915.7z "Traffic Signals - 2025-09-15").

Oh, and there are nearly 2 million traffic lights (not signalized intersections) i currently in OSM.
