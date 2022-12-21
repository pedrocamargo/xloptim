---
id: 388
title: 'New RasterStats'
date: '2019-10-01T12:27:46+10:00'
author: pedro
layout: post
guid: 'http://3.105.80.235/?p=388'
permalink: /new-rasterstats/
spbc_frontend__last_checked:
    - '1623403629'
categories:
    - GIS
    - Python
    - Software
---

Oddly enough, the [most popular plugin](http://plugins.qgis.org/plugins/rasterstats/) I have ever created for QGIS is NOT AequilibraE, but a much more obscure tool I created [4 years ago](http://3.105.80.235/rasterstats/) at the request of my brother. This tool, dedicated to the computation of raster statistics when overlayed with polygons (basically counting the number of pixels of each value for each polygon), is something that can be easily reproduced using a variety of GIS tools or some simple Python or R scripting, but at the time of release had no GUI alternative available, hence the plugin.

I am not quite sure if the plugin is still all that relevant, but since people have recently asked me about it, I decided to do the migration, as it was a matter of a little more than 1h of work during a long flight. Enjoy!