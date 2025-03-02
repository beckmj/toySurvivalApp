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
#' @import reactable
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
         icon = bsicons::bs_icon("table"),
         selectInput(ns("data_btn"),
          "Available Datasets:",
          choices = c("BMT", "BRCAOV", "NCCTG Lung Cancer")),
         radioButtons(ns("format_btn"),
                      "Table Format",
                      choices = c("Interactive", "Print-Ready")),
         radioButtons(ns("head_btn"),
                      "Preview Sample Only:",
                      choices = c("Yes", "No"))
     ),

     # Viewing options: ,
        accordion_panel(
          "Plot Options",
          icon = bsicons::bs_icon("bar-chart-line-fill"),
          radioButtons(ns("viz_btn"),
                       "Visualize Variables",
                       choices = c("Histogram", "Box Plot", "Density", "None")),
          radioButtons(ns("viz_interact_btn"),
                       "Plot Interactivity",
                       choices = c("Yes", "No")),
          downloadButton(ns("ppt_btn"),
                         "Download Editable Plots")
        ),

     # Export options: format
       accordion_panel(
         "Export Options",
         icon = bsicons::bs_icon("journal-arrow-down"),
         selectInput(ns("file_btn"),
                      "Download Format:",
                      choices = c("Word", "PDF"),
                      selected = "Word")
       )
     ), # close accordion menu

    # Page Body
    shinyjs::disabled(downloadButton(ns("export_btn"), "Download Data Overview")),
    br(),
    fluidRow(
      column(6,
             h3("Data Preview"),
             uiOutput(ns("selected_df"))),
      column(6,
             h3("Exploratory Plots"),
             mod_view_eda_ui(ns("eda")))
    )

   )
  ) # close panel
}

#' view_data Server Functions
#'
#' @noRd
mod_view_data_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    observe({
      shinyjs::enable("export_btn")
      shinyjs::enable("ppt_btn")}) # workaround for default inaction


# Apply Options -----------------------------------------------------------


    selected_df <- reactive({
      df <- select_dataset(input$data_btn)

      if(input$head_btn == "Yes"){
        df <- head(df, 5)
      }

      # return for further processing
      df

      })

    output$ppt_btn <- downloadHandler(
      filename = "editable_plots.pptx",
      content = function(file){
        download_plots(file, input$data_btn)
      }
    )

# App Body ----------------------------------------------------------------

    # -- Download data summary --
    table_name <- reactive({

      formats = list(
        "Word" = ".docx",
        "PDF" = ".pdf"
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

    # -- determine which kind of data table to show --
    print_view <- eventReactive({c(input$format_btn, input$head_btn)}, {

      selected_df() %>%
          flextable() %>%
          htmltools_value()

    })

    interact_view <- eventReactive({c(input$format_btn, input$head_btn)}, {

        selected_df() %>%
          reactable(
            bordered = TRUE,
            striped = TRUE,
            highlight = TRUE
          )
    })

    output$selected_df <- renderUI({


      if(input$format_btn == "Interactive"){
        interact_view() %>% renderReactable()
      } else {
        print_view()
      }


    })

    # -- Handle the plotting --

    # child module is source of plots
    d <- reactive({input$data_btn})
    v <- reactive({input$viz_btn})
    i <- reactive({input$viz_interact_btn})

    mod_view_eda_server("eda", d, v, i)

    # return data set name for analysis modules
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

