---
id: 282
title: "AequilibraE Linux support and desire lines"
date: "2016-09-11T05:13:08+10:00"
author: pedro
url: /desire_lines_and-linux_support_come_to_aequilibrae/
categories:
  - AequilibraE
  - GIS
---

The last few weeks have been quite busy for me, with a quick trip to the US, a short and sweet conference in New Zealand and the costumary TRB paper reviewing and committee business coordination. However, I got to finish two new features of AequilibraE.

- Desire lines (including the Delaunay lines I proposed about two years ago – [Original post here](http://3.105.80.235/delaunay/))
- Full support for Linux 64 bits (compiled on a Linux Mint 18)

The Desire Lines GUI features the brand new interface for importing matrices into AequilibraE, which continues to support NumPy arrays and text style (O, D, Flow) arrays. OMX support is also slowly coming into AequilibraE, but I still need to figure out fireproof instructions for adding pyTables and OpenMatrix to the QGIS Python installation on Windows, which is more cumbersome than I wished for.

I also started to produce the tutorial videos on this new version of AequilibraE, which you can check out on this [**playlist** on Youtube](https://www.youtube.com/playlist?list=PLdiSu_6yrzc5OtDnPXZ1PEAw2bEeEUJoY). I will keep adding videos on each AequilibraE feature and on those that will be added in the coming weeks, so check back on this playlist often.

The Linux support is not quite trivial, as you need to install QGIS 2.16 (Not the standard for Linux installation) and Scipy. In turn, Scipy is only required to do the Delaunay Lines, so all the rest should work if you are only missing that.

Since I had to go through this process of software installation, I will put here what I had to do to get it running. Easy enough to do, and you should be used to this type of software installation if you are a Linux user.

1. Installing QGIS 2.16: [Instructions](https://www.youtube.com/watch?v=M0fWYrk2NRE)
2. Installing Scipy (if you don’t have it):

   `sudo apt-get install python-numpy python-scipy`

I also hope to announce some new contributors to AequilibraE soon, and if you think you can help (From making the website to using the software, preparing examples and writing code), just let me know.
