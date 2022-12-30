---
id: 269
title: "New version of AequilibraE"
date: "2016-08-21T12:17:41+10:00"
author: pedro
url: /new-version-of-aequilibrae/
categories:
  - AequilibraE
  - GIS
  - Python
---

I realize now that it has been well over a year since my last post, but I think I have a few good reasons:

- I moved to Australia (our hearts are still in the US, but we are living down under now)
- I completely re-factored AequilibraE, and it is now a much more robust and versatile piece of software
- I lost track of time (not really a good reason, but I will play this card anyways)

Enough with excuses, and on with the matter of this post.

After I released AequilibraE, a little more than 18 months ago, I got a lot of contacts from several parts of the world, specially small consultancy companies, graduate students and university professors. Among the students and professors, the main objective was to use AequilibraE from outside QGIS and directly as one just another Python library. For those interested in the GUI, the interest was mostly in preparing the network (still the favorite feature of most people), which was not a particularly fast algorithm.

The idea of using AequilibraE’s algorithms outside QGIS was so obvious that I was a little embarrassed for not thinking of that first, so I decided to tackle that before advancing with the addition of new algorithms or other optimizations. The idea was simple: Decouple the GUI and the algorithms (easier said then done). This task was successfully completed a few months ago, and I spent months testing it and making small changes that, I think, resulted in a solid first version for it.

In the end, the python API now looks like a traditional Python library that you can import from any Python (2.X) environment. The code for computing a shortest path between two nodes looks something like this on Windows 10:

```
    import sys
    sys.path.append(“C:/Users/Pedro/.qgis2/python/plugins/AequilibraE/”)

    # The graph
    from aequilibrae.paths import Graph

    # The results for assignment and shortest path
    from aequilibrae.paths.results import PathResults
    from aequilibrae.paths.results import AssignmentResults

    #loading the graph prepared in QGIS
    my_graph = Graph()
    Results = PathResults()
    my_graph.load_from_disk(‘E:/output/graph.aeg’)

    #Computing a path
    origin = 1
    destination = 37
    results.prepare(my_graph)
    ae.paths.path_computation(origin, destination, my_graph, results)

    # retrieving the results
    nodes_traversed = results.path_nodes
    links_traversed = results.path
```

The main idea behind the API development was to concentrate all the inputs and outputs in a small number of objects, such a graph, the results of a path computation or the results of an assignment computation. This also allows the user to save the graph on disk and speed future calculations up by just loading the graph ready-to-go, as in the example above.

In turn, having the graph saved on disk allows for its use also within AequilibraE’s GUI inside QGIS, which makes ALL algorithms run much faster, besides reducing the number of inputs in each and every screen related to network computations. On the results side, the software also became much more powerful, as all results are saved and readily available to the user through a number of methods and properties of each one of these objects.

During this development, a few features also disappeared, as I still did not migrate them to the API, which is the case of trip distribution and traffic assignment, but those are in the works and should be ready soon. As these, plus a number of other developments are on the cards for the near future, I expect to make frequent posts here with each and every new feature being released within this version of AequilibraE. As I HATE cliffhangers, the upcoming features on this release are:

- Trip distribution (same features as before, but with much-improved algorithms and interface)
- Traffic assignment (same features as before, but with much-improved algorithms and interface. Frand-Wolfe equilibrium assignment will also be added)
- Desire lines (traditional and Delaunay lines, as I presented [HERE](http://xl-optim.com/delaunay/) before)
- A complete manual (video tutorials, GUI manual, API documentation and examples)

After all these features are released I will start working on version 0.4, and I hope to hear from users (and potential users) which features are more pressing (and why). Contributions to the project, as usual, are very welcome:

Download the new version [HERE ](http://xl-optim.com/site/aequilibrae0.3/AequilibraE.7z)or from its [repository](https://github.com/AequilibraE/AequilibraE) (now moved to Github)

The development of this API was made possible by the support provided by the [Instituto de Pesquisa Econômica Aplicada](http://www.ipea.gov.br), in Brazil. Kudos to them!!
