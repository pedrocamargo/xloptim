---
id: 65
title: "Python's Traffic assignment module (All or Nothing)"
date: '2013-10-18T21:45:33+10:00'
author: pedro
layout: post
categories:
    - 'Operations Research'
    - Python
---

WARNING: THIS CODE HAS BEEN DEPRECATED. FOR THE NEW STUFF GO TO <https://github.com/aequilibrae/aequilibrae>

Lately, I have been dealing a lot with traffic assignment problems of several types, but mostly All or Nothing and user equilibrium in some not so large networks. It is true that I could use something like Cube or TransCad, but I find TransCad post-processing capabilities not ideal if you want to do some non-standard analysis and Cube is even worse, as the GIS interface is very slow (the whole rendering thing is much slower than TransCad).

Ideally, I’d like to have an assignment procedure that returned me all the results in NumPy arrays, which results in a lot of firepower for data analysis and a vast array of libraries and free code to use.

Writing an assignment algorithm in pure python would be just silly, as the performance would be extremely poor, but there is a very nice tool called [Cython](http://www.cython.org). Basically, [Cython](http://www.cython.org) allows you to write code in a mix of Python and C that is translated into C code and compiled to a Python library. I sounded like magic to me at first, and it sure is VERY good.

In parallel with this discovery, I also found a very good implementation of a Dijkstra algorithm inside [SciPy](http://www.scipy.org) written by [Jake Vanderplas.](http://jakevdp.github.io/) It is true that the implementation could be improved by replacing the Fibonacci Heap with a simple Min Heap, but the difference would likely be very small.

Having Cython and the code Jake wrote (all in Cython) made things extremely easy, and I decided to share with people out there that might need it. It is important to note that the AoN library I generated is NOT DEPENDENT on Scipy, and the sparse matrix used by Jake is actually a forward start, which I just substituted by a forward star code I wrote myself.

I’m posting here two different packages:

1. A compiled code to use with a standard installation of Python 2.7.x and NumPy 1.7.x (32bits) - [Calling TransCAD from Excel](http://xl-optim.com/site/AoN/AON.zip)
2. The [source code](http://xl-optim.com/site/AoN/AON_SC.zip) in Cython and all the necessary files to compile the code

Both packages come with the examples I used, being a graph and a demand matrix so you know exactly what is the format I’m using (the NumPy arrays I use in the library have the exact same structure of the CSV files).

Some things you will have to take care of by yourself if you want to use it fully on an assignment:

1. Remove the outbound centroid connectors for all links that are not the origin of the flows each time you assign one to all so you don’t have flows through centroids
2. Make the code parallel, which is extremely easy.

The performance of the code is very good, and usually about 30% to 40% slower than TransCad for the instances I tested on, but if you take into consideration the time it takes to migrate from one platform to another to perform analysis, then you can save time by using the code. Cube has a similar performance to TransCad (all tests using multiprocessing in all software). And this one is FREE, which makes quite a difference… Right?

I also already implemented an equilibrium assignment using the traditional Frank-Wolfe and will try to make it available soon…

Again, comments are very welcome and so are questions.