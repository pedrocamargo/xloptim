---
id: 795
title: "Editing Transportation networks in GIS"
date: "2020-08-17T18:31:26+10:00"
author: pedro
url: /transponet/
categories:
  - AequilibraE
  - GIS
  - Software
---

I have now mentioned in two blog posts that I have missed an important blog post on the amazing work that my friend [Andrew O’Brien](https://www.linkedin.com/in/andrew-o-brien-5a8bb486/) and I did about 3 years ago (even though I have bragged about it to everybody I know in this industry). So since this was a truly collaborative effort, I invited him to co-author this blog post with me (although some description of how the idea really came about is largely a recollection of my thoughts from before I met Andrew).

And before we begin the actual post, let me just say it in plain English. I firmly believe that the most consequential piece of AequilibraE is the network editing framework we describe in this blog post. I firmly believe it will be implemented in multiple platforms and will be around long after AequilibraE is gone and other techniques and software have taken over the modeling practice. Why no one has done this on an open platform is, however, a big mystery indeed.

# The problem

Editing transportation networks has been a major challenge in our industry since its inception, with network coding errors and other inconsistencies being all too easy to create. I remember my first professional mentor in the field, [Wagner Martins](https://www.linkedin.com/in/wagner-colombini-martins-703279/), telling me stories about “tunnels” in networks that would arise from errors in the manual coding in networks when models were still run in mainframes, network links were just a sequence of two nodes manually typed and GIS was just a pipe dream.

More recently, however, the transportation networks in our models have become increasingly complicated, with not only large numbers of links and nodes but also turn penalties and restrictions, transit routes and stops, and other less-used elements. Furthermore, these elements are not merely a collection of lines, points, and polygons, but rather a **coordinated set** of elements according to a **_network model._**

The increase in complexity is partly due to the fact that now we _can_ do it. Computers are fast enough and modeling tools have become competent enough to allow us to come up with some rather complicated network models, however, this increase in network complexity invites even more complex errors if we try to manage them manually.

If you are a transportation modeler, you are already used to the network model used in your favorite modeling package, and if you use more than one package, you are probably aware that they all take slightly different approaches when it comes to specific actions such as splitting links or deleting nodes. For example, when you reposition an intersection, your modeling package may add some links while removing others or may only change the geometry of the link in the database. But why should we be forced to use a proprietary (and expensive) transportation modeling package? And what if we want to manage our data outside of this proprietary ecosystem? We were clearly lacking a capable open-source solution.

# The Solution

We needed to develop an open and user-friendly system whereby editing one feature would cause a series of automatic changes to nearby and related features in order to maintain network consistency.

If we just wrote a custom plugin for our favorite GIS software, however, we would limit the tools usefulness instead of fundamentally changing the way we manage our data. But what if we could push the implementation of our solution down into the data layer?

Isn’t it true that the GIS industry has been replacing the old ShapeFile with database formats such as PostGIS, SpatiaLite GeoPackage, and don’t these databases support powerful automatic procedures designed for just this type of data consistency maintenance in the form of triggers? If you are not familiar with what database triggers are, Wikipedia has a [nice article](https://en.wikipedia.org/wiki/Database_trigger) on it.

It was only in 2017, however, that Andrew and I sat down for a little more than an hour (hard to remember exactly) and discussed what we would like to happen when each common network editing operation is performed. And the network model we thought of was dead simple.

We discussed what were the changes to the database that would warrant triggers and what those triggers would be required to do, [documenting](https://aequilibrae.com/python/V.0.6.3/network.html#network-consistency-behaviour) that as part of our network data model. In order to support a sensible model, the documentation had to explicitly list the required characteristics of each layer and the requirements on **consistency** between them, and consequently the behavior that each specific editing operation should trigger.

All we had to do now was to implement those triggers. As the expert in geodatabases, Andrew picked [Spatialite](https://www.gaia-gis.it/fossil/libspatialite/home) for the prototype implementation, dubbed TranspoNet at the time. By using a combination of unique identifiers and geometric searches using Spatialite’s efficient Spatial Indexes, Andrew was able to develop a system that quickly and efficiently managed our link and node relationships each time you saved your edits. A few example networks are available below.

That work was eventually integrated into version 0.6 of AequilibraE, so its network editing capabilities can be used in any platform that supports Spatialite, such as OpenJUMP and QGIS, and any scripting language that supports both SQLite’s r-Tree spatial index (not the case of Vanilla Python, but see [here](http://xl-optim.com/spatialite-and-python-in-2020/) for a fix) and Spatialite. In fact, the triggers could be easily adapted to any database that supports spatial indexing.

With these ideas and access to adequate technology, it was possible to extend the concept of using database triggers as an overall model consistency tool to other components, including the maintenance of modes and link types.

## Example Triggers

In this implementation, there are basically two types of triggers we need to implement: Pure-data and geometry-related ones.

A good example of a pure-data trigger is enforcing that a node cannot be removed if it is connected to one node. In other nodes, a node cannot be deleted if it is the a_node or b_node of any given link.

<div class="wp-block-syntaxhighlighter-code ">```
<pre class="brush: sql; title: ; notranslate" title="">
CREATE TRIGGER dont_delete_node BEFORE DELETE ON nodes
	WHEN (SELECT count(*) FROM links WHERE a_node = old.node_id OR b_node = old.node_id) > 0
	BEGIN
    SELECT raise(ABORT, 'Node cannot be deleted, it still has attached links.');
  END;
```

</div>Arguably, one could define a different behaviour and say that if a node is deleted, then all links connected to it should be deleted. Although that behaviour is possible, it did not seem intuitive to either of us and therefore was ignored in favour of the behaviour previously described.

A good example of a geometry-related trigger is what we want to happen when we move a node to a new location. Intuitively, one would expect that all the links’ extremities connected to such a node would automatically move to the new location, and that was what we implemented.

<div class="wp-block-syntaxhighlighter-code ">```
<pre class="brush: sql; title: ; notranslate" title="">
CREATE TRIGGER update_node_geometry AFTER UPDATE OF geometry ON nodes
  BEGIN
    UPDATE links
    SET geometry = SetStartPoint(geometry,new.geometry)
    WHERE a_node = new.node_id
    AND StartPoint(geometry) != new.geometry;
    UPDATE links
    SET geometry = SetEndPoint(geometry,new.geometry)
    WHERE b_node = new.node_id
    AND EndPoint(geometry) != new.geometry;
  END;
```

</div>If you want to look at it in more detail, just go to the network page in the AequilibraE’s[ documentation](https://aequilibrae.com/python/V.0.6.3/network.html).

## Example networks

If you just want to see how it performs, we have prepared three examples with three completely different scales.

The first one is the traditional[ Sioux Falls network](http://xl-optim.com/site/network_editing/SiouxFalls.7z), which is really just an example of the technology with a familiar network.,

The second example is a[ network for the greater Chicago](http://xl-optim.com/site/network_editing/Chicago_Illinois.7z) downloaded directly from Open Street Maps and has over 290,000 links and nearly 200,000 nodes. This network far exceeds in size most of the modelling networks currently in use and yet the editing experience using QGIS on a reasonably capable machine is excellent, with no perceptible lag in the processing of any of the triggers.

The final example we created was for the [entirety of India](https://drive.google.com/file/d/1-LT97sClrLLvizHP3Q92-vpYAAKr6iC9/view?usp=sharing) (also from OSM), and it has a total of over 9.16 million links and over 7.3 million nodes. Editing this network proved to be a more tedious task, as some of the triggers took up to 2s to process, depending on which operations were performed. Networks this size seem to be a little too big for SQLite/Spatialite, but I would worry more about traffic assignment processing times than anything else in networks this size.

# What now?

It was quite clear that only SpatiaLite provided enough functionality to let a transportation network maintain its consistency without relying on any other software. More than that, all the work developed in Spatialite thus far has proven to be incredibly fast. Even though the solution we were able to produce so far is not complete, as it does not deal with turn penalties and bans or with transit, it is surely a promising start.

However, we believe that implementing similar work in other backends such as PostGIS and QGIS’s interface for GeoPackage would provide valuable resources for researchers, practitioners, and Open-Source developers, but we do not anticipate doing that work ourselves, and we would love to see other people working on such implementations. Maybe new ideas would arise?
