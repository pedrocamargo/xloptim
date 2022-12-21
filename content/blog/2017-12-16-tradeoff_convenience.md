---
id: 344
title: "Allowing AequilibraE's users maximum convenience without driving myself crazy"
date: '2017-12-16T01:42:53+10:00'
author: pedro
layout: post
categories:
    - AequilibraE
    - GIS
    - Python
    - 'Transportation planning'
---

Like most minimally experienced transportation modellers and planners, I have used multiple modelling software in professional and academic life, but I could not properly appreciate the differences between some of the different software implementations until I became myself a “developer” with AequilibraE.

One of these differences is how to define and number centroids and general nodes in the network. As I had been trained in transport modelling using TransCad, it seemed natural to have completely arbitrary node (and centroid) numbering for the models I was developing and using, even though I don’t recall “abusing” that feature.

As I started using Emme (2, back then) and Cube (6.1, during my PhD), I realized that not only the zone numbering was much stricter, consistency between matrices and network was taken much more seriously. This strictness, however, if you are doing research or just re-purposing the tool for something slightly different, can be simply impossible.

Being a very inexperienced developer when I first started to work on AequilibraE, I did not stop to think about these issues, and assimilated the convention of a stricter zone numbering rules used by software such as Emme, but was looser in terms of consistency between network and matrices, much like TransCad is setup to be. In both cases, it was the easiest path to take.

As the software matures and grows in capability, however, an overarching data model (or philosophy) needs to be established, even if it is not made completely formal (documentation will get there eventually). The first step on this journey is the re-factoring of the AequilibraE graph and how it deals with network nodes.

However, anybody that has ever implemented graph algorithms knows how much it helps to have all nodes in the graph nicely stacked up from 0 to n-1, while skimming and network loading also greatly benefit from having all the centroids stacked as the first n nodes in that network. It makes things easier and faster, as you can just eliminate a lot of array indexing throughout your code. And there is a LOT of indexing that goes into even simple code such as AequilibraE’s.

There are basically two ways of doing this:

1. Creating a secondary node numbering scheme behind the scenes when we create the graph and translate all the inputs and outputs of the computation algorithms
2. Baking into the algorithms the capability of dealing with arbitrary node IDs

Initially, I had thought that going with option 1 would create unnecessary obfuscation and, maybe, drive researchers and potential developers away, so I really wanted to consider option 2. This time, however, I decided to do the right thing and go with option 1, which turned out to me MUCH simpler than expected.

It is not all about increasing convenience, however. Moving forward with version 0.4, AequilibraE’s users will be forced to work on a slightly different fashion, as consistency between model components will start to be introduced throughout the software’s many tools. The first change is, maybe, the most important of all. As AequilibraE’s own matrix format is introduced, the graph built by users from geographical files will have to have a list of centroids that is identical to the index of the matrices being assigned and/or will return skim matrices with that same criteria being observed.

I don’t envision AequilibraE going down the Emme, VISUM or Aimsun path in terms of consistency between the files that are part their model databases, as I want to keep AequilibraE useful for researchers that want to take everything apart, but there is definitely some beauty in having parts of the model to be consistent with each other and a lot of simplicity in software development as a consequence of that.

This next version of AequilibraE will also bring a new naming convention. Following QGIS’ standard, all major releases will be named after a city. In AequilibraE’s case, the releases will be named after the cities I have lived in, started with my place of birth: Karlsruhe.