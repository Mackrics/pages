library(litedown)
library(data.table)
library(here)
library(ggplot2)
library(ricethemes)
library(patchwork)
library(httpgd)

if (FALSE) {
  pak::lockfile_create(c(
    "litedown",
    "data.table",
    "here",
    "ggplot2",
    "patchwork",
    "mackrics/ricethemes",
    "httpgd"
  ))
}
