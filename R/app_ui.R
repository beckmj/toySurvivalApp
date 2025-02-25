link_shiny <- tags$a(shiny::icon("github"), "Shiny", href = "https://github.com/rstudio/shiny", target = "_blank")
link_posit <- tags$a(shiny::icon("r-project"), "Posit", href = "https://posit.co", target = "_blank")

#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  golem_add_external_resources()

  page_navbar(
    title = "survminer Shiny Demo",
    navbar_options = navbar_options(
      bg = "#0062cc",
      underline = TRUE
    ),
    mod_view_data_ui("data"),
    nav_panel(title = "Two", p("Second tab content.")),
    nav_panel(title = "Three", p("Third tab content")),
    nav_spacer(),
    nav_menu(
      title = "Links",
      align = "right",
      nav_item(link_shiny),
      nav_item(link_posit)
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "toySurvivalApp"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
