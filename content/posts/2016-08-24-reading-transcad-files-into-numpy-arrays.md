---
id: 276
title: "Reading TransCad files into Numpy arrays"
date: "2016-08-24T11:01:08+10:00"
author: pedro
url: /reading-transcad-files-into-numpy-arrays/
categories:
  - Python
  - TransCAD
---

This is a very short post, mostly because I was not really planning on making it. However, a few colleagues of mine that work with TransCad asked me about some pieces of code I wrote almost two years ago to import TransCad matrices and binary files into Numpy Arrays.

They asked me why I never published it, and the answer was **_I don’t know._**

These libraries were never too sophisticated, and were mostly developed so I could go seamlessly from TransCad’s modelling outputs to Python and so some _less-than-conventional_ modeling and data analysis, for which GISDK is just not suitable for.

I should say that I never tested this code with TransCad 7.0, but it worked brilliantly with TranCad 6 Release 2. It does require a TransCad license to read the matrix files, but the binary files can be read without a license in the computer, which can help you in a bind. The only thing you need to do is to change the path to your matrix dll inside the tcw_mtx.py file, which might be different than what was there.

I also no longer have access to TransCad, so I can’t really help with any further development of this for now.

The code is [here](https://github.com/pedrocamargo/tcwpy)
