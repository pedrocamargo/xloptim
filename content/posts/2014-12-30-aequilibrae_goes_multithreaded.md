---
id: 219
title: 'The next step for AequilibraE: True multi-threading'
date: '2014-12-30T04:23:01+10:00'
author: pedro
layout: post
categories:
    - AequilibraE
    - Python
---

When AequilibraE has launched a couple of weeks ago, it was already clear that using multiple CPUs would be a requirement for it in the near future.

For software developed in Python, however, parallel computing is always a challenge due to the existence of the [GIL](https://wiki.python.org/moin/GlobalInterpreterLock), which prevents a single instance of Python of using more than one processor. (if you want to know more about the GIL, [this presentation](http://www.dabeaz.com/python/UnderstandingGIL.pdf) is excellent, but you have to keep in mind that most of what we do in AequilibraE is CPU bound). Could we use multiprocessing? Absolutely. But the overhead caused by memory copying operations and memory use itself are considerable, which would greatly increase memory needs when other tools (such select link analysis) are implemented.

Fortunately, the core algorithms of AequilibraE were developed using NumPy arrays and [Cython](http://www.cython.org), which basically open a door to C/C++ and eliminate the need for the GIL. I then proceeded to re-write the AoN library to build a One-to-All assignment function that would release the GIL and allow for native python use of multiple cores.

And why not letting the Cython code do the job and handle the multiple threads? The answer is simple. AequilibraE is meant to be multi-platform, and the multi-processing framework supported by Cython (Open-MP) is not supported on OSX (as far as I understand it), which precludes us from using the excellent [Cython parallel library](http://docs.cython.org/src/userguide/parallelism.html).

In practical terms, the work done consisted of three steps:

1. Identifying arrays and variables that were thread specific and those that could be shared among threads
2. Deciding how to store results in shared memory to consolidate everything after assignment was finished
3. Re-design the core algorithms according to the first two steps

I also took advantage of the opportunity to upgrade most of the code’s syntax to Cython’s latest standards, which should yield better performance and longer life.

Applying this new code to the problem previously used as an example (the Brazilian national planing network) yielded a speed about 5 times faster when running on a 1st generation Intel i7, which makes sense given the 4 physical cores and all the code optimizations that were implemented.

AequilibraE now has its AoN assignment fully multi-threaded with multiple threads supported in every platform QGIS and Python are supported.

Just as a side note, the assignment library can also be used outside AequilibraE in any custom code, provided the input files are properly set up. If you need a clue on how to use it, you can start by downloading [THIS](http://www.xl-optim/site/aequilibrae_goes_multithreaded/Multi_threaded_AoN.zip "THIS") set of files, which implements an assignment in parallel for a given graph e demand matrices.

To download the latest version you can access its Git repository at  
[https://bitbucket.org/<wbr></wbr>pedrocamargo/aequilibrae](https://bitbucket.org/pedrocamargo/aequilibrae)

Installation instructions can be found in the plugin webpage at [www.aequilibrae.com](http://www.aequilibrae.com)

For questions and contributions to AequilibraE, please use AequilibraE's user's group [Mailing list](mailto:aequilibrae@googlegroups.com)
