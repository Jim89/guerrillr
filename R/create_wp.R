#' Create a new work product.
#'
#' This function creates the skeleton for a new work-product within the project.
#' It must be called from the root directory of the project.
#' @param title The title of the work product.
#' @param owner The name of the owner of the work product (i.e. the analyst
#'   reponsble).
#' @param deliver_to The name of the person the work product will be delivered
#'   to/is for.
#' @param remark A brief sentence describing the work product.
#' @param wp_dir The name of the work product directory. Defaults to wp.
#' @export
#' @references "Guerrilla Analytics: A Practical Approach to Working with Data", Enda Ridge (\href{https://guerrilla-analytics.net/}{Website})
#' @examples
#' create_wp("wp", "Customer complaints summary", "Jim Leach", "Enda Ridge", "Summary numbers for customer complaints from the past 6 months, after removing products A, B ande C.")

create_wp <- function(title, owner, deliver_to, remark, wp_dir = "wp") {

  # If wp directory doesn't exist, throw an error
  if (!dir.exists(wp_dir)) {
    stop("The provided work product directory does not exist.")
  }

  # First, list all the files in the wp directory
  wp_all <- list.files(file.path(".", wp_dir))
  wp_all <- wp_all[-grep("wp_log.csv", wp_all)]

  # Count how many there are
  how_many_exist <- length(wp_all)

  # Increment that by 1 to create the new workproduct
  new <- how_many_exist + 1

  # Set up the wp filename
  wp_path <- file.path(".", wp_dir, sprintf("wp%04d", new))

  # Create the directory as long as it doesn't already exist (if it does throw an error)
  dir.create(wp_path)

  # Set up details to write a brief readme
  h1 <- paste("# Work Product", new, "-", title)
  dt <- paste("Created on:", Sys.Date())
  own <- paste("Created by", owner)
  del <- paste("For delivery to:", deliver_to)
  com <- paste("## Details\n", remark)

  # Create md file and path
  md_file <- c(h1, dt, "", own, "", del, "", com)
  md_file_path <- file.path(wp_path, "readme.md")

  # Create a simple readme file
  writeLines(md_file, con = md_file_path)

  # Write to the log file
  # Create the log if it doesn't exist
  if (how_many_exist == 0) {
    df <- data.frame(wp = character(),
                     created = character(),
                     created_by = character(),
                     created_for = character(),
                     note = character(),
                     stringsAsFactors=FALSE)

    # set path to log
    log_path <- file.path(".", wp_dir, "wp_log.csv")
    write.table(df, file = log_path, row.names = FALSE,
                sep = ",")
  }

  # Create the wp log entry
  log_entry <- cbind(sprintf("wp%04d", new),
                 as.character(Sys.Date()),
                 owner,
                 deliver_to,
                 remark)

  # set log file path
  log_file <- file.path(".", wp_dir, "wp_log.csv")

  # Write the entry
  write.table(log_entry,
              file = log_file,
              append = TRUE,
              row.names = FALSE,
              col.names = FALSE,
              sep = ",")

}

create_wp <- function() {
  # Path to wp tracker
  wp_path <- file.path(".", "wp", "work-products-tracker.csv")

  # Read the work product tracker
  current_tracker <- read.csv(wp_path, stringsAsFactors = FALSE)

  current_wp <- data.frame(
    name = "Test",
    prepared_by = "Jim",
    delivered_to = "Jo",
    version = max(1, current_tracker$version + 1),
    last_updated = as.character(Sys.Date()),
    comments = "A test comment",
    stringsAsFactors = FALSE
  )

  # Combine them
  new_tracker <- rbind(current_tracker, current_wp)

  # Write back out to file
  write.csv(new_tracker, wp_path, row.names = FALSE)
}


