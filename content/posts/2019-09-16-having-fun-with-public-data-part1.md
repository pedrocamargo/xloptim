---
id: 466
title: 'Having fun with public data - Part 1 (obtaining the data)'
date: '2019-09-16T21:42:49+10:00'
author: pedro
layout: post
categories:
    - Uncategorized
---

This is is my first post that will, intentionally, have multiple parts (at least two, but not sure how many), and before anybody thinks I am about to deploy some sort of “cliff hanger”, let me just say that each part/post will make sense on itself.

But first, a little background.

A while ago, I purchased a mid-grade NAS to replace an old custom-built computer as our home server, as dealing with RAID arrays manually was being too much of a burden every time a drive failed or I needed more space. Around the same time, I started playing with [Docker containers](http://xl-optim.com/blog/2018-10-16-biogeme-docker/) in order to estimate discrete choice models using Python Biogeme. As the NAS I purchased does have the capability of running containers, I figured that I could start collecting real-time transportation data that is freely available online through some very easy-to-use APIs, which would give me a wealth of data that would be otherwise hard to obtain.

I also wanted to start playing with alternate datasets in model development tasks such as validation, purpose-built models, disaggregation of models and some general experimentation with machine learning.

As it turns out, there are three easy data feeds for the city of Brisbane that are relatively easy to use and that could potentially be used together in the future. The first two data sources I started collecting data for were [Brisbane’s CityCycle](https://developer.jcdecaux.com/) information on station status and [Translink’s GTFS real time](https://translink.com.au/). They abore both extremely easy to use, and in the case of CityCycle, the only hurdle you have to go through is obtaining an API key, which was incredibly painless. Well done, JCDecaux.

The third data source I started collecting was real-time traffic data from Brisbane’s SCATS, which has a not-so-friendly API (It actually looks to have something wrong about it), but after some fidgeting, it was possible to transform it in a pretty reliable data feed.

After collecting data for a few days, it became obvious that I would need something a little more robust than just an SQLite database for each dataset, as backing them up to the cloud would become impossible at some point. For that reason, I changed the data collection code in order to create an SQLite database per data source per day, which get moved to a folder (another docker container moving files once a day) that is continuously monitored and backed up to the cloud.

Now the shameful bit. I started this in late January 2019, and have now over 200 days (and counting) of data accumulated, without much hope of doing anything with it any time soon. Are you a researcher that is interested in collaborating in some research on this? Get in touch!

The code, which might or might not work for you, is all available as [open-source on my Github](https://github.com/pedrocamargo/real_time_data_collection).