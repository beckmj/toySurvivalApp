#' Visualize distributions with common plot types
#'
#' @param df_long data.frame containing two columns.  "name" is the variable
#' name from the original data frame, "value" is the observation
#' @param viz_btn character indicating user's input of which plot to export
#'
#' @returns a ggplot of all numeric variables
#'
#' @examples
#'
#' # generate data
#' set.seed(101)
#'
#' df <- data.frame(
#' a = runif(100),
#' b = runif(100, min = 1, max = 10),
#' c = round(runif(100, min = 1, max = 100), 0)
#' ) %>%
#' tidyr::pivot_longer(everything())
#'
#' # visualize
#' make_eda_plot(df, "Histogram")
#'
#'
#' @noRd
make_eda_plot <- function(df_long, viz_btn){

  # initialize ggplot object
  base_plot <- ggplot(df_long, aes(x = value))

  # apply specified geometry
  viz_type_plot <- switch(viz_btn,
    Histogram  = base_plot + geom_histogram(),
    Density    = base_plot + geom_density(),
    `Box Plot` = base_plot + geom_boxplot()
  )

  # apply nice formatting
  viz_type_plot +
    facet_wrap(~name, scales = "free") +
    theme_minimal() +
    theme(
      panel.border = element_rect(fill = NA, color = 'gray')
    )

}
