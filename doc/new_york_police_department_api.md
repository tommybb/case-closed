# NYPD Cases

To get cases from New York Police Department, you can get JSON formatted list containing all cases from following url: `http://www.new-york-city.dev/api/v1/cases.json`

#### JSON Format

Example of record returned:
```json
{"name":"Joker escape","case_uid":"1002829","handler_email":"james_gordon@gcpd.com","description":"Joker just broke out of prison","priority":"low"}
```

* `name` - full case name
* `case_uid` - unique identifier of case
* `handler_email` - contact email of officer handling the case. All emails contain officer's first name and last name delimited with `_` as username.
* `description` - full description of case
* `priority` - importance of case (low|medium|high)
