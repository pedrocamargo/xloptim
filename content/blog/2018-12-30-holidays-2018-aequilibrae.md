---
id: 426
title: 'Holidays & AequilibraE'
date: '2018-12-30T21:57:16+10:00'
author: pedro
layout: post
categories:
    - AequilibraE
    - GIS
---

Let me start by saying that AequilibraE is probably my favorite project, but I have been neglecting it for a while. Just for some perspective, QGIS 3 has had three major releases (3.0, 3.2 &amp; 3.4) and I have not yet released a version of AequilibraE that is compatible with this new platform. That is not to say that I have not worked a fair bit in it in the past few months, because [Yu-Chu](https://www.linkedin.com/in/yu-chu-huang/) ; I have worked quite a bit on it, but I did not show the commitment the project deserves.

The main cause for such neglect was the incredible pressure I was under at work. There were several months of working long hours in a project that, in hindsight, should have been structured differently. Things you learn in consultancy. After that much pressure, I actually needed to decompress during the first few days of our 2 weeks office closure for the end of the year holidays (I know how good that sounds if you are in the US or some other country that is very stingy with paid time off). But I am back now, and have been working quite a bit since Christmas.

Because of all the work Yu-Chu and I had put on, I initially thought that releasing AequilibraE would be a rather easy affair, as we had already converted most of the GUI and GIS algorithms to Python 3 and the computational engine for the transportation processes was now in a [separate repository](https://github.com/AequilibraE/AequilibraE). When I went over the software with a fine-toothed comb, however, I realized that there were many instances where the software was not behaving as expected. Some of the problems I found (and list here more for documentation than for anything else) were:

- There was no error-catching in the trip distribution processes
- Traffic assignment was not generating skims: It turns out that the feature was never implemented in the computational engine
- Simple-Tag did not have clear rules about what were operations were possible with point, line and polygon layers, nor did it work in a intuitive manner
- Lowest common denominator was generating wrong area proportions for one of the input layers &amp; did not behave properly when dealing with layers in different projections
- The result of a difference between assignments in the scenario comparison tool was done with a non-intuitive manner (base *minus* alternative)
- The scenario comparison and stacked bandwidths tools did not generate clean styles, with the previously existing styles being left behind. The result was an often polluted map that QGIS users that are not particularly skilled in layer styling had a hard time fixing. It was not a big deal, but fixing it resulted in MUCH better maps out of the box.

Long-story-short, I was expecting to release AequilibraE for QGIS 3 as a Xmas present, but it ended up taking me almost a week to produce a release that will do what its users need. This first release was tagged as experimental, since it is the first release in this new platform and I don’t have a very sophisticated testing infrastructure.

It is also worth mentioning that this whole process also allowed me to report a series of bugs and opportunities for enhancement in both the computational engine &amp; the GUI repositories, and that will most likely constitute a substantial part of my work pipeline for AequilibraE in the coming months. On that note, please remember that if you want to see any feature coming to AequilibraE, the easiest way to start the conversation is to create a new issue in the appropriate repository ([QGIS GUI](https://github.com/AequilibraE/AequilibraE-GUI/issues) or the [computational engine](https://github.com/AequilibraE/AequilibraE/issues)). Maybe you or some other interested party or entity can fund the development of that feature, or some skilled developer out there want to make this an opportunity to contribute and hone their skills in the process. If not, there it goes one more thing on my to-do list!

And just in case you are a mac user, the binaries are still not ready for your platform, but I will announce on [Twitter](https://twitter.com/pedrocamargo) when they become available (nothing will change in the plugin itself). And the mac binaries are ready and available!! Kudos to [Jamie Cook](https://www.linkedin.com/in/jamie-cook-91848b/) for producing them!!