---
id: 1075
title: "Software performance - Back to the basics"
date: "2024-08-04T00:00:00+10:00"
author: pedro
url: /high_performance_ipf/
categories:
    - rant
---
`<span style="font-weight: 400">`The last 3 years or so have been incredibly busy for me, and the proverbial dust around this place is good evidence of that. Much of that activity translated into incredible advances for AequilibraE, with a generational improvement to traffic assignment performance, transit assignment and, more recently, route choice.

`<span style="font-weight: 400">`The common thread in these major advances, however, is that I did not write much of that code, and certainly nothing of importance. As we advance into high-performance computing, the software is getting too complicated for me, amd I find myself being more valuable as an internal client/consultant for the software, helping guide the direction for the API and prioritize improvements. It is bittersweet, but it comes with the territory.

`<span style="font-weight: 400">`Every once in a while, however, I spend a few hours going through the code and making minor improvements to it. Adding documentation, fixing minor bugs, adding helpful functionality around the edges, upgrading dependencies and working on Continuous Integration. That usually happens at night, usually around the weekend. It is like spending some quality time with someone you love.

`<span style="font-weight: 400">`It is incredibly rare, however, that I get time to make performance improvements to the software, so I truly cherish those opportunities. One of these rare chances happened a few months ago, when I was looking into the performance of AequilibraE's IPF implementation. It was OK, as it was based on NumPy vectorized operations, after all.

`<span style="font-weight: 400">`Fortunately, we were working on a project where *OK* performance for IPF was not enough, as we were working with over a thousand very large matrices (11,600+ zones). This made me realize that there were countless instances during the development of AequilibraE where I have lacked on the pursuit of performance, the IPF being one of them.  While *OK* performance has been more than sufficient in most cases, our own recent work has showed that the situations where maximum performance is a requirement are becoming more common, which will be a great opportunity to revisit many of the methods inside AequilibraE.

`<span style="font-weight: 400">`But that was enough reflection about my past mistakes. It was time to go back to the basics and implement it as it should've been done from the start. This involved going down to Cython to leverage real parallelization with the help of Open-MP. This was familiar technology to me, so it was just a matter of revisiting old concepts.

```python
    for i in prange(I, nogil=True):
        for j in range(J):
            if prod_tgt[i] + attr_tgt[j] == 0:
                flows[i, j] = 0

    for iter in range(max_iter):
        _total_prods(flows, prod_tgt, prod_tot, cpus)
        err = _factors(prod_tgt, prod_tot, prod_factor, cpus)
        for i in prange(I, nogil=True, num_threads=cpus):
            if prod_tgt[i] > 0:
                for j in range(J):
                    flows[i, j] = flows[i, j] * prod_factor[i]


        _total_attra(flows, prod_tgt, attr_tot, cpus)
        err = _factors(attr_tgt, attr_tot, attr_factor, cpus)
        for i in prange(I, nogil=True, num_threads=cpus):
            if prod_tgt[i] > 0:
                for j in range(J):
                    flows[i, j] = flows[i, j] * attr_factor[j]

        # FUNCTION TO COMPUTE THE ERROR
        err = _calc_err(prod_factor, attr_factor)
        if (err - 1) < toler:
            break
    return iter, err - 1
```

`<span style="font-weight: 400">`The code above worked well, but the real magic came when I decided to pay attention to CPU cache use, and leveraged local buffers when computing attraction marginals. I don't recall now what was the exact magnitude of the improvement, but I remember being in the same order of magnitude as the parallelization, which was HUGE.

```python
with nogil, parallel( num_threads=cpus):
        local_buf = <double *> malloc(sizeof(double) * J)
        for j in range(J):
            local_buf[j] = 0
            attr_tot[j] = 0

        for i in prange(I):
            if prod_tgt[i] == 0:
                continue
            for jk in range(J):
                # for jk in array_of_indices_of_non_zeros:
                local_buf[jk] += flows[i, jk]

        with gil:
            for j in range(J):
                attr_tot[j] += local_buf[j]

        free(local_buf)
```

`<span style="font-weight: 400">`At this point, we were getting 6.2X improvement over our pure Python code when using a beefy 32 core CPU, which felt a little underwhelming, even if it meant saving hours of processing time. Looking back at our gains we had made so far, it was clear that CPU cache was playing a huge role, and it was worth exploring what else we could do to optimize its use.

`<span style="font-weight: 400">`The obvious change was to make more elements to fit in cache, meaning to have smaller elements: How about using 32 bit arrays instead of 64 ones? Implementing those changes was trivial, and the results enormous. In a nutshell, the software performed 36% faster for matrices with 5,000 zones and **47%** faster for matrices with 10,000 zones.

`<span style="font-weight: 400">`What about numerical precision you may ask?  Well... The Root Mean Squared error was of the order of 1e-10 to 1e-12, so way beyond what we usually worry about in modelling. In any case, we have maintained both the 32 and 64 bit versions of the algorithm, and AequilibraE decides the version to use based on the seed matrix provided by the user. We have also made that function, called **ipf_core** available for direct use with NumPy arrays instead of AequilibraE's matrix interface, which allows it to be incorporated in 3rd party code much more easily.

`<span style="font-weight: 400">` If can see the full benchmarking analysis, on the [AequilibraE documentation](https://aequilibrae.com/python/latest/validation_benchmarking/IPF_benchmark.html).