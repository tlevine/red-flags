Quantify red flags of suspicious activities.

## What this does
This looks for red flags of fraud and corruption in procurement
for World Bank contracts. The following red flags are addressed
in some way.

* Unusual bid patterns
* Lowest bidder not selected

### Unusual bid patterns
According to "Most Common Red Flags of Fraud and Corruption
in Procurement in Bank-financed Projects", (here on abbreviated
"Common Red Flags"), by the Integrity Vice Presidency,
unusual bid patterns are a sign of collusion.


If you follow the directions below, you'll produce

1. One plot of the number of rejections and evaluations-but-not-awards
    for different contracts


2. One plot per contract of the prices of the bids


This puts plots in the `lowest-bidder` directory, which I'm serving
[here](http://big.dada.pink/red-flags/lowest-bidder/).


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
