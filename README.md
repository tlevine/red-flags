Quantify red flags of suspicious activities.

## What this does
This looks for red flags of fraud and corruption in procurement
for World Bank contracts. The following red flags are addressed
in some way.

* Unusual bid patterns
* Lowest bidder not selected

### Unusual bid patterns
According to "[Most Common Red Flags of Fraud and Corruption in Procurement in Bank-financed Projects](http://siteresources.worldbank.org/EXTGOVANTICORR/Resources/3035863-1285875404494/100101_INT_Red_flags_pamphlet.pdf)",
(here-on abbreviated "Common Red Flags"),
by the Integrity Vice Presidency,
unusual bid patterns are a sign of possible collusion.

> In collusive bidding cases, it is not unusual for the designated winner to coordinate the bidding by the other participants -- dictating prices to be bid by others to ensure that the designated winner’s bid is the lowest.

Collusive bidding can result in strange bidding patterns. Roundness of
losing bid prices is one example.

> Losing bid prices are round or unnatural numbers, e.g., 355,000 or 65,888,000 USD (check BER) 

The present red flags detector looks at the number of bids and the number of
round or unnatural numbers per bid. It produces
[`bid-patterns.png`](http://big.dada.pink/red-flags/bid-patterns.png).

Reading this graph, you can look for contracts with lots of round or unnatural
bids. These contracts are probably totally fine, but they do raise this red flag,
so it might be worth looking at them.

### Lowest bidder non-selection
Sometimes, the "[l]owest evaluated bid is unjustifiably declared non-responsive",
and this  "can indicate bid rigging", according to Common Red Flags.
More specifically,

> Project officials with a hidden interest in a contractor, or expecting to
> receive kickbacks from a contractor (sometimes on behalf of other government
> officials) often pressure Bid Evaluation Committee members to declare the
> lowest evaluated bid(s) unresponsive, thereby allowing the award of the
> contract to their preferred contractor, who often offers a much higher price
> and/or is only marginally qualified.

The present red flags detector looks at the prices of the various bids on
contracts for bank-financed projects and looks for situations where low bids
were rejected. You may read this as one plot per contract of the prices of the
bids (They're [here](http://big.dada.pink/red-flags/lowest-bidder/).) or as
a single [aggregate plot](http://big.dada.pink/red-flags/lowest-bidder.png)
containing the number of rejections and evaluations-but-not-awards for
different contracts.

Contracts with lots of rejections or with rejections for low bidders show this
red flag. Again, they are probably fine, but they might be a place to start
looking for bid rigging.

## How to use
Acquire `bids.csv` like so.

    pip3 install wbcontractawards
    wbcontractawards > bids.csv

`bids.csv` should look a bit like this.

    contract,bidder,status,amount,currency
    http://search.worldbank.org/wcontractawards/procdetails/OP00022874,Sinohydro Corporation Ltd.,Awarded,1998611755.0,KES
    http://search.worldbank.org/wcontractawards/procdetails/OP00025345,FIS-LG CNS Joint Venture,Awarded,9388888.0,USD
    http://search.worldbank.org/wcontractawards/procdetails/OP00027035,NATIONAL CONTRACTING COMPANY LTD,Awarded,106455.0,CHF
    http://search.worldbank.org/wcontractawards/procdetails/OP00027035,China CAMC Engineering & Shanghai Electric Power Construction,Evaluated,344574544.0,KES
    ...

Run `redflags` on it.

    ./redflags bids.csv

## Next steps

1. Convert all currencies to a standard currency.
2. Improve the price parser
    ([wbcontractawards](https://pypi.python.org/pypi/wbcontractawards)),
    specifically for prices that are formatted
    differently or written in other languages.
    (It's worth looking a bit at the original C# scraper for inspiration.)
3. Make the detection of low-bidder-rejection a bit less brittle.
