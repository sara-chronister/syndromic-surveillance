# Function to return a dataframe with the Value for each Parameter included in an API URL

# Setup:
# You will need to download the NSSP Data Dictionary which can be found here:
# https://www.cdc.gov/nssp/biosense/docs/NSSP-Data-Dictionary-508.xlsx

# Adjust the file paths below as necessary
available_resultType <- read_xlsx("NSSP-Data-Dictionary-508.xlsx", # Adjust file path as necessary
                                  sheet = "ESSENCE API and Data Details",
                                  range = "A2:B8",
                                  col_names = TRUE)
available_resultType$`API URL`[1] <- "/api/tableBuilder"
available_datasource <- read_xlsx("NSSP-Data-Dictionary-508.xlsx", # Adjust file path as necessary
                                  sheet = "ESSENCE API and Data Details",
                                  range = "A11:B18",
                                  col_names = TRUE) 
display_names <- read_xlsx("NSSP-Data-Dictionary-508.xlsx", # Adjust file path as necessary
                           sheet = "ESSENCE API Query Parameters",
                           range = "A2:B85",
                           col_names = TRUE)


# Function:

get_query_info <- function(url) {
  
  url_df <- data.frame(Value = url) %>%
    mutate(Value = str_replace(Value,"https://essence.syndromicsurveillance.org/nssp_essence","")) 
  url_df <- splitstackshape::cSplit(url_df, "Value", sep = "?", direction = "long")
  
  test <- splitstackshape::cSplit(url_df, "Value", sep = "&", direction = "long", drop = TRUE, type.convert = FALSE)
  test <- splitstackshape::cSplit(test, "Value", sep = "=", direction = "wide", type.convert = FALSE)
  test <- rename(test, urlParameter = Value_1, Value = Value_2) %>%
    group_by(urlParameter) %>%
    summarise(Value = paste(Value, collapse=", "))
  
  test_join <- full_join(test, display_names, by = c("urlParameter" = "API URL Name")) %>%
    full_join(available_datasource, by = c("Value" = "API URL Name")) %>%
    filter(!is.na(Value)) %>%
    filter(!is.na(urlParameter)) %>%
    filter(urlParameter != "userId") %>%
    mutate(Parameter = `Query Parameter Web Display Name`) %>%
    mutate(Parameter = ifelse(urlParameter=="datasource","Datasource",Parameter),
           Value = ifelse(urlParameter=="datasource",`Data Source Name`,Value)) %>%
    #mutate(Parameter = ifelse(is.na(Parameter),`Data Source Name`,Parameter)) %>%
    mutate(Parameter = ifelse(urlParameter=="detector","Detector Algorithm",Parameter)) %>%
    mutate(Parameter = ifelse(urlParameter=="startDate","Start Date",Parameter)) %>%
    mutate(Parameter = ifelse(urlParameter=="endDate","End Date",Parameter)) %>%
    mutate(Parameter = ifelse(urlParameter=="percentParam","Measure",Parameter),
           Value = ifelse(urlParameter=="percentParam",ifelse(Value=="noPercent","Count","Percent"),Value)) %>%
    mutate(Parameter = ifelse(urlParameter=="refValues","Reference Values",Parameter)) %>%
    mutate(Parameter = ifelse(urlParameter=="geography",Hmisc::capitalize(test$Value[test$urlParameter=="geographySystem"]),Parameter)) %>%
    mutate(Parameter = ifelse(urlParameter=="rowFields","Table Row Field(s)",Parameter)) %>%
    mutate(Parameter = ifelse(urlParameter=="columnField","Table Column Field",Parameter)) %>%
    mutate(Parameter = ifelse(urlParameter=="aqtTarget","Result Type",Parameter)) %>%
    mutate(Parameter = ifelse(str_detect(urlParameter,"ApplyTo"), "Free Text Apply To",Parameter)) %>%
    mutate(Parameter = ifelse(str_detect(urlParameter,"api/"), "Result Type", Parameter),
           Value = ifelse(str_detect(urlParameter,"api/"),urlParameter, Value)) %>%
    mutate(Value = ifelse(str_detect(Value,"%5E"),str_replace_all(Value,"%5E","^"),Value)) %>%
    mutate(Value = ifelse(str_detect(Value,"%5B"),str_replace_all(Value,"%5B","["),Value)) %>%
    mutate(Value = ifelse(str_detect(Value,"%5D"),str_replace_all(Value,"%5D","]"),Value)) %>%
    mutate(Value = ifelse(str_detect(Value,"%20"),str_replace_all(Value,"%20"," "),Value)) %>%
    
    select(Parameter, Value)
  
  return(test_join)
  
}
