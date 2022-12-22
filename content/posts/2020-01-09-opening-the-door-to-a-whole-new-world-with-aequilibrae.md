---
id: 773
title: "Opening the door to a whole new world with AequilibraE"
date: "2020-01-09T06:01:35+10:00"
author: pedro
url: /opening-the-door-to-a-whole-new-world-with-aequilibrae/
categories:
  - AequilibraE
  - Algorithms
  - Python
  - Software
---

It was around the time I separated the [Python package from the QGIS plugin](http://3.105.80.235/separating-the-women-from-the-girls/) and started making AequilibraE a more serious software effort with unit tests, continuous integration, and documentation that I decided that I would eventually have to develop a more consistent API for AequilibraE.

That evolution, allied [TranspoNET](https://github.com/AequilibraE/TranspoNet) (_<span style="color: #ff0000;">**HOW THE HELL HAVE I FAILED TO BLOG ABOUT SUCH A MAJOR FEAT ACHIEVED BY MY GOOD FRIEND ANDREW O’BRIEN?!?**</span>_) made it a pretty obvious decision to develop AequilibraE towards being a complete modeling platform. One with a proper data model, data consistency tools, documentation and support that would allow researchers and agencies alike to opt for an open modeling platform.

However, regardless of such a conspicuous task ahead of me, all my previous attempts failed after no more than a dozen hours of work each time I started it (they were three if I recall correctly). Looking back, it is difficult to identify the exact issues with each such attempt, but, at a minimum, I was just not a good enough modeler or software developer.

Through this process, and having previously architected, estimated and implemented a number of modeling frameworks (nothing too complex, in truth), I now appreciate the fact that designing a general-purpose piece of software that would have the potential of supporting any number of bespoke modeling approaches is indeed a much more complex task than model development, so I am not surprised all my previous attempts failed. I am not even sure the current efforts will be completely successful.

But what has changed since my last fail? I am not a substantially better modeler today than I was one year ago (when I last failed). I am now a reasonably better software developer, but that is certainly not enough. My best guess is that there were many factors, but 5 of them do stand out.

1. **Being on the road**: Tons of international traveling has allowed me long periods to just think.
2. **Having fewer transportation-modeling issues on my mind**: As I have worked mostly on pure Operations-Research, my after-hours work on AequilibraE is less biased by my daily technical challenges
3. **I was able to finally visualize (even if I have not put on paper yet) what I expect from the final piece of software**
4. **Having a use case (a tool, actually) that was missing in the market and that would make a statement as the AequilibraE Project’s first feature**: Downloading modeling networks from OSM
5. **I understand DevOps a little better and can leverage a larger number of tools to make myself more efficient**

As one would expect, downloading networks from OSM began with a hard and deep look into [Geoff Boeing](https://geoffboeing.com/)‘s [OSMNx](https://github.com/gboeing/osmnx), which has become the de-facto standard in the Python ecosystem for doing network analysis with OSM data. After discussing it with Geoff, I dedicated many hours to refactoring the [OSMNx](https://github.com/gboeing/osmnx)‘s codebase and hoped I would be able to leverage its key download functions. However, after all the effort I put in (most of which was incorporated into OSMNx’s codebase), I concluded that it wasn’t possible no use OSMNx as dependency for AequilibraE. The problem I faced was that OSMNx is too tightly integrated with Geo Packages such as GDAL and Shapely, which are famously finicky on Windows. More than that, it would be virtually impossible to give the user a decent experience on Python or on QGIS. It was just not remotely practical.

I know that replicating code that already exists is a waste of time and that it fragments and weakens open source as a whole. However, AequilibraE needs to move forward and this was the only way I found. So I adapted some of Geoff’s ideas and wrote a few pretty efficient algorithms to identify intersections and have the most efficient graph possible in the end.

## **Downloading OSM networks**

As I was developing this new take on OSM downloading and processing, I also incorporated into AequilibraE’s [configuration file](http://www.aequilibrae.com/python/V.0.6.0/parameter_file.html#link-fields) a series of parameters that allow the user to choose any piece of information (tag) available on OSM to be added to the final network. Information often available per direction (number of lanes, speed, etc.) can also be downloaded as direction-specific and a few other final controls allow the user to download a network that is reasonably ready for modeling tasks with minimal post-processing.

In parallel, other configuration parameters allow the user to define which modes are allowed in each link type (“highway” tag in OSM speak) and how are exceptions handled within OSM. This mode information, which is then encoded in the network in one of its fields, allows the user to download multi-modal networks and create mode-specific graphs when it is time to perform computation such as skimming and assignment.

Testing the import of OSM networks into AequilibraE’s format entailed a gigantic number of imports for cities around the world. Testing special cases I know of, as well as testing the behavior of the software when downloading huge networks, and downloading data for places that use different alphabets were just some of my concerns, and that was excruciating at times, as I often did it over 4G (again, most of the work was done while on holidays with my family).

After much testing, I should say that the computational performance of the algorithms is somewhat disappointing. Small networks such as those for the city of Darwin take only 14 seconds to download and roughly 3 minutes to process, including the creation of database triggers and spatial indices, the latter being famously time-consuming for larger networks.

This processing time seems a little excessive for a network with only 13.7K links and 10k nodes, so I might profile the code in the future and try to understand what is going on (I might also try it on Linux and see if it is at all platform dependent). Downloading bigger networks revealed similar behavior, as one can see in the example below:

| City                   | Number of Links | Number of nodes | Downloading time (s) | Total time (s) |
| ---------------------- | --------------- | --------------- | -------------------- | -------------- |
| Darwin, Australia      | 13,700          | 10,200          | 15                   | 180            |
| Karlsruhe, Germany     | 74,500          | 56,200          | 30                   | 1,020          |
| Lisbon, Portugal       | 132,700         | 98,700          | 51                   | 1,670          |
| Madrid, Spain          | 265,200         | 185,000         | 98                   | 3,580          |
| Nepalk (whole country) | 10,998,000      | 8,427,400       | ~5,000               | 106,200        |

One should note that most of the time taken to download the Nepal network was actually due to built-in delays so that we don’t overwhelm the OSM servers. In any case, downloading an entire country’s network (or 11MM links worth) is not only not practical during download (all those seconds amount to nearly 30h), but it is also incredibly time-consuming to perform any computation with a network of that size, so so I can’t imagine that anyone would attempt to do any many complex operations with such a network.

Do you want to see what these networks look like? [Here they are](https://drive.google.com/drive/folders/1EqDfxblngt3hsx6sS-SQ70OV8itWBi2B?usp=sharing)!

## **Launching it**

I still have a few more tests to run and some DevOps tasks to finalize before I release version 0.6 of AequilibraE, which will contain all the OSM work mentioned here and, perhaps, a little more.

I also need to to bring this new set of features to AequilibraE for QGIS and to start connecting other AequilibraE features (e.g. graph creation and traffic assignment) with the AequilibraE project, but the latter will probably be a year-long job, while the first one will probably be ready by the time I land in DC for TRB.

In any case, I still need to Launch AequilibraE [V.0.5.3](https://github.com/AequilibraE/aequilibrae/pull/79), which brings some important bug fixings and the first work on the compiled code in quite a while.

## **TRB Anual Meeting**

As I fly to the TRB Annual meeting, I am looking forward to hearing from practitioners and researchers that follow this project what are the features they would like to see in AequilibraE and what are the opportunities for collaboration in 2020. See you in DC!
