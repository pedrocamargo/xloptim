---
id: 680
title: "New version of AequilibraE for QGIS 3.X"
date: "2019-09-10T22:04:04+10:00"
author: pedro
url: /new-version-of-aequilibrae-for-qgis-3-x/
guid: "http://3.105.80.235/?p=680"
permalink: /new-version-of-aequilibrae-for-qgis-3-x/
spbc_frontend__last_checked:
  - "1623403621"
categories:
  - AequilibraE
  - GIS
  - Python
  - Software
---

It has been a really long time since I released the experimental version of AequilibraE for QGIS 3.X, and since then I haven’t worked really hard on it. Part of this slow down in the development had to do with the fact that I don’t have air condition in my home office, and Brisbane’s summer is not kind on such absurdity.

The biggest reason for the slow down, however, was the fact that the QGIS 3 version was incredibly stable from the get go, and despite the large number of users (over 800 downloads, even though the release is flagged as experimental), the bugs reported were not many. On that note, I am still having a lot of trouble getting people to report bugs on GitHub and asking questions in the user list, instead of doing either straight was Youtube comments (I know I am behind on the tutorials, btw) or by e-mailing me. Does anybody have good suggestions on dealing with that?

After fixing these bugs and polishing the software, I ended up with 9 noteworthy changes:

**New Features**

- Automatic installation of required packaged from within QGIS (not critial for the user, but enables new features)
- Displaying of OMX matrices

**Bugs fixed**

- Issue with the progress bar for desire lines where it would reach 100% when only 50% of the work had been undertaken
- Issue with links that had NULL flows in one direction and were depicted as if they had a very small flow
- Issue with persistent error every time the user attempted to change a matrix name when importing from an open layer (CSV)
- Issues with Delaunay lines not being populated when zeros were found in the matrices
- Issue where the network preparation procedure would allow the user to select multiLineString for network preparation, when it makes no sense for that to be the case

**Improved user experience**

- Matrices being imported from CSVs are automatically named after the field rather than the layer name

**Better performance**

- Desire Lines procedure is now much faster than the previous algorithm (over 11x faster for the test case used – 250 matrix cores, 800 zones)

Although bug fixing and improvements in user experience are paramount, I must say that I was pretty pleased with the improvement in performance in the generation of desire lines for very large datasets, and I will admit that I dedicate a few hours to that improvement because the poor performance of the previous algorithm was driving me insane. It was not trivial, however, to come up with a fast algorithm relying only on Python packages that are shipped with QGIS for Windows (the most restrictive case in terms of compatibility and a tenet I was trying to abide to).

It turns out that NumPy has a few pandas-like functions that can be used with Record Arrays, which enabled an algorithm that is pretty similar to what one would do if Pandas were available. There is still a pretty nasty loop in the code that is a requirement in cases one is building a in-memory layer. There is the alternative of creating the entire array in memory (including geometry in WKT format) and dumping it to disk before loading the file in QGIS using standard file loading procedures. That sounds a little ridiculous, but having a massive loop in python in which you have to create complex objects (geometries and attribute arrays) in Python seems to be rather inefficient. In any case, that will be a task for later.

After I did most of the work and wrote everything that you just wrote (It has been some time, downloads of the experimental version are now in 1,600), I decided that it was necessary to add OMX support for AequilibraE. I literally could no longer avoid this topic.

After the discovery that it can be rather simple to add Python packages to QGIS on Windows, which I documented on a [previous post](http://3.105.80.235/adding-python-packages-to-qgis-3-on-windows-10/), I investigated it a little more and implemented a way to have the user download the necessary packages (Open Matrix and its dependencies) from within QGIS. Actually displaying matrices by using the same infrastructure that existed for AequilibraE matrices was pretty trivial to implement.

<iframe allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="" frameborder="0" height="658" loading="lazy" src="https://www.youtube.com/embed/K6iwvJaSQ4s?feature=oembed" title="package installation" width="1170"></iframe>

The complete release notes and files can be found on [GitHub](https://github.com/AequilibraE/AequilibraE-GUI/releases/tag/0.5.1).

As usual, feel free to use the software, report bugs and request new features.
