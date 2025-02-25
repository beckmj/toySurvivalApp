#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @import dplyr
#' @importFrom magrittr `%>%`
#' @import survminer
#' @noRd
app_server <- function(input, output, session) {

  selected_data <- mod_view_data_server("data")
}
