#' Guerrilla Analytics project set up
#'
#' This function creates a basic project skeleton following the Guerilla Analytics structure.
#' @param name The name of the project
#' @param directory The file path to the directory in which you want to create the project.
#' @param overwrite If the directory already exists, do you wish to overwrite it and its contents? Defaults to FALSE
#' @param rstudio_project Create an Rstudio project along with the directory? Defaults to FALSE.
#' @export
#' @examples
#' setup_project("test_project", "/home/jim/Documents", overwrite = FALSE)

setup_project <- function(name, directory, overwrite = FALSE,
                          rstudio_project = FALSE) {

    # Create full file path from name and directory
    dir <- paste0(directory, "/", name)

    # Check if named project directory already exists
    already_exists <- dir.exists(dir)

    # If it doesn't exist, create it
    if (!already_exists) {
        dir.create(dir)
    } else {
        # If it does exist and overwrite is false, stop and throw error
        if (overwrite == FALSE) {
            stop("Directory already exists. Change the directory or set overwrite to be TRUE")
        } else {
            message("Directory already exists. Overwriting")
            unlink(dir, recursive = TRUE)
            dir.create(dir, showWarnings = FALSE)
        }
    }

    # Create the paths for sub-folders of the main directory
    subs <- c("/wp", "/data", "/pm", "/pm/01_initiate", "/pm/02_deliver",
                    "/pm/03_close")
    subfolders <- paste0(dir, subs)
    # Loop and create sub-folders
    quiet <- lapply(subfolders, dir.create)

    # Does the user require an Rstudio project?
    if (rstudio_project) {
        # Print handy message
        message("Adding RStudio project file")

        # Set up path to new file
        path <- file.path(dir, paste0(name, ".Rproj"))

        contents <- c("Version: 1.0", "", "RestoreWorkspace: No",
                      "SaveWorkspace: No", "AlwaysSaveHistory: Default", "",
                      "EnableCodeIndexing: Yes", "UseSpacesForTab: Yes",
                      "NumSpacesForTab: 2", "Encoding: UTF-8", "",
                      "RnwWeave: Sweave", "LaTeX: pdfLaTeX")

        # Push contents out to project file
        cat(paste(contents, collapse="\n"), file = path)
    }
}
