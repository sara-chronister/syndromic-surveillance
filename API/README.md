# NSSP ESSENCE API R Code

## Contents:
* Get-CSV
  + Function: get_csv
  + Use: Call API, convert into usable dataframe, remove sensitive API response information
* Get-Query-Info
  + Function: get_query_info
  + Use: Return table of API parameters in the supplied API url
  + Required: Must have NSSP Data Dictionary downloaded and saved (may require adjusting file paths in the code)
* Loop-Successive-Time-Periods
  + Function: return_longterm_query
  + Use: Breaks longterm queries into smaller time chunks (default 2 weeks) and combines into a single dataframe to reduce the impact on the ESSENCE system
* Set-Dates
  + Function: set_dates
  + Use: Finds and replaces the start and end dates in the API url in the correct format
* Set-ESSENCE-key
  + Use: Instructions and code to use the key_set function in the keyring package for secure password use
* Time-Series-JSON
  + Function: get_ts_json
  + Use: Extract ESSENCE time series API results, which come in JSON format
