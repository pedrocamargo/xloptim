---
id: 328
title: "An update on AequilibraE"
date: "2017-08-12T08:38:53+10:00"
author: pedro
url: /update_on_aequilibrae/
categories:
  - AequilibraE
  - GIS
  - Python
---

A few of my readers have noticed my absence on this blog and the seemingly slow development of AequilibraE, so I decided to share what is going on and what the plans are for the next 6 months.

The current version of AequilibraE (0.3.5.x) is the most powerful and robust version of AequilibraE yet, with emphasis on <span style="text-decoration: underline;">robust</span>. This is the first version that had consistent answers to bug reports and followed with a few minor releases correction each one of the reported bugs.

To develop new features, however, I realized that they would require more of basic resources. Namely, things such as multi-class assignment (which also applies to Delaunay Lines) requires a proper matrix format, which has never been available in AequilibraE (all computation relied on matrices being imported “on-the-fly”).

Developing a matrix format that is both efficient and robust was no easy task (there is a reason why traditional software keeps its matrix format/routines so close to their chests), but I think I reached a pretty good compromise using some rather obscure features on NumPY originally developed to support MatPlotLib features. I will write more on that in the future.

Developing the matrix format opened a huge can of worms, leading me to develop a data format for keeping the binary data used in all procedures (such as zone-based data, assignment outputs, etc.) and re-factoring all procedures on trip distribution. It has been a daunting task.

On the bright side, I have decided to do the re-factoring while writing unit tests for all the code I touch, which means that the software should be much more robust going forward. It is a lot more work than just doing the re-factoring, but I am really enjoying developing “proper software”.
