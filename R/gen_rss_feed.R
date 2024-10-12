gen_feed <- function(items, title, link) {
  paste0("<rss version='2.0'>
<channel>
  <title>", title, "</title>
  <link>", link, "</link>\n",
items,
"\n  </channel>
</rss>")
}

get_body <- function(file_path, url) {
  paste0("Read the full post [here](", url, "/", file_path, ").", sep = "") |>
  litedown::mark()
}

get_rss_items <- function(path_to_folder, base_url) {
  path_data <-
    data.frame(
      path = list.files({{ path_to_folder }}, pattern = "*.Rmd", full.names = TRUE)
    ) 
  feed_data <-
  data.frame(path = path_data[path_data$path != "blog/index.Rmd", ]) |>
  within({
    params = lapply(path, rmarkdown::yaml_front_matter)
  }) |>
  within({
      date  = paste0("    <pubDate>", as.Date(as.character(lapply(params, \(x) x[[ "date" ]]))), "</pubDate>\n")
      title = paste0("    <title>", lapply(params, \(x) x[[ "title" ]]), "</title>\n")
      link  = paste0("    <guid>", base_url, "/", gsub("Rmd", "html", path), "</guid>\n")
      desc  = paste0("    <description>", lapply(gsub("Rmd$", "html", path), \(x) get_body(x, {{ path_to_folder }})), "</description>\n")
  }) 
  o <-
  feed_data[order(feed_data$date), ]
  o <-
  paste0(paste0("  <item>\n", o$title, o$link, o$date, o$desc, "  </item>"), collapse = "\n")
  return(o)
}
