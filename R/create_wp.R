#' Create a new work product
#'
#' Create a new work product in the specified work product directory.
#' 
#' @param wp_dir the name of the work product directory within the project
#' @param tracker_name the name of the tracker file in the work product
#'   directory
#'
#' @references "Guerrilla Analytics: A Practical Approach to Working with Data",
#'   Enda Ridge (\href{https://guerrilla-analytics.net/}{Website})
#' @export
create_wp <- function(wp_dir = "wp", tracker_name = "work-products-tracker.csv") {

  # Create the UI --------------------------------------------------------------
  wp_ui <- miniUI::miniPage(
    miniUI::miniContentPanel(
      ## Add UI items
      shiny::textInput("name", "Work product name"),
      shiny::textInput("folder", "Folder name"),
      shiny::em("(Folder name should be short)"),
      shiny::br(),
      shiny::br(),
      shiny::textInput("prep", "Prepared by"),
      shiny::textInput("del", "For delivery to"),
      shiny::textInput("comment", "Additional comments"),
      miniUI::gadgetTitleBar(title = NULL)
    )
  )

  # Create the server functionality --------------------------------------------
  wp_server <- function(input, output, session) {

    # When the function runs, set up the right path, and read in the current tracker
    wp_path <- file.path(".", wp_dir)

    # Check if the tracker exists - if it doesn't we can't do much!
    if (!file.exists(wp_path)) {
      message("Specified work products folder does not exist.")
      shiny::stopApp()
    }

    # Listen for the 'done' event. This event will be fired when a user
    # is finished interacting with your application, and clicks the 'done'
    # button.
    shiny::observeEvent(input$done, {
      tracker_path <- file.path(wp_path, tracker_name)
      # Get the current tracker
      current_tracker <- utils::read.csv(
        tracker_path,
        stringsAsFactors = FALSE
      )

      # Set up details of the current work product using the inputs, and some defaults
      current_wp <- data.frame(
        id = max(1, current_tracker$id + 1),
        name = input$name,
        prepared_by = input$prep,
        delivered_to = input$del,
        version = 1,
        last_updated = as.character(Sys.Date()),
        comments = input$comment,
        stringsAsFactors = FALSE
      )

      # Combine the old tracker with the new work product
      new_tracker <- rbind(current_tracker, current_wp)

      # Sort by ID
      ord <- order(new_tracker$id)
      new_tracker <- new_tracker[ord, ]

      # Write back out to file
      utils::write.csv(new_tracker, tracker_path, row.names = FALSE)

      # Get the numeric ID of the newly-created wp
      id <- current_wp$id

      # Turn it into a wp-id in 3-number form
      id <- sprintf("%03d", id)

      # Folder name
      nm <- tolower(input$folder)
      nm <- stringr::str_replace_all(nm, "[:punct:]", "")
      nm <- stringr::str_replace_all(nm, " ", "-")
      nm <- paste(id, nm, sep = "-")

      # Make the directory to put it in
      dir.create(file.path(wp_path, nm))

      # Close the app
      shiny::stopApp()
    })

    shiny::observeEvent(input$cancel, {
      shiny::stopApp()
    })
  }


  # Run the app ----------------------------------------------------------------
  viewer <- shiny::dialogViewer("Create a new work product")
  shiny::runGadget(wp_ui, wp_server, viewer = viewer, stopOnCancel = FALSE)
}
