---
id: 258
title: 'QGIS plugin for computing raster statistics'
date: '2015-08-17T03:51:12+10:00'
author: pedro
layout: post
categories:
    - GIS
    - Python
---

I have been working with Raster files for a while (mainly CropsCape data), but I have migrated from GRASS GIS to Python a while ago and have not since looked back.

Tools like [Rasterio](https://github.com/mapbox/rasterio) have made life much easier for Python programmers, but it is still hard for those who are not programmers to do a few types of analysis. One of these analysis is to obtain summary statistics and histograms for the raster portion enclosed in a given polygon or for each polygon in a given polygon (or multi-polygon) layer. This exact problem was the one my brother was facing last week, which prompted me to create a little QGIS plugin for this task (using mainly GDAL tools).

Right now there are two known issues/drawbacks to the tool:

- The Vector layer needs a field called ***ID*** with unique values to report the results properly
- Does not allow for choosing a layer that is open in QGIS

Since these issues are not critical for most uses of it, its release might help people processing Raster images in QGIS. Hopefully its users will also be able to report other bugs and issues I have not found yet.

Finaly, this is NOT based on the excellent work done by [Matthew Perry](http://blog.perrygeo.net/2013/09/24/python-raster-stats/), although both tools share the same name.