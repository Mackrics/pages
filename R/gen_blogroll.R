gen_blogroll <- function(path, nrow, exclude_files) {

  files <- dir({{ path }}, pattern = "*.Rmd", full.names = TRUE) 
  files <- files[!files %in% exclude_files]
  yaml <- lapply(files, yaml_front_matter)

  # Get metadata
  date  <- as.Date(as.character(lapply(yaml, \(x) x[[ "date" ]])))
  title <- as.character(lapply(yaml, \(x) x[[ "title" ]]))
  link  <-  gsub("Rmd$", "html", files)

  # style entry
  entry <- paste0("\n\n**", date, "**: [", title, "](", link, ")\n\n")

  if (nrow > length(entry)) {
    nrow <- length(entry)
  }

  cat(entry[order(date, decreasing = TRUE)][seq(1, nrow)])
}
