---
id: 95
title: 'Calling TransCAD from Excel'
date: '2013-05-06T03:29:35+10:00'
author: pedro
layout: post
tags:
    - GISDK
    - VBA
    - Excel
    - TransCAD
---

One of these days my Ph.D. advisor, [Prof. Michael McNally](http://www.its.uci.edu/~mcnally/mgm-home.html) asked me if I knew how to access TransCad through another software, say MS Excel, and how difficult it would that be. I told him that it was actually quite easy and could share some examples, but I also thought that it could also make a good post.

Once you are passed learning how to use TransCad and you are in actual “professional production mode”, you realize that doing things manually is just not feasible. Imagine some situations:

- Creating individual maps for every single transit line in a city like Rio de Janeiro, Brazil, which has over 2.000 different services; or
- Analyzing (extracting results for) the impact of hundreds of toll configurations on a given little area.

Doing either one of them manually would be just plain insane and very prone to errors. Now imagine something even simpler:

- Re-generating all map images for a certain project with a slightly different resolution for a report that has to be ready today.

Situations like these are those that really test one’s particular skill with any transportation planning/GIS software: Scripting. Nothing new, right?

On a similar problem, could it be easier to develop good user interfaces (with more resources and more user friendly) on software like TransCad or Cube?

Both cases would be a matter of using TransCad (or Cube, Emme, Visum, etc.) only for what it is great at and leaving the rest for some more appropriate tool. What about using TransCad as a highly specialized library in a more complex modeling/planning/tool development effort? Or just using TransCad to generate results that will be analyzed/processed on MS Excel?

TransCAD, for example, already has a Python binding, .NET integration and you can get access to its matrix dll if you contact [Caliper](http://www.caliper.com/) (they used to give access to this dll to some of their clients), but its use is not that straightforward, and the syntax is the same “kinda weird” GISDK syntax. Could it be better? I guess so, but I’m not a computer scientist to be sure of that…

On a side note, the interaction between TransCad and Python/.NET is through DCOM, which is not what I would wish for (putting results straight into Numpy array for efficient manipulation in Python would be much better)…

Anyhow, I feel like software houses do not really want to move in that direction since its documentation and examples for integrating with other programming languages are always very thin. It kinda makes commercial sense, but I do not work for any of them and am have only the user’s perspective.

Regardless of all that, how would you solve question number 3? Well, searching for files and creating iterative procedures in Excel’s VBA is a piece of cake. The idea here is, then, to have a VBA macro that will capture the location and names of the TransCad maps (\*.map) and send to a TransCad macro that will receive these pieces of information along with the name and location for the corresponding \*.jpg file, open the map and save the jpg file.

For this procedure there are the following steps:

1. Create the TransCad macro;
2. Compile the TransCad macro;
3. Create the Excel macro;

Since the detailed procedure is a bit boring to be written down (and because I’m terrible at writing tutorials) I recorded a video with the instructions, and the files used there are available for download [HERE](http://xl-optim.com/site/tcw_from_excel/TransCad_from_Excel.zip "HERE").

Please keep in mind that this is a VERY simple example, and has as its sole purpose to illustrate how one would access TransCad from and external software.

{{< youtube id="MWWZN2JWG7U" >}}