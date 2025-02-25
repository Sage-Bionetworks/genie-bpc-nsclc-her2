save_synapse_table_as_csv <- function(
    synid,
    save_path,
    rename_to = NULL
) {
  # there must be more efficient way - but this works and doesn't
  # have the flaw of reading/writing the CSV.
  temp_query <- synTableQuery(paste0('select * from ', synid))
  fs::file_move(
    path = temp_query$filepath, 
    new_path = save_path
  )
  
  if (!is.null(rename_to)) {
    # queries are saved as some sort of number gibberish of course:
    file_name = str_extract(temp_query$filepath, "[A-z|0-9]*\\.csv$")
    fs::file_move(
      path = here(save_path, file_name),
      new_path = here(save_path, paste0(rename_to, '.csv'))
    )
  }
  
  return(NULL)
  
}
