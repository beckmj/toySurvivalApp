#' view_data UI Function
#'
#' @description Allow users to select datasets embedded in `survival` package.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import flextable
mod_view_data_ui <- function(id) {
  ns <- NS(id)

  nav_panel(
   title = "Data Selection",
   shinyjs::useShinyjs(),
   # options
   layout_sidebar(
     sidebar = accordion(

       # Data options: selection
       accordion_panel(
         "Dataset Options",
         icon = bsicons::bs_icon("sliders"),
         selectInput(ns("data_btn"),
          "Available Datasets:",
          choices = c("BMT", "BRCAOV", "NCCTG Lung Cancer")),
         radioButtons(ns("head_btn"),
                      "Preview Sample Only:",
                      choices = c("Yes", "No"))
     ),

     # Viewing options: Interactive vs. Print Ready),
        accordion_panel(
          "Viewing Options",
          icon = bsicons::bs_icon("table"),
          radioButtons(ns("format_btn"),
                       "Table Format",
                       choices = c("Interactive", "Print-Ready")),
          radioButtons(ns("viz_btn"), #TODO: show density, histogram, or box plots
                       "Visualize Variables",
                       choices = c("None", "Histogram", "Box Plot", "Density"))
        ),

     # Export options: format and button
       accordion_panel(
         "Export Options",
         icon = bsicons::bs_icon("journal-arrow-down"),
         selectInput(ns("file_btn"),
                      "Download Format:",
                      choices = c("Word", "PDF", "HTML"),
                      selected = "Word")
       )
     ), # close accordion menu

    # Page Body
    #uiOutput(ns("data_description")),
    shinyjs::disabled(downloadButton(ns("export_btn"), "Download Data Overview")),
    uiOutput(ns("selected_df"))

   )
  ) # close panel
}

#' view_data Server Functions
#'
#' @noRd
mod_view_data_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns


# Apply Options -----------------------------------------------------------


    selected_df <- reactive({
      df <- select_dataset(input$data_btn)

      if(input$head_btn == "Yes"){
        df <- head(df, 20)
      }

      # return for further processing
      df

      })

    table_name <- reactive({

      formats = list(
        "Word" = ".docx",
        "PDF" = ".pdf",
        "HTML" = ".html"
      )

      paste0(input$data_btn, formats[[input$file_btn]])

      })

    output$export_btn <- downloadHandler(
      filename = function() table_name(),
      content = function(file){

        p <- list(
          selected_df = input$data_btn
        )

        download_file(file, params = p)
      }
    )

# App Body ----------------------------------------------------------------

    observe(shinyjs::enable("export_btn")) # workaround for default inaction

    output$selected_df <- renderUI({

      selected_df() %>%
        flextable() %>%
        htmltools_value()
    })

    # -- return data set name for analysis modules --
    return(
      list(
      data_set = selected_df
      )
    )

  })
}


# mod_view_data_demo ------------------------------------------------------

# Note: `_demo` modules allow for independent development and debugging before
# integrating with the remainder of the application

mod_view_data_demo <- function(){

  ui <- page_navbar(
    title = "View Data Demo",
    fluidRow(mod_view_data_ui("data")),

    # This section allows for confirming the elements' structure being
    # returned from each module
    fluidRow(
      div(style = "padding-top: 200px"),
      "View output:", verbatimTextOutput('test_output'))
  )

  server <- function(input, output, session){

    test_output <- mod_view_data_server("data")

    output$test_output <- renderPrint(
      lapply(test_output, function(x) x())
    )
  }

  shinyApp(ui, server)
}

