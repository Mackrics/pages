library(litedown)
library(data.table)
library(here)
library(ggplot2)
library(ricethemes)
library(fs)
library(patchwork)

pak::lockfile_create(c(
  "litedown",
  "data.table",
  "here",
  "ggplot2",
  "mackrics/ricethemes"
))
