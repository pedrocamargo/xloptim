---
id: 703
title: "Get them filtered: A new plugin for QGIS"
date: '2019-08-30T12:05:50+10:00'
author: pedro
layout: post
categories:
    - GIS
    - Python
    - Software
---

This is another quite short post, as it treats of something that is quite trivial from a technical point of view and, in hindsight, something that I should’ve published years ago.

One of the features that I quite missed in QGIS right from the beginning, was the possibility of navigating through elements of a layer on the screen in order to inspect them. The possibility of mapping each one of these items did eventually come to QGIS in the form of the Atlas, which is extremely powerful and [trivial to use](https://www.qgistutorials.com/en/docs/automating_map_creation.html).

Over the years I wrote a overcame this issue in different forms, mainly by quickly scripting some pyqgis and by using the built-in categorized renderer, and those features solved the problems for the most part. Until yesterday, and then I had enough.

To be clear, this is something I have wanted inside AequilibraE for a very long time, but I feel that this is a feature that is far from being useful only within the transportation modelling world, so I thought I would make a light weight plugin that I could update and improve quickly, instead of being subject to the lengthy release cycle that AequilibraE currently experiences.

So the premise of the tool is simple. After selecting a layer and any field of such layer, the plugin will list all the unique values present in that field, and allow you to filter to one or more values by just selecting them from a list (and you can also choose to have it zoom to the filtered elements if you’d like).

In order to allow for a quick release, I once again resorted to making a tutorial video in lieu of proper documentation, which I hope you will forgive me for.

{{< youtube id="mezVTQAmitI" >}}

I have just uploaded the plugin to the QGIS repository, so it might take a little bit of time for it to show for installation, but you can monitor directly in the [QGIS plugin repository](https://plugins.qgis.org/plugins/getthemfiltered/).