# GCPD Cases

To get cases from Gotham City Police Department, you can download CSV containing all cases from following url: `http://www.gotham-city.dev/gcpd/cases.csv`

#### CSV Format

As there are no headers in downloadable CSV, below you can find list of all columns returned

Example of CSV row: `#100 Joker,James Gordon,james@gcpd.com,Joker just broke out of prison`

* `#100 Joker` - case identifier, prefixed with `#` followed by full case name
* `James Gordon` - full name of officer handling the case
* `james@gcpd.com` - contact email of officer handling the case
* `Joker just broke out of prison` - full description of case
