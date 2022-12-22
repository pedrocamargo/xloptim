---
id: 61
title: "Cube's log file"
date: '2013-04-09T06:22:03+10:00'
author: pedro
layout: post
tags:
    - Cube
    - Python
    - QGIS
---

I already posted some stuff about [CSFFM](http://www.dot.ca.gov/hq/tsip/otfa/csffm/index.html), and I still have a couple more to post (many more after TRB papers are submitted) and this time I’ll talk a bit about the network editing procedure we went over.

We started to develop our network based on the [previous version](http://ultrans.its.ucdavis.edu/doc/california-statewide-transportation-demand-model) on the passenger model (from which we borrowed the network and which had a very poor documentation), and ended up having a late start on integration with the new version of the passenger model being developed by [CamSys](http://www.camsys.com/).

After all the back and forth with the network between UCI, Caltrans and CamSys, there were decided that we would have to throw our Cube network away and provide a log file of the changes we had done to CamSys to add to their network, which would be the “master network”.

For those who don’t know cube, this log file feature is a VERY nice thing in the middle of a very poor set of editing toolboxes (poor in terms of user experience). It allows you to save all the changes you perform on a network to a text file and, then, apply those changes to another network file.

Luckily enough, we had adopted a very conservative approach in doing our network changes, generating additional shapefiles with the added links (road and rail outside California and Rail inside it) and only then merging the files, leaving just some connecting work to be done manually.

At that point we thought we would be done in no time, as we could just do the network merging, generate the logfiles and send them to CamSys.

We could not be further than the truth. Network merging does NOT generate logfiles (confirmed by Citilab’s costumer service). So the question was: How to generate the logfile? Editing dozens of thousands of links by hand was completely out of question.

It turns out that the logfile has a VERY simple structure (one of the good things about it), so we could generate them using some scripting language. We still needed to have all the node IDs and data fields correctly in place, but that would be easily accomplished. There were a few very easy steps.

1. Using [QGIS](http://www.qgis.org/), we prepared our network making sure we had the fields of A Node and B Node and all the other fields we would need;
2. We imported those shapefiles to Cube and checked for compatibility problems (due to wrong projection systems used, for example);
3. We exported the DBFs for Links and Nodes of these brand new network files;
4. Converted the dbf files to csv (to make it easier to handle with Python);
5. Made a bogus change on our network to generate a log file;
6. Copied the header of the log file to our soon to be log file;
7. Ran our python code to generate the log file.

The procedure turned out to be so simple, that we decided to maintain all the network database on a appropriate database format (PostGIS) and generate logfiles with alterations on the link table as we do them on the database environment.

I may do a video tutorial on this in a near future, but, for now, I’ll just make available an example of the whole procedure. Please keep in mind that I altered the example to avoid having too much data on it (so I only update link type and length on the cube log file I generate).

[DOWNLOAD](http://xl-optim.com/site/cube_logfile/Cube_log_file.zip)

PS – The opinions stated here ARE NOT the opinions of the University of California or any of its staff, reflecting SOLELY the opinion of this article’s author.