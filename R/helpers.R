yaml_front_matter <- function(path) {
  yaml <- litedown:::yaml_body(litedown:::read_input(path, text = NULL))$yaml
  return(yaml)
}
