---
id: 1073
title: "We need to talk about the trust we put on software"
date: "2021-12-17T11:26:08+10:00"
author: pedro
menu:
  sidebar:
    name: We need to talk about the trust we put on software
    identifier: we-need-to-talk-about-the-trust-we-put-on-software
    weight: 20
url: /we-need-to-talk-about-the-trust-we-put-on-software/
categories:
  - rant
---

<span style="font-weight: 400">Before we begin, let us say that we will be speaking from a transportation modeling perspective, but there is no reason why this would not be true for other fields that rely heavily on (proprietary) software. Now back to the topic at hand.</span>

# <span style="font-weight: 400">The origin of our concerns</span>

<span style="font-weight: 400">There are many things in transportation modeling practice that are fundamentally heuristic and are a true mix of science and art. Take the specification of mode choice models, for example. It is perfectly reasonable to expect that the two best modelers you know would get to different model specifications (even demand segmentations) if you give them the exact same datasets to work with.</span>

<span style="font-weight: 400">Traditional link-based user-equilibrium static traffic assignment, however, is not in the </span>_<span style="font-weight: 400">do-as-you-please</span>_<span style="font-weight: 400"> category. Or at least it should not be. The industry’s understanding of what static traffic assignment is and the math behind it has been established for a while, including for multi-class traffic assignment. Or so we thought.</span>

<span style="font-weight: 400">To allow a better perspective of what brought us to this article, let’s go back to when Jan joined VLC (where Pedro worked for a while) in 2017. Being a physicist and mathematician, Jan had virtually zero knowledge of the transportation modeling field, but was eager to learn and had the drive and tools to dive into the most complicated stuff we had laying around. At that time, Pedro was trying to get VLC to improve its traffic assignment (a standard Frank-Wolfe algorithm at that time) by implementing the Biconjugate Frank-Wolfe (BFW), so he gave Jan the “</span>[<span style="font-weight: 400">The Stiff is moving</span>](https://pubsonline.informs.org/doi/abs/10.1287/trsc.1120.0409)<span style="font-weight: 400">” paper for Jan to read and see what he thought of it.</span>

<span style="font-weight: 400">Well… A month later, Jan came back with the math re-done (to make sure it was right and fill in some small missing steps) and the algorithm implemented.</span>

<span style="font-weight: 400">A year later, while discussing the issue of path overlap in route choice models, Pedro suggested that they looked into adding to VLC’s implementation of toll-choice model by implementing a Path-Sized Logit approach to deal with path overlaps (purely experimental), while equilibrating the assignment with the BFW algorithm he had implemented a short year before.</span>

The [resulting paper](https://journals.sagepub.com/doi/abs/10.1177/0361198119837496) was sorely missing in the literature, but not for the reasons we first thought. It turns out that equilibrating route-choice is something that the market doesn’t seem to be interested in taking up on, despite the long history of flirts between modelers and this elegant approach. Good for the literature, but not groundbreaking for the modeling practice.

<span style="font-weight: 400">As it turns out, the most relevant outcome of that paper was the full derivation of the multi-class traffic assignment we included there, which also included the derivation of the conjugate step directions for the case of the BFW.</span>

<span style="font-weight: 400">From the beginning, it was both an opportunity for Jan to go back to the math and re-derive everything, and also to finally have the full derivation of the problem somewhere in the literature. Jan did comment a few times that it was weird not to be able to find that derivation anywhere in the literature, even though the </span>[<span style="font-weight: 400">Dafermos’ foundational paper on multi-class assignment</span>](https://www.jstor.org/stable/25767636)<span style="font-weight: 400"> was already almost 50 years old at that point and that the use of the Bi-conjugate Frank-Wolfe algorithm had been first published in 2013 (and implemented in at least two different software packages as early as 2010, based on a working version of the paper as mentioned in footnote 2 in the published version).</span>

<span style="font-weight: 400">That should have been enough to suggest that this matter might not be clear for everybody. It wasn’t. Our bad.</span>

<span style="font-weight: 400">In the end, the fact that seemingly every commercial software provider had implemented the BFW and the results were reportedly generally OK, looked like strong evidence that everybody had understood Multi-class assignment and the BFW properly.</span>

<span style="font-weight: 400">Around that time, Pedro was evaluating several commercial software for a particular application and verified that one of the biggest software in the market had non-proportional class link flows, and those </span>**class link flows were dependent on the alphabetical order of the class names**<span style="font-weight: 400">. </span>

<span style="font-weight: 400">WHAT?!?! YUP. You read that right. What came across as insanity for us, had been in place for a few years and it was still the case last we checked (a fix was recently promised, but we do not know if it has been released yet).</span>

<span style="font-weight: 400">That was the first crack on our perception that there was a consensus in the market and that software makers were on top of it.</span>

<span style="font-weight: 400">We went back to that point several months ago, when Jan implemented support for a more general cost function for AequilibraE’s Traffic Assignment, weaving that in the many algorithms he had previously implemented (MSA, Frank-Wolfe, Conjugate Frank-Wolfe and BFW), while Pedro implemented a network simplification procedure that greatly improved the traffic assignment performance.</span>

<span style="font-weight: 400">With class-specific Passenger-Equivalent Unit (PCU) factors, Values-of-Time (VoT), and fixed costs, we realized that there were no test instances to validate our implementation, so we developed a few of them, bootstrapping from the TNPM instances we had used to </span>[<span style="font-weight: 400">validate AequilibraE’s single-class traffic assignment</span>](http://aequilibrae.com/python/latest/traffic_assignment.html#numerical-study)<span style="font-weight: 400">.</span>

<span style="font-weight: 400">With those instances ready, it was just a matter to use any (other) commercial package to generate reference values. Right? Well, that’s when we realized that issues with commercial software might run a little deeper.</span>

<span style="font-weight: 400">As it turns out, the first software Pedro tested generated values slightly different than AequilibraE, so Jan went back to the math and the code. It all checked out.</span>

<span style="font-weight: 400">That is when doing unfunded research gets really hard, as getting to the bottom of that issue required lots of time for seemingly little result.</span>

<span style="font-weight: 400">We decided to run both the commercial software and AequilibraE for a wide range of congestion levels (factoring demand up and down for a fixed set of capacities), PCUs, VOTs, and financial (fixed) link costs. We noticed that results started to diverge more substantially for larger differences between the PCUs for our three classes.</span>

<span style="font-weight: 400">So Pedro went to the code and made a little change that made the results match and filed a </span>[<span style="font-weight: 400">bug report</span>](https://github.com/AequilibraE/aequilibrae/issues/239)<span style="font-weight: 400">. That prompted Jan to go back to the math and the code once again, but it all checked out. The link class flows generated by the commercial software were non-proportional, while total link flows were correct. Should we use a different assignment algorithm provided by the same software (i.e. path/bush based)? Well… Those were even more out of whack, but probably due to its expected non-proportionality.</span>

<span style="font-weight: 400">We asked ourselves if we should check against another commercial software, of course. Well, based on some basic analysis of this other software documentation and assignment setup, they are doing exactly what we are.</span>

<span style="font-weight: 400">The conclusion was inescapable: For the last roughly 5 (probably more) years, hundreds of agencies around the world have been using a traffic assignment based </span><span style="font-weight: 400">on a formulation that does not yield proportional class flows, and they are probably unaware of that</span><span style="font-weight: 400">.</span>

<span style="font-weight: 400">Have these issues had MAJOR impacts on policy decisions? Unlikely.</span>

<span style="font-weight: 400">Does it make sense to be using software that you can’t really trust or check? We don’t think so.</span>

# <span style="font-weight: 400">Our read of the situation</span>

<span style="font-weight: 400">Our intention is not to publicly shame any particular piece of software (that’s why we haven’t named them) or even to try to draw people to AequilibraE or any other Open-Source alternative. However, interested users should be able to verify that the software they are using produces the correct results.</span>

<span style="font-weight: 400">Professionals in other fields already require validation of software before their use, which is the case in econometrics, where software is generally not considered trustworthy until comprehensive Monte-Carlo simulation studies have been conducted in order to validate the software results.</span>

<span style="font-weight: 400">We also understand that the vast majority of modelers will not feel compelled to validate their software before using them, but many of us will. Further, the results of our work have a direct impact on the disbursement of public funds towards infrastructure investment and the operation of our transportation systems, so working with black boxes that generate results we cannot verify should not be considered acceptable.</span>

# <span style="font-weight: 400">Where to go from here</span>

<span style="font-weight: 400">As far as we can tell, the best solution for this issue is to start developing reference instances for some of the most important tasks used in our industry and their corresponding (and verifiable) solutions.</span>

<span style="font-weight: 400">In the case of traffic assignment, that may be a set of very small networks with a variety of parameters that can be solved via mathematical programming, or with peer-reviewed open-source code. The important point here is that the solution has to be reproducible in order to build trust in the known solutions.</span>

<span style="font-weight: 400">We also believe that generating solutions for all common transportation problems may not be feasible in a world where algorithms are getting more complicated in order to represent an ever-evolving built environment. However, most of the basic tools are still routinely used, and we should be able to trust them.</span>

<span style="font-weight: 400">Although some software providers might be doing better than others in the case of “correctness”, we don’t believe they have enough incentive to get behind the creation of these reference solutions, so it will be up to transportation agencies, particularly those in developed countries, to fund their development.</span>

<span style="font-weight: 400">There is an opportunity to pick and choose experts in each area (be that static traffic assignment, route choice, transit assignment or DTA) in order to start from a trusted place, and there is no better time than now to begin that work.</span>

<span style="font-weight: 400">What’s your take on it?</span>
