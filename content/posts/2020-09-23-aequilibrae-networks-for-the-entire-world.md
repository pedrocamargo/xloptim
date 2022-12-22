---
id: 989
title: 'AequilibraE networks for the entire world'
date: '2020-09-23T09:23:02+10:00'
author: pedro
layout: post
categories:
    - AequilibraE
    - GIS
    - Software
---

A couple of months ago, somebody from the World Bank asked me for suggestions on how to go about computing a distance matrix between a series of points spread throughout India using Open-Street-Maps or something similar.

Computing path computations on large networks are nothing new, nor is it to compute skim matrices for a large number of nodes. However, efficiently computing large distance matrices for huge networks is not necessarily trivial.

My answer to that question was that there are two very different approaches, and choosing one of them depends (among other things) on how many cells are in the said skim matrix. The options I gave him (there are others, I know) were the following

- Using a local deployment of the EXCELLENT [GraphHopper](https://www.graphhopper.com/) and perform as many queries as there are cells in the desired skim matrix
- Create an AequilibraE matrix from OSM for the entire country and compute the skim matrix directly

If, on one hand, it sounds ridiculous to use AequilibraE to house a network with nearly 10 million physical links, on the other hand, it is also preposterous to make separate queries for each cell in a skim matrix, so we were in not-so-reasonable territory anyways. (I later realized that I had forgotten about the excellent [OSRM](http://project-osrm.org/), which would probably be the best solution for a vanilla large skim matrix for an OSM network.)

Despite giving the advice above, I was not positive that AequilibraE would be up to the task, as intermediary steps in Graph preparation could take memory consumption beyond the values I had imagined, so I decided to build the network myself and see how it would play out.

As soon as I started the download, however, I realized that it would take me almost a day to make all the necessary API requests to a default Overpass API server, so I guessed it would be very unlikely that I would be able to finish the process successfully.

As it turns out, it is trivial to set a local mirror to an Overpass API server and to keep it synchronized using Docker, so I created yet another service on my home NAS to host this server. The instructions I found for [one of the docker alternatives](https://github.com/wiktorn/Overpass-API) were perfect, and it took me a little less than 5 minutes to set the entire server up, and another 10 hours or so to synchronize the server before I could use it (my NAS has a very low-powered CPU, so your mileage may vary).

With a local Overpass server available, I was able to download all the necessary data for India in about 10 minutes, and that includes the query time and the generation of the JSON output in memory (the most time-consuming task at this point).

Generating the network, however, proved incredibly slow (to the tune of 4 days), which was just unacceptable (it also crashed when it was 49.9% done), so a few changes were needed. After some code optimization and the removal of unnecessary parameter reading from inside the main network building loop (a truly shameful mistake at this point in my career), I was able to successfully build an AequilibraE network for India in just over 9h. The first hurdle had been overcome.

The second and final hurdle was to be able to compute a shortest path tree for such a ridiculously large network, and my 32Gb of ram proved too little for the graph-building process. As it turns out, the graph-building process could be improved substantially with just one extra parameter, which allows the user to specify which network data fields to have in the graph, instead of heaving all possible fields. Hurdle 2a had also been overcome.

With the graph ready, building the PathResults object and computing the path was trivial, and the final code for a single path computation is below.

```
import sys
from aequilibrae import Project
from aequilibrae.paths import Graph
from aequilibrae.paths.results import PathResults, SkimResults
from aequilibrae import logger
from time import perf_counter
from random import choices
import numpy as np
import logging
stdout_handler = logging.StreamHandler(sys.stdout)
logger.addHandler(stdout_handler)

nm = f'D:/release/countries/india'

p = Project()
p.open(nm)


t = perf_counter()
fields = ['link_id', 'a_node', 'b_node', 'direction', 'distance', 'modes']
p.network.build_graphs(fields)

for mode in p.network.list_modes():
    if mode != 'c':
        del p.network.graphs[mode]

g = p.network.graphs['c']  # type: Graph
g.set_graph('distance')
g.set_skimming('distance')
g.set_blocked_centroid_flows(False)
r = PathResults()
r.prepare(g)
print(f'Building graphs {perf_counter() -t:,.2f}')

t = perf_counter()
r.compute_path(1370205, 3115143)
print(f'single path {perf_counter() -t:,.2f}')

t = perf_counter()
r.update_trace(1)
print(f'Update trace {perf_counter() -t:,.8f}')

#We get all nodes for which mode c is connected
curr = p.conn.cursor()
curr.execute("select node_id from nodes where modes like '%c%'")
nodes = [x[0] for x in curr.fetchall()]

for c in [2, 3, 4, 5, 6, 7, 8, 9, 10, 250, 1000]:
    centroids = np.array([1, 1])
    while np.unique(centroids).shape[0] != centroids.shape[0]:
        centroids = np.array(choices(nodes, k=c))

    t = perf_counter()
    g.prepare_graph(centroids)
    g.set_blocked_centroid_flows(False)
    g.set_skimming(['distance'])
    print(f'RE-prepare graph {perf_counter() -t:,.2f} for {c} centroids')

    t = perf_counter()
    skm = SkimResults()
    # skm.set_cores(6)
    skm.prepare(g)
    skm.compute_skims()
    print(f'Skim for {perf_counter() -t:,.2f} for {c} centroids')
```

As it turns out, building the graph object and preparing the PathResults object took about 140s on my machine, while the shortest path computation (a full shortest path tree and path tracing for a single OD pair) took just over 3.2s. Retracing the path for a second destination from the same origin takes only 5ms, so it is safe to assume that the shortest path computation for one origin on this network takes about 3.2s.

Computing the skim matrix is a little trickier, as much more memory is required in order to leverage multiple threads, but one can get around this limitation by deleting the existing graphs for all modes in which we are not interested, as shown on lines 22-24

The final part of the code (from line 48) was a small experiment on actual network skimming, where I could use all 12 threads available on my machine and push its limits, with AequilibraE stretchings its legs and using almost 21Gb of memory.

Given this over-use of resources, it comes at no surprise that even the fully multithreaded computation of skim matrices for 10, 250 &amp; 1,000 nodes provided a similar speed-up factor of only 2.1 to 2.5 over the single-threaded path computation, where the larger problems presented a speed-up around 2.1 only.

In the end, computing a distance matrix for 1,000 nodes in India over a network with over 18 million directed links in 21 minutes, or under 30 minutes including pre-processing and matrix export is not particularly impressive, but it is not too shabby either, and it is probably an order of magnitude faster than doing it with GraphHopper.

It is clear, however, that in case AequilibraE evolves to also focus on this type of application, changing data type throughout the software from double to single precision in a few places could drastically reduce memory consumption, while computation efficiency during path computation will likely be greatly improved once contraction hierarchies are applied to the graphs prior to path computation.

Now to the fun part.

## World networks

After I successfully downloaded the entire network for India, it occurred to me that there was nothing stopping me from replicating it to every other country on earth, and that did seem like something fun to do, so I decided to take on that.

As one can imagine, that is not something that I could process in very little time and while working on actual projects, so it took me a couple of weeks to produce all these networks and make them available online.

I am also planning to download networks for provinces/states of Countries that are simply too big (e.g. Brazil &amp; USA), but I am happy to set it up to consider other geographies if needed.

## [Download it here!](https://drive.google.com/drive/folders/1WFETIrNzMqXuEuldcJ6JPISMAjDBXuYR?usp=sharing)

Finally, it would be really fun to have this set up as a recurring process on a cloud platform to keep these networks up-to-date. Is anybody willing to foot the AWS/Google/Azure bill?