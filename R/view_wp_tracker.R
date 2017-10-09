#' View the work products tracker
#'
#' A function created purely to facilitate an RStudio addin to display the current work products tracker.
#'
#' @references "Guerrilla Analytics: A Practical Approach to Working with Data", Enda Ridge (\href{https://guerrilla-analytics.net/}{Website})


view_wp_tracker <- function() {

  # Create the UI --------------------------------------------------------------
  wp_ui <- miniUI::miniPage(
    miniUI::miniContentPanel(
      ## Add UI items
      DT::dataTableOutput("wp_tracker"),
      miniUI::gadgetTitleBar(title = NULL)
    )
  )

  # Create the server functionality --------------------------------------------
  wp_server <- function(input, output, session) {

    # When the function runs, set up the right path, and read in the current tracker
    wp_path <- file.path(".", "wp")

    # Check if the tracker exists - if it doesn't we can't do much!
    if ( !file.exists(wp_path) ) {
      message("Work products folder does not exist. Did you initialise the project with one?")
      shiny::stopApp()
    }

    # Set the path
    tracker_path <- file.path(wp_path, "work-products-tracker.csv")

    # Check if the tracker exists - if it doesn't we can't do much!
    if ( !file.exists(tracker_path) ) {
      message("Work products tracker does not exist. Did you initialise the project with one?")
      shiny::stopApp()
    }

    # Get the current tracker
    current_tracker <- read.csv(
      tracker_path,
      stringsAsFactors = FALSE
    )

    # Create an object to display it
    output$wp_tracker <- DT::renderDataTable({
      DT::datatable(current_tracker)
    })

    # Listen for the 'done' event. This event will be fired when a user
    # is finished interacting with your application, and clicks the 'done'
    # button.
    shiny::observeEvent(input$done, {
      # Close the app
      shiny::stopApp()
    })

    shiny::observeEvent(input$cancel, {
      shiny::stopApp()
    })
  }


  # Run the app ----------------------------------------------------------------
  viewer <- shiny::dialogViewer("View work products", width = 1000)
  shiny::runGadget(wp_ui, wp_server, viewer = viewer, stopOnCancel = FALSE)
}


