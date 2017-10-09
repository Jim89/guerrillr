#' Guerrilla Analytics project set up.
create_ga_project <- function(path, ...) {
  # Setup directories ----------------------------------------------------------
  # Check to see if the directory exists (if it does, stop)
  dir_exists <- dir.exists(path)

  if ( dir_exists ) stop("Specified directory already exists")

  # Make the directory (recursively, so make the path to it if needed)
  dir.create(path, recursive = TRUE, showWarnings = TRUE)

  # Set up additional directories
  dirs <- file.path(path, c("data", "wp", "pm", "src"))

  # Make them
  out <- lapply(dirs, dir.create)

  # Get parameters -------------------------------------------------------------
  # Collect the project parameters
  params <- list(...)

  # Get the project name to make into a header
  proj_name <- params[["project_name"]]
  header <- paste("#", proj_name)

  # Get the author
  proj_author <- params[["project_author"]]
  author <- paste("For more details, please contact:", proj_author)

  # Get if user wants to make trackers
  track <- params[["make_trackers"]]

  # Create readme --------------------------------------------------------------
  # Create the readme skeleton
  skeleton <- paste("This is a [Guerilla Analytics](http://guerrilla-analytics.net/) project. It contains the following folders:\n\n* __data__: contains the data for the project\n* __pm__: contains project management artifacts\n* __wp__: contains individual work products\n*__src__: contains end-to-end analytics code, and functions developed in the project\n")


  # collect into single text string
  contents <- paste(
    paste(header, collapse = "\n"),
    skeleton,
    author,
    sep = "\n"
  )

  # write to readme file
  writeLines(contents, con = file.path(path, "readme.md"))


  # Setup trackers -------------------------------------------------------------
  # Get the data dir
  data_dir <- grep(".*/data$", dirs, value = TRUE)

  # Make a simple data tracker table
  data_tracker <- data.frame(
    id = numeric(0),
    name = character(0),
    received_by = character(0),
    received_from = character(0),
    version = numeric(0),
    file_received = character(0),
    comments = character(0),
    stringsAsFactors = FALSE
    )

  # Write the tracker to the path
  write.csv(
    data_tracker,
    file.path(data_dir, "data-tracker.csv"),
    row.names = FALSE
    )

  # Get the work products dir
  wp_dir <- grep(".*/wp$", dirs, value = TRUE)

  # Make a simple data tracker table
  wp_tracker <- data.frame(
    id = numeric(0),
    name = character(0),
    prepared_by = character(0),
    delivered_to = character(0),
    version = numeric(0),
    last_updated = character(0),
    comments = character(0),
    stringsAsFactors = FALSE
  )

  # Write the tracker to the path
  write.csv(
    wp_tracker,
    file.path(wp_dir, "work-products-tracker.csv"),
    row.names = FALSE
    )

  # End ------------------------------------------------------------------------
}
