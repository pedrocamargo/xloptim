---
id: 376
title: 'Separating the women from the girls'
date: '2018-07-01T04:25:45+10:00'
author: pedro
layout: post
categories:
    - AequilibraE
    - GIS
    - Python
    - 'Transportation planning'
---

The topic of this post is something I have been wanting to do since I published version 0.3 of AequilibraE, back on [August 2016](http://3.105.80.235/new-version-of-aequilibrae/): Separating the aequilibrae python library (the computational engine that underlines most of the AequilibraE procedures) from the GUI part of the software (which is the QGIS interface). The goal? **Being able to “pip install” AequilibraE and script models in any python (3) environment**.

Although the desire to do this change comes from quite a while back, I have only known acquired the knowledge and had the energy to implement this change (and the help of the wonderful [Yu-Chu](https://www.linkedin.com/in/yu-chu-huang/)), which comes in the wake of the conversion of AequilibraE into QGIS 3.

The migration of AequilibraE to Python 3 and QGIS 3 will not bring great new features to regular users, but a number of important upgrades are being done to the software, all which are not particularly simple for a non-software developer like me. These changes are:

- Comprehensive set of integration tests covering 77% (so far) of the code in AequilibraE
- Continuous integration structure for AequilibraE, guaranteeing that only code that passes all tests will be merged (only for Ubuntu on [Travis-CI](https://travis-ci.org/AequilibraE/aequilibrae) so far)
- Replacement of the manual logging scheme with the Python logging module

From a repository perspective, a couple of changes were required. There is a new [repository](https://github.com/AequilibraE/aequilibrae) to manage, which contains just the Python library, and the [original repository](https://github.com/AequilibraE/AequilibraE-GUI), which was renamed and now contains just the QGIS interface and includes the aequilibrae library as a submodule and main computational engine (NumPy, SciPy, and others are also used as computational engines for some algorithms).

The next steps are clear, and I would appreciate any comments and/or help on any of these items:

- Setup of a more comprehensive continuous integration infrastructure (Mac and Windows)
- Setup of automatic builds of Python wheels within the continuous integration infrastructure
- Improve the documentation of the AequilibraE library and create API automatic documentation
- Finalize the migration of AequilibraE into QGIS 3 and release it
- Make the final release of AequilibraE for QGIS 2 (includes GTFS importer)
- Make the first release of AequilibraE for QGIS 3
- Make AequilibraE pip-installable

An (atypical) aside:

While thinking of what this change meant for the AequilibraE project and its users, the expression [separating the men from the boys](https://idioms.thefreedictionary.com/separate+the+men+from+the+boys) came to mind. However, I decided to switch it to “separating the women from the girls” in reference to the important times we live in western culture ( I also started writing this post about 6 months ago, right before I postponed this undertaking). After all, we should look above our monitors every once in a while and understand and criticize the environment we live in.