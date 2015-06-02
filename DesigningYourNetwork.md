

# Introduction #

This is a tutorial for how to design your network.  It will eventually include details on how to choose node sites, design a toplogy, estimate bandwidth needs, etc.


# Estimating bandwidth #

It can be proved for a reasonably large number of  users, N (http://perso.rd.francetelecom.fr/bonald/Pub/itc18-dim.pdf) that a reasonable estimate of required capacity is given by:

C = N/(1/a + 1/d - 1/c)

where C is total uplink capacity,  a is [Busy-hour](http://en.wikipedia.org/wiki/Busy_hour) [offered load](http://en.wikipedia.org/wiki/Offered_load) (BHOL), d is useful capacity and c is offered per-user capacity.

The FCC in the US [recently estimated 160kbps for BHOL](http://download.broadband.gov/plan/the-broadband-availability-gap-obi-technical-paper-no-1-chapter-4-network-economics.pdf).  Knowing the speeds you are offering users (c) and the minimum speed you would like them to actually experience (d), you can then calculate the amount of bandwidth you need to serve them using the equation

**If you don't like doing Math, to can download our [Bandwidth Calculator Spreadsheet](http://fabfi.googlecode.com/svn/wiki/files/BWCalculator.xls)** (this works in Open Office too)