---
id: 334
title: "AequilibraE's minor releases"
date: "2017-09-20T07:41:31+10:00"
author: pedro
url: /aequilibrae-minor-releases_0-35/
categories:
  - AequilibraE
  - GIS
---

Just as I wrote in my [last post](http://3.105.80.235/update_on_aequilibrae/), I continue to work on a major new release for AequilibraE, which will bring brand new matrix and tabular data formats, multi-class assignment (for traffic and Delaunay Lines). While chipping away on that task, I have been busy fixing [bugs reported on Github](https://github.com/AequilibraE/AequilibraE/issues?q=is%3Aissue+is%3Aclosed) (6 in the last 30 days).

This work of responding to bug reports and enhancement requests have resulted in a great improvement on the stacked bandwidths and scenario comparison tools, and AequilibraE has reached a state that is at least as good as the best features found in commercial software.

One of these features is the “expert mode”, which places all the data necessary for scaling bandwidths on QGIS project variables, allowing the user to fine tune their maps by changing those variables only, which makes this fine-tune incredibly faster. Kudos to [Brandon Peij](http://www.linkedin.com/in/brandonpeij) and [Michiel Jagersma](https://www.linkedin.com/in/michiel-jagersma-05ab1752/) for championing that change. Kudos also to these two fellows and [Stephen Pang](https://www.linkedin.com/in/stephen-pang-284780b6/) for investigating bugs elsewhere in the software and making their repair a lot easier.

The other new feature (which was actually lacking) is the possibility to set custom colors in scenario comparison. I honestly don;t how how did I miss it in the first place.

[Version 0.3.5.8](https://github.com/AequilibraE/AequilibraE/releases/tag/0.3.5.8) should be hitting the QGIS repository at any minute with all these changes!

The next major release, which will hopefully happen in the next month or so will be the 0.4, which will be the **last** major version produced for QGIS 2.x. On that note, I will keep supporting both version of AeuqilibraE (for QGIS 2.x and 3.x) for at least 6 months after the official QGIS 3 release, but no new feature will come to the older QGIS version after the new version is released.

I will also be upgrading the numbering of QGIS versions to be X.Y.Z (instead X.Y.Z.W), where X.Y are major versions and Z will indicate the minor versions. I also plan to release the 1.0 version only when the software can be considered a fully-fledged transportation modeling platform, including advanced traffic equilibration algorithms and transit assignment, which should take me at least another year to do. Until then we will be living with the 0.Y.Z versions.

If you are using the software, please contribute in some shape or form: Talk to your colleagues about it, train other professionals on its use, report bugs, blog about it, write code, write documentation or donate money. Let’s keep this alive!
