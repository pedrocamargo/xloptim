---
id: 696
title: 'Adding Python packages to QGIS 3 on Windows 10'
date: '2019-08-26T04:22:52+10:00'
author: pedro
layout: post
categories:
    - GIS
    - Python
    - Software
---

Since I started developing [AequilibraE](http://www.aequilibrae.com), one of the greatest constraints I was subject to (if not the single greatest) was the limited number of installed python libraries distributed with QGIS for Windows, which really limited the features I could add to the package and how I had to write certain features, resulting in (often) convoluted code or just plain silly implementations of basic operations used in transportation modelling data processing

QGIS’s development team, however, has improved things dramatically for QGIS 3, and we can now install packages (pure-python or pre-compiled ones) straight from the OSGeo4W shell, as described in this [excellent thread from the GIS StackExchange](https://gis.stackexchange.com/questions/273870/osgeo4w-shell-with-python3/277842#277842).

Let’s suppose, for example, that one wants to install the basic tools to manipulate transportation matrices and data within a QGIS Plugin, and for such they want to install [Pandas](https://pandas.pydata.org/) and [OpenMatrix](https://github.com/osPlanning/omx). To do so, one only needs to run the OSGeo4W shell as an administrator (gets installed when you install QGIS) and type the following commands.

```
py3_env
python3 -m pip install pandas
python3 -m pip install openmatrix
```

This process might fail if the package requires compilation or has some complex dependencies, but I have run only limited testing, with only [Fiona](https://github.com/Toblerity/Fiona) failing to install of those I tested.

For those that want something slightly easier to follow, I made a little video tutorial.

```
import subprocess as sb 
sb.Popen("python3 -m pip install pandas") 
sb.Popen("python3 -m pip install openmatrix")
```

This last bit is not on the video tutorial, as I have found about it after I have PS – I vaguely remember the brilliant [Anita Graser](https://anitagraser.com/) touching on this topic a while ago, but I could not find the post she wrote about it, so I could not reference it here originally published this post.