# Use for either Data Details or Table Builder results

# Use the keyring package to authenticate username and password

get_csv <- function(url) {
  api_response <- GET(url, authenticate(key_list("essence")[1,2],
                                        key_get("essence",key_list("essence")[1,2])))
  if (api_response$status_code==401) {
    warning("API Status Code 401: ESSENCE password has expired. Please go to amc.syndromicsurveillance.org to reset.")
  } else {
    if (api_response$status_code==404) {
      warning("API Status Code 404: Check the ESSENCE API for errors. If necessary, re-copy the API from ESSENCE to ensure it is formatted correctly.")
    } else {
      data_details <- content(api_response, type="text/csv")
      rm(api_response)
      return(data_details)
    }
  }
}
