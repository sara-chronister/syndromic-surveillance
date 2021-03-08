# This advances the start and end dates in the URL so you don't have to manually
# Based on code from Aaron Kite-Powell (CDC)
# By default it will set the start date to 7 days ago and the end date to today, but you can change those to custom settings when you call the function
# If you do not specify when you call the function, it will use the default settings
# Example: set_dates(url = url, start = "2019-08-01")

# start = new start date
# end = new end date

set_dates <- function(url, start = (Sys.Date()-7), end = Sys.Date()) {
  
  # pull out the end date from the url
  old_end <- regmatches(url, regexpr('endDate=.+?&', url)) %>% str_replace(.,"endDate=","") %>% str_replace(.,"&","")
  # format the new end date you specify when calling the function
  new_end <- format(as.Date(end), "%e%b%Y")
  # replace the old end date with the new end date
  url <- gsub("[[:space:]]", "", str_replace(url, old_end, new_end))
  
  # pull out the start date from the url
  old_start <- regmatches(url, regexpr('startDate=.+?&', url)) %>% str_replace(.,"startDate=","") %>% str_replace(.,"&","")
  # format the new start date you specify when calling the function
  new_start <- str_trim(format(as.Date(start), "%e%b%Y"))
  # replace the old start date with the new start date
  url <- gsub("[[:space:]]", "", str_replace(url, old_start, new_start))

  return(url)
}
