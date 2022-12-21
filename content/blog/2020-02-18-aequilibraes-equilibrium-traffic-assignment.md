---
id: 311
title: 'AequilibraE equilibrium traffic assignment'
date: '2020-02-18T05:00:27+10:00'
author: pedro
layout: post
categories:
    - Uncategorized
---

Traffic assignment is a cornerstone of any transportation modeling software, and regardless of what you are using it for (consulting or research), a capable traffic assignment tool/software/algorithm is often a required tool for a successful outcome.

Even though it has taken me some time to appreciate the fact that the modeling practice also needed an open-source alternative, I quickly realized that my own research at [ITS-UCI](https://www.its.uci.edu/) could not rely on commercial software when I was rudely refused access to some of the **RESULTS** of their traditional link-based traffic assignment procedure by one vendor (I did not procure other vendors at that time). That particular incident sparked the creation of the [first bit of software](http://www.xl-optim.com/blog/2013-10-18-python-traffic-assignment/) that would, in time, become AequilibraE.

For years, however, I was caught on trying to develop every single bit of functionality a traffic assignment procedure would have (select-link analysis, sub-area analysis, etc.), and ended up never going past All-or-Nothing assignment, a testament that I was not focusing on users’needs, but rather on my own vision of what the software should be capable of doing right off the bat. It was a mistake that has cost AequilibraE (and its users) many years.

But no more. On Sunday night, AequilibraE’s version 0.6.1 moved into its final phase (code review), and it has now been released, bringing [sophisticated multi-class-multi-user traffic assignment](http://www.aequilibrae.com/python/V.0.6.1/traffic_assignment.html), competitive performance, and comprehensive documentation for it. It may not yet be able to compete toe-to-toe with commercial software, but is a MUCH better value-for-money. ;-).

The four algorithms that are now available in AequilibraE are the following:

- Method-of-Successive (MSA)
- Frank-Wolfe
- Conjugate Frank-Wolfe (CFW)
- Biconjugate Frank-Wolfe (BFW)

To test these algorithms, we have used five instances from [Transportation Networks](https://github.com/bstabler/TransportationNetworks/), maintained by Hillel Bar-Gera and Ben Stabler, varying from the traditional Sioux-Falls network, up to the large Chicago Regional model, with over 39,000 links and nearly 1,800 zones.

We have gone through the development of a fairly comprehensive computational study of all equilibrium algorithms we have developed by comparing the best-known link-flow results to our own link flows after 500 iterations, reporting the RMSE, overall regression fit and the relative-gap we have reached. This [computational study](http://www.aequilibrae.com/python/V.0.6.1/traffic_assignment.html#numerical-study) can be found on AequilibraE’s brand-new documentation page, but the convergence analysis below would give you a little taste of it. I am certainly biased, but I think it looks awesome.


![convergence_comparison](/blog/img/convergence_comparison.png)

If on one hand, it took me years to finally develop equilibrium assignment, on the other hand, it comes when AequilibraE has proper documentation, testing, and a much more sophisticated software development infrastructure around it. One may still ask: Why now? Why ONLY now, if it only took a month to develop?

Well. The answer is a lot simpler than one could think but is one that will ring familiar to anybody who has worked with Open-Source before. My brilliant friend [Jan Zill](https://www.linkedin.com/in/janzill/) had, all of a sudden, a few weekends and many nights on his hands. Not being one to miss such a great opportunity, I enlisted him to help me with the implementation of Equilibrium assignment within AequilibraE. So if you want to thank somebody for the excellent work on those algorithms, thank him! He did all the complicated bits.

Now, it is worth mentioning, two of the most critical pieces of AequilibraE have been contributed by other people. While Jan has done the equilibrium traffic assignment, [Andrew O’Brien](https://www.linkedin.com/in/andrew-o-brien-5a8bb486/) has contributed with the network editing work (something I am yet to blog furiously about). Having AequilibraE be a truly collaborative project feels absolutely amazing!!

**What now?**

The QGIS plugin is the part that is lagging behind, but the initial work based on AequilibraE’s Project (version 0.6.0) already laid the path I will trail, so it should be a somewhat troubleless development. The Plugin will also come with at least one example project suitable for training and teaching, which is something that has been requested frequently.

Any offers to translate the upcoming tutorial into other languages?

Two final thoughts

1. I think AequilibraE has finally reached a point where it is ready for its first deployments in practice.
2. I owe a big debt of gratitude to Jan &amp; Andrew for all the hard work and remarkable expertise they so willingly put into AequilibraE. My biggest debt is, however, to my amazing wife and great kids, who have graciously allowed to dedicate my time to this project while bringing me lunch and iced tea to my desk.