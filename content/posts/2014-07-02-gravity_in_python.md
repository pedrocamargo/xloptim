---
id: 88
title: "Gravity distribution model in Python"
date: "2014-07-02T07:05:56+10:00"
author: pedro
url: /gravity_in_python/
categories:
  - Algorithms
  - Python
  - Transportation planning
  - Rant
---

WARNING: THIS CODE HAS BEEN DEPRECATED. FOR THE NEW STUFF GO TO <https://github.com/aequilibrae/aequilibrae>

If you had looked at this blog before, you probably already realized that I am all for sharing knowledge and tools, rather than keeping everything to myself and feeding the bad habit people in our field have of re-inventing the wheel every single time.

I had an example of the of lack of people sharing tools for transportation modeling very recently, when I had to calibrate some synthetic gravity models for research I am doing for [IPEA](http://www.ipea.gov.br/ "IPEA") (The Brazilian Economic Research Institute), in Brazil. Well… Gravity models are being calibrated for over 4 decades now, so I expected to find code samples in several programming languages. I thought C/C++ would be an easy one to find, and hopefully something in Python, but I found NOTHING, actually.

I don’t really know if I was more surprised or disappointed at my colleagues for not sharing what I am sure they did in the past. And my surprise does not come from the fact that I would expect people to share, but rather from the fact that people are sharing a LOT in other markets, such as computer science and operations research. Try to look for code samples, spreadsheets, and examples of any algorithm or famous mathematical problem that there is out there and you will find tons of materials that you can use free of charge to do what really matters.

The question that I was left with was: What do people gain from not sharing such basic work? Do people think they will make more money if they don’t share their knowledge? I honestly don’t.

But enough of crying and complaining. I ended up implementing some tools in Python (using mostly NumPy) that I’d like to put up in the open world:

1. A simple implementation of a growth factor method (Fratar);
2. A function to apply gravity models for all three regular functions (Exponential, power, and gamma);
3. A library to calibrate gravity models (for exponential and power deterrence functions);

After implementing the algorithms I had a friend at UCI testing them against TransCad’s results, and everything seemed correct, but I would really appreciate if somebody could do some checking of my code and the results.

Although there are more efficient algorithms that are rather easy to implement, I decided to implement everything as prescribed by Ortuzar and Willumsem in “Modelling Transport”. If I did not reach maximum efficiency for my algorithms, I sure got pieces of code that can be easily followed by my colleagues at [IPEA](http://www.ipea.gov.br/ "IPEA") and by future users (probably students) of it.

Further, I only implemented the calibration of exponential and power functions because they have a single parameter, which is extremely easy to calibrate the line search prescribed in Ortuzar and Willumsem’s book. In the future, I might implement the calibration of friction factor models, application tri-proportional fitting and calibration of the parameters for the gamma function with something simple like a Hooke and Jeeves approach or even something fancier, but that is subject for another day.

So you can download the code (and example) [HERE](http://xl-optim.com/site/distribution/TripDistribution.zip). Along with the code, there are samples of entry data and a small read me file. I also made the code available in an online code repository (Bitbucket), so you can close the repository, submit patches and fork it if you want to do so (and know what all this means). Repository: [HERE](http://bitbucket.org/pedrocamargo/tripdistribution/ "HERE").

I hope it is useful to somebody out there.
