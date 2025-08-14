---
id: 1075
title: "Aequilibrae 2.0: Preparing for a huge change"
date: "2024-08-04T00:00:00+10:00"
author: pedro
url: /aequilibrae_2_0/
categories:
    - aequilibrae
---
There goes another year without writing to this blog (always for the same reasons), so let's go straight to the point.

AequilibraE's development has been incredibly fast in the last couple of years, with substantial; new features, performance improvements and a much more robust QGIS experience.
These improvements have largely been motivated by some significant projects where government agencies have adopted AequilibraE for a variety of models, but Outer Loop
has also provided substantial funding to the package, particularly for the development of QAequilibraE.

The recent gain in popularity for AequilibraE led us to decide for another generational improvement to software engineering and user experience, including a much better matrix API,
more compact compiled binaries, better support for progress bars in both Python and QGIS, stricter software engineering requirements around the software and a much more
intuitive API.

It is time for a break with the past. This means that AequilibraE 2.0 will require deep changes in our users' existing models, which we do not take lightly. Part of this 
evolution consists of documenting these changes thoroughly and providing users with clear guidance on how to update their models. We will try to reduce the pain for our users,
but we can't promise a pain-free migration.

The new version is expected to be released sometime in early 2026, but there is much das

```python
from aequilibrae import Project
from aequilibrae.traffic_assignment import Graph, TrafficClass, TrafficAssignment
```

Some of the changes we had planned for AequilibraE 2.0 were fully compatible with AequilibraE 1.X, so they will be available on version 1.5 (release planeed for mid September). Some of these changes are:

* Support for Python 3.13
* Removing support for Python 3.9
* Support for Numpy 2.0+
* 

```python

```


In parallel to these developments, we have also started to develop a paid version of AequilibraE, which brings a few additional features such as 
Origin-Destination Matrix Estimation (ODME), and a high-performance sparse matrix interface to better support models based on Activity-Based Models 
and/or traffic assignment in models with hundreds of thousands of origins and destinations, a common problem among data providers.

AequilibraE Pro, as we have been referring to it internally, is still under development and licensing schemes/prices are still being finalized, and
we see it as an opportunity for agencies and companies to guarantee that any bugs and performance issues are resolved promptly while also supporting
the development of AequilibraE.


