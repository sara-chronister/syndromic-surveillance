# This is a function to break up a long term query into smaller time frames to reduce the burden on ESSENCE processing
# You will need to have two other functions loaded for this to work (the second depends on whether you need a csv or JSON output):
#   1. set_dates found here: https://github.com/sara-chronister/syndromic-surveillance/blob/master/API/Set-Dates
#   2a. get_csv found here: https://github.com/sara-chronister/syndromic-surveillance/blob/master/API/Get-CSV
#   2b. get_ts_json found here: https://github.com/sara-chronister/syndromic-surveillance/blob/master/API/Time-Series-JSON

# loop_start: the start date for your query
# loop_end: the end date for your query

return_longterm_query <- function(url, loop_start, loop_end, by = 14) {
  
  #### Setup for loop ####
  # function to create a data frame with the start and end dates you are trying to use 
  # default is 14 day intervals, but you can specify any number of days in the by argument when you call the function 
  loop_start <- as.Date(loop_start)
  loop_end <- as.Date(loop_end)
  
  loop_dates <- data.frame(start = seq.Date(from = loop_start, to = loop_end, by = by)) %>%
    mutate(end = start+(by-1)) %>%
    mutate(end = ifelse((loop_end>start&end>loop_end),loop_end,end)) %>%
    mutate(end = as.Date.numeric(end, origin = "1970-01-01"))

  # initiate a blank list to store the output from the loop
  output_list <- list()

  #### Loop over multiple time frames ####
  # loop to change the dates, get csv from url, and store output in a list
  for (i in 1:nrow(loop_dates)) {
    
    # update the to the i set of start and end dates in the url
    url_update <- set_dates(url, start = loop_dates$start[i], end = loop_dates$end[i])
    # generate the output from the i set of start and end dates
    new_output <- get_csv(url = url_update) %>%
      mutate_all(as.character)
    # store the results from the i set of start and end dates as the i element in a list
    output_list[[i]] <- new_output
    
  }

  #### Result ####
  # collapse results of the list generated in the output above into a data frame
  all_data <- plyr::ldply(output_list, bind_rows)

  return(all_data)

}
