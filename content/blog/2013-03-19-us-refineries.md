---
id: 66
title: 'US Refineries'
date: '2013-03-19T07:02:58+10:00'
author: pedro
layout: post
tags:
    - FAF
    - Freight
    - Shapefile
---

I already talked about [CSFFM](http://www.dot.ca.gov/hq/tsip/otfa/csffm/index.html) when I presented the [seasonality analysis](http://www.xl-optim.com/blog/seasonality-analysis/) I made for agricultural products, but now the focus is on different parts of CSFFM.

When working with freight modeling, often analyses use aggregate data like sector employment, GDP, number of firms and other statistics the Census provides. It becomes, then, an econometric exercise of finding the best set of variables and functional forms, where the concern is with (not so) fancy econometrics like Heteroskedasticity, endogeneity, significance, etc.

This is the case of the report titled “Development of A Computerized Method to Subdivide the FAF2 Regional Commodity OD Data to County Level OD Data” written by Cambridge Systematics, Inc. and delivered in January 2009. While this is an impressive econometric effort, it adds very little understanding of the underlying phenomena, freight generation/distribution of multiple commodities in this case. I could not find this report online ( I have only the copy Caltrans sent me a while back, so[ here](http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&ved=0CDAQFjAA&url=http%3A%2F%2Fwww.fsutmsonline.net%2Fimages%2Fuploads%2Fmtf-files%2FPPT_2_FAFDataDisaggregation_Krishnan.ppt&ei=xgFIUc3JK6qDjALZ6oDQBQ&usg=AFQjCNGh7P61vzcYupScWVOd5De3Wq2EEw&bvm=bv.44011176,d.cGE) is a link of a work by CamSys itself that involves such methodology).

And that is not only CamSys that has been modeling freight this way (and they are some of the best on the business doing freight and passenger modeling) . Most reports I have seen mention this type of methodology and we were also heading that way for some time. I believe however that, while it has been considered a good enough approach, it is not the best one for the same set of resources (money and time).

The question is: Does it have to be primarily an econometric effort? I believe it does not, and we found that it is possible to find publicly available data that has a lot more explanatory power (both theoretically and in our tests) than the variables commonly used.

The best case is, of course, the consumption of crude petroleum and the production of fossil fuels, which are concentrated on a small number of refineries in the country. According to [EIA’s website](http://www.eia.gov/energyexplained/index.cfm?page=oil_refining#tab4), there are only just over a hundred refineries in the US. Not only that, but EIA also presents their location and capacities. Is there better data on commodity production than facilities’ locations and capacities? Hard to imagine.

Long-story-short, I went to EIA’s website, downloaded the data, contacted their personnel for data on smaller refineries not listed and geo-tagged all facilities to create a GIS database.

How long did it take you might ask? About 2 or 3 days. How much did it cost? Zero dollars.

How precise it is? Some refineries are geotagged using Google Earth (so probably more precise than one might ever need), while most of them are just tagged to the center of the Counties they are listed at. You might have to adjust the location for the refineries that are in the area you are modeling, but they are all pretty close to their real locations as it is right now.

You might also want to check for refineries that might have been opened or closed since the beginning of 2012, as there was a refinery in Porto Rico that just closed and some others might go the same way.

But is refineries the only case where we can find good data for modeling? NO, it is not. Agricultural products can be modeled using data from the excellent [CropScape](http://nassgeodata.gmu.edu/CropScape/), cement factories are listed on EPA’s website, mining facilities are all known and their locations already geo-tagged [here](http://nationalatlas.gov/), etc.

Further, other knowledge like that gravel is ALWAYS produced as close as possible to the consumption site could also be leveraged in modeling, but it is currently not.

Bottom line. If for passenger travel we try to understand human behavior, why not understand each commodity’s production chain characteristics when modeling them?

If you are interested in this data you can download the database in [shapefile](http://xl-optim.com/site/refineries/US_OIL_REFINERIES_shape.zip "Seasonality analysis") format,[ TransCad](http://xl-optim.com/site/refineries/US_OIL_REFINERIES_dbd.zip) format, and [Excel](http://3.105.80.235/site/refineries/US_OIL_REFINERIES_excel.zip).