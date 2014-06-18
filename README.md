Quantify red flags of suspicious activities.

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

This puts plots in the `lowest-bidder` directory, which I'm serving
[here](http://big.dada.pink/red-flags/lowest-bidder/).
