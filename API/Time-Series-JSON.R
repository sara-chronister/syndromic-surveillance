# Use the keyring package to authenticate username and password

get_ts_json <- function(url) { 
  api_response <- GET(url, authenticate(key_list("essence")[1,2],
                                        key_get("essence",key_list("essence")[1,2]))) 
  if (api_response$status_code==401) {
    warning("API Status Code 401: ESSENCE password has expired. Please go to amc.syndromicsurveillance.org to reset.")
  } else {
      if (api_response$status_code==404) {
        warning("API Status Code 404: Check the ESSENCE API for errors. If necessary, re-copy the API from ESSENCE to ensure it is formatted correctly.")
      } else {
        api_response_json <- content(api_response, as = "text")
        api_data <- fromJSON(api_response_json)
        timeseries_data <- api_data$timeSeriesData 
        timeseries_data <- timeseries_data %>% select(-altText, -details) %>%
          mutate(date = as.Date(date))
        rm(api_response)
        return(timeseries_data)
      }
  }
}
