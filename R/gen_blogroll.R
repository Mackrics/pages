gen_blogroll <- function(path, nrow, exclude_files = "", pattern = "Rmd$", keep_tags = NULL, exclude_tags = NULL, decreasing_order = TRUE) {

  files <- dir({{ path }}, pattern = {{ pattern	}}, full.names = TRUE) 
  stopifnot("No valid files found" = length(files) > 0)
  files <- files[!files %in% exclude_files]
  yaml <- lapply(files, yaml_front_matter)

  if (!is.null(keep_tags)) {
    tags <- lapply(yaml, \(x) try(x[[ "tags" ]]))
    keep <- unlist(lapply(tags, \(x) any(x %in%  {{ keep_tags }})))
    files <- files[keep]
    yaml  <- yaml[keep]
  }
  if (!is.null(exclude_tags)) {
    tags <- lapply(yaml, \(x) try(x[[ "tags" ]]))
    keep <- unlist(lapply(tags, \(x) !any(x %in%  {{ exclude_tags }})))
    files <- files[keep]
    yaml  <- yaml[keep]
  }
  stopifnot("All valid files filtered out with tags" = length(yaml) > 0 & length(files) > 0)

  has_date_title <- unlist(lapply(yaml, \(x) all(c("date", "title") %in%  names(x))))
  stopifnot("All files does not have the necessary metadata (date and title)" = has_date_title)

  # Get metadata
  date  <- as.Date(as.character(lapply(yaml, \(x) x[[ "date" ]])))
  title <- as.character(lapply(yaml, \(x) x[[ "title" ]]))
  link  <-  gsub("Rmd$", "html", files)

  # style entry
  entry <- paste0("\n\n**", date, "**: [", title, "](", link, ")\n\n")

  if (nrow > length(entry)) { # enable setting nrow to Inf
    nrow <- length(entry)
  }

  cat(entry[order(date, decreasing = {{decreasing_order}})][seq(1, nrow)])
}
