---
id: 724
title: "Displaying OMX matrix in QGIS"
date: "2019-09-10T00:23:01+10:00"
author: pedro
url: /displaying-omx-matrix-in-qgis/
categories:
  - AequilibraE
  - GIS
  - Software
  - "Transportation planning"
---

One of my last blog posts ([adding Python packages to QGIS 3 on Windows 10](http://www.xl-optim.com/blog/2019-08-26-adding-python-packages-to-qgis-3-on-windows-10/)) was pretty simple, but I was pretty sure that something like that would help quite a bit of people that want to integrate more Python packages into their QGIS workflow, particularly for heavier data processing.

One of the many packages that one can install is [Open Matrix](https://github.com/osPlanning/omx-python) (more on that package on its [wiki](https://github.com/osPlanning/omx/wiki)), which is the Python gateway to access what has become the _de facto_ standard on transportation matrix exchange between packages. That format is not only much faster than anything else that was available before (it is built on top of HDF5), but also supports sparse matrices, virtually unlimited matrix cores and indices in a single file and it is also platform-independent. It is just great.

What is not great about Open Matrix (or OMX), however is that it is somewhat difficult to see what is inside without some scripting or a dedicated piece of software (usually one of the proprietary modelling packages). The excellent [Billy Charlton](https://www.linkedin.com/in/billy-charlton/), did create a visualizer for OMX matrices, but I felt that it is something that would not fit well inside a regular workflow.

Enter AequilibraE’s new version (still having its code reviewed)! Although a small change from a software perspective, AequilibraE now recognizes if the user has installed OMX (its dependencies get automatically installed when you install omx via the suggested method) and makes it an option to display any OMX matrix under the menu (Data – Display AequilibraE formats).

I did a video tutorial with an OMX matrix that has hundreds of matrices and over 80,000 zones (a node to node matrix) and you can see that it is incredibly snappy. Enjoy!

{{< youtube id="vBxXllIl9dY" >}}
