---
id: 195
title: 'Introducing AequilibraE for QGIS'
date: '2014-12-16T04:50:04+10:00'
author: pedro
layout: post
categories:
    - AequilibraE
    - GIS
    - Python
---

Back in January 2003 when I started my career in transportation planning as an intern at [Logit](http://www.logiteng.com/ "Logit"), my main tools as far as software went were MS Excel and TransCad (sometimes Maptitude). I would do all the modeling in Excel/VBA and use Transcad for assignment and visualization, and would always rely heavily on the visualization as one of the ultimate sanity checks to be done before sending the results to the clients.

If in one hand my training was great, in the other hand I grew dependent on looking at maps to analyze my results, and when I saw myself without a TransCad license in my subsequent job, I had to start using other tools, such as ArcGIS, which are not geared towards transportation.

So when I started my Ph.D., I decided that I would choose free software anytime it was comparable to the top proprietary software in order to never find myself without my favorite toys.

This mindset guided me towards Python/Cython instead of Matlab and GDAL/QGIS instead of ArcGIS. The idea was that if I ever ended in a company that did not have a particular software I would not have to start from scratch on a new tool for budgetary reasons, which is even more important when I do independent consulting work.

Unfortunately, I could not find any suitable free software to substitute TransCad, so I started developing algorithms every time I had to solve a problem. Nothing fancy, just the standard algorithms we use every day in the profession. That was the case of the All-or-Nothing assignment and Trip distribution, which already deserved each one a post in this blog, Frank &amp; Wolfe-based equilibrium assignment and custom outputs for tags and overlays.

The only problem is that most of the software I wrote, including the AoN assignment, was completely decoupled from any GIS software and lacked decent user interfaces, which was self-defeating in away.

Parallel to all this, several colleagues of mine came to me asking questions about TransCad and QGIS, specifically on how to perform some tasks we perform every day in the transportation planning software. Merging the software I had already written onto a QGIS plugin seemed to be a natural route, especially since it would help me develop my PyQt and GIS skills.

This is how AequilibraE was born. At this point, I have put already several hundreds of hours in its development and I believe it can be already useful, as well as can be tested by multiple people willing to contribute with comments and bug fixes

It is being released as FREE AND OPEN SOURCE (no warranties provided, of course), and I welcome any contribution made to its development.

To access all materials related to AequilibraE, please access [www.aequilibrae.com](http://www.aequilibrae.com "www.aequilibrae.com")

The development of AequilibraE continues in the rhythm of nights and weekends only, and I am currently working on a truly multi-threaded assignment library, which might be ready before the 94th TRB.