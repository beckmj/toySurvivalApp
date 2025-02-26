#' view_eda UI Function
#'
#' @description Visualize the distributions of selected datasets
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import ggplot2
mod_view_eda_ui <- function(id) {
  ns <- NS(id)

  div(
  fluidRow(uiOutput(ns("description"))),
  br(),
  br(),
  fluidRow(uiOutput(ns("viz")))
  )
}

#' view_data Server Functions
#'
#' @noRd
mod_view_eda_server <- function(id, data_btn, viz_btn, viz_interact_btn){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # -- Build the plot objects --
    # Note: the name of the dataset is passed instead of the previewed data
    # in the event the user is opting to only look at the first 5 rows

    df <- reactive({
      select_dataset(data_btn())
    })

    plot_viz <- reactive({

      df() %>%
        select(where(is.numeric)) %>%
        tidyr::pivot_longer(everything()) %>%
        make_eda_plot(., viz_btn())

    })

    # Describe the variables
    output$description <- renderUI({
      vars <- "Does not apply"

      dropped_cols <- df() %>% select(!where(is.numeric)) %>% names()

      if(length(dropped_cols) > 0){
        vars <- paste0(dropped_cols, collapse = ', ')
      }

      HTML(glue::glue("{nrow(df())} observations visualized.<br>
                      Categorical variables are omitted. ({vars})"))
    })


    # -- Return the plot object --
    # wrapping in a `renderUI` allows us to call conditional render functions
    output$viz <- renderUI({

      if (viz_btn() == "None"){
        HTML("No summary visualization has been selected.  To begin, please choose
        an option from the <b>Visualize Variables&nbsp</b>  selector in the <b>Plot Options&nbsp</b>
        sidebar.")
      } else if (viz_interact_btn() == "No"){

        renderPlot(plot_viz())
      } else {
        plotly::renderPlotly(plot_viz())
      }


    })


  })
}


# mod_view_eda ------------------------------------------------------

# Note: `_demo` modules allow for independent development and debugging before
# integrating with the remainder of the application

mod_view_eda_demo <- function(){

  ui <- fluidPage(
    title = "View Data Demo",
    fluidRow(mod_view_eda_ui("viz")),

    # This section allows for confirming the elements' structure being
    # returned from each module
    fluidRow(
      div(style = "padding-top: 200px"),
      "View output:", verbatimTextOutput('test_output'))
  )

  server <- function(input, output, session){

    mod_view_eda_server(
      id = "viz",
      data_btn = reactive("BMT"),
      viz_btn = reactive("Density"),
      viz_interact_btn = reactive("No")
    )

    # output$test_output <- renderPrint(
    #   lapply(test_output, function(x) x())
    # )
  }

  shinyApp(ui, server)
}

