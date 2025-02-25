

#' Export data in a variety of formats.
#'
#' @param filepath character indicating the filename.  This is created
#' via a reactive expression within modules
#' @param src_file character indicating the path of the Quarto
#' document to render
#' @param params named list containing arguments to pass to the Quarto upon
#' execution
#'
#' @returns nothing?
#' @import quarto
#'
#' @examples
#'
#' download_file("test.docx")
#'
#'
#' @noRd
download_file <- function(filepath,
                          src_file = paste0(app_sys("app/www/quarto"), "/tbl_template.qmd"),
                          params = NULL){

  # identify the filetype requested by the user
  extension <- gsub(".*\\.", "", filepath)

  # create a temporary copy of src_file.qmd
  quarto::quarto_render(src_file,
                        output_format = extension,
                        execute_params = params)

  # replace the .qmd with the rendered filetype
  output <- gsub("qmd", extension, src_file)

  # move and rename the file
  file.copy(
    output,
    filepath
  )

  # clean up artifacts
  file.remove(output)

}
