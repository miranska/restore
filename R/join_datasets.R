# join two datasets
join_datasets <- function(dat_old, dat_new, hierarchy_column_name, key_column_name) {
  #get a list of ovelapping columns and remove hierarchy_column_name and key_column_name
  common_columns <-
    intersect(colnames(dat_old), colnames(dat_new))
  columns_to_compare <- common_columns %>%
    setdiff(c(hierarchy_column_name, key_column_name))
  
  # let's reshape the data frames, so that they look like
  # geo, key, var_name, value
  # this may not be the fastest solution, but it makes it easier to work with the data
  # TODO: rework the code below so that we do column-wise comparisons without reshaping the dataframe
  create_gathered_dataset <-
    function(d,
             columns_to_select,
             columns_to_analyse) {
      d %>%
        select(columns_to_select) %>%
        gather(columns_to_analyse, key = "var_name", value = "var_value")
    }
  
  #join old and new reshaped datasets
  # benchmark() results, from best to worst - data.table() with index, inner_join(), sqldf() with index, merge()
  # references - # https://stackoverflow.com/questions/4322219/whats-the-fastest-way-to-merge-join-data-frames-in-r
  # https://www.r-bloggers.com/improve-the-efficiency-in-joining-data-with-index/
  dt1 <-
    data.table(create_gathered_dataset(dat_old, common_columns, columns_to_compare))
  dt2 <-
    data.table(create_gathered_dataset(dat_new, common_columns, columns_to_compare))
  ckey <- c(key_column_name, hierarchy_column_name, "var_name")
  setkeyv(dt1, ckey)
  setkeyv(dt2, ckey)
  dat_joined <-
    merge(dt1, dt2, by = ckey, suffix = c(".old", ".new"))
  
  # return
  return(dat_joined)
}