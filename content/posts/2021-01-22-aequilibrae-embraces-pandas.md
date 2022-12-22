---
id: 1017
title: "AequilibraE embraces Pandas"
date: "2021-01-22T15:16:23+10:00"
author: pedro
url: /aequilibrae-embraces-pandas/
categories:
  - AequilibraE
  - Python
  - Software
---

If one takes a look at the AequilibraE code, they will find an unusual amount of NumPy gymnastics that would definitely point to a world with no Pandas.

It is the case, however, that Pandas is not only alive and well, but it also has a large number of features that would greatly accelerate the development of AequilibraE and, in the case of I/O, greatly improve its performance.

So why haven’t I started using Pandas when I first launched AequilibraE in 2014? Because like any software that uses Python as their scripting language, QGIS for Windows ships with its own Python distribution which did not include Pandas until a just few short months ago.

Having scarce resources to develop the software (sleepless nights, basically), has meant that I had to work with what was available in the environment I was working with, and pleading for changes in the upstream infrastructure (I have inquired about the inclusion of Pandas a few years ago) was the most I could do.

The arrival of Pandas on QGIS for Windows has not solved all problems, however. I would love to adopt OMX (and its likely new version) as the default for AequilibraE and to drop its native format on disk, but the lack of PyTables on the QGIS Pandas installation means that the use of OMX is not straightforward. The same goes for the lack of an ORM that would allow me to write much more elegant and robust code to deal with the project database.

I believe that Windows will eventually have a systemwide Python installation or at least a smarter system to handle Python versions to make things easier, but until then AequilibraE will always be behind the curve when it comes to using other Python libraries.

## What does it mean for AequilibraE’s legacy code?

Very little for now. All that gymnastics wasn’t for nothing, so there is little reason to change things that are working and highly performant just to _save_ a few lines of code. After all, re-factoring software is not only time consuming, but it also brings along a substantial risk of adding new bugs to old code.

That said, the **Graph** class is being re-factored as of January/2021, but I am not sure much more will come after that in the coming months.

## What does it mean for AequilibraE’s I/O?

A LOT. The new version of AequilibraE (0.7.0, just released) is moving much of its tabular outputs from binary/text to SQLite, which can be written incredibly fast with Pandas and matches really well the existing model structure and overall software architecture. Users have now access to a great deal of new functionality and a much more seamless user experience.

## And what’s next?

Before I work on the QGIS plugin for this new AequilibraE version, a substantial improvement in traffic assignment performance can be expected, but the the need for updating the QGIS plugin is not lost on me.
