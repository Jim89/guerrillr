#' Guerrilla Analytics project set up
#'
#' This function creates a basic project skeleton following the Guerilla Analytics structure.
#' @param directory The file path to the directory in which you want to create the project.
#' @param overwrite If the directory already exists, do you wish to overwrite it and its contents? Defaults to FALSE
#' @export
#' @examples
#' setup_project("/home/jim/Documents/test_project", overwrite = FALSE)


setup_project <- function(directory, overwrite = FALSE) {

    # Check if directory already exists
    already_exists <- dir.exists(directory)

    # If it doesn't exist, create it
    if (!already_exists) {
        dir.create(directory)
    } else {
        # If it does exist and overwrite is false, stop and throw error
        if (overwrite == FALSE) {
            stop("Directory already exists. Change the directory or set overwrite to be TRUE")
        } else {
            message("Directory already exists. Overwriting")
            unlink(directory, recursive = TRUE)
            dir.create(directory, showWarnings = FALSE)
        }
    }

    # Create the paths for sub-folders of the main directory
    wp <- paste0(directory, "/wp")
    data <- paste0(directory, "/data")
    pm <- paste0(directory, "/pm")
    pm_init <- paste0(directory, "/pm/01_initiate")
    pm_deliver <- paste0(directory, "/pm/02_deliver")
    pm_close <- paste0(directory, "/pm/03_close")

    # Set up list and loop over
    dirs_to_make <- c(wp, data, pm, pm_init, pm_deliver, pm_close)
    quiet <- lapply(dirs_to_make, dir.create)

}


