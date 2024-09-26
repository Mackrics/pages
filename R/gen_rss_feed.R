gen_feed <- function(items, title, link) {
  paste0("<rss version='2.0'>
<channel>
  <title>", title, "</title>
  <link>", link, "</link>\n",
items,
"\n  </channel>,
</rss>")
}

get_body <- function(file_path, url) {
  paste0("Read the full post [here](", url, "/", file_path, ").", sep = "") |>
  litedown::mark()
}

get_rss_items <- function(url) {
  path_data <-
    data.frame(
      path = list.files("blog", pattern = "*.Rmd", full.names = TRUE)
    ) 
  feed_data <-
  data.frame(path = path_data[path_data$path != "blog/index.Rmd", ]) |>
  within({
    params = lapply(path, rmarkdown::yaml_front_matter)
  }) |>
  within({
      date  = paste0("    <pubDate>", as.Date(purrr::map_chr(params, \(x) x[[ "date" ]])), "</pubDate>")
      title = paste0("    <title>", purrr::map_chr(params, \(x) x[[ "title" ]]), "</title>")
      link  = paste0("    <guid>https://mackrics.com/", stringr::str_replace(path, "Rmd", "html"), "</guid>")
      desc  = paste0("    <description>", purrr::map_chr(stringr::str_replace(path, "Rmd$", "html"), \(x) get_body(x, {{ url }})), "</description>")
  }) 
  out_data <-
  feed_data[order(feed_data$date), ] |>
  within({
    out = purrr::pmap(list(title, link, date, desc), \(...) paste0(c(...), collapse = "\n"))
  })
out <-
  paste0("  <item>\n", out_data$out, "\n  </item>") |>
  paste0(collapse = "\n")
  return(out)
}
