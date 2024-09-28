#!/usr/bin/bash

Rscript -e 'pak::pkg_install()'
Rscript -e 'litedown::fuse_site()'
Rscript -e '
source("R/gen_rss_feed.R")
get_rss_items("https://mackrics.com/blog") |> 
  gen_feed("Mackrics", "https://mackrics.com/blog") |>
  write("index.xml")
'
