
#' Wrapper to return available datasets
#'
#' @param nm character indicating single dataset to select
#'
#' @returns data.frame containing survival information
#' @examples
#'
#' select_dataset("BMT")
#'
#' @noRd
select_dataset <- function(nm){

  # define available datasets
  available_data <- list(
    BMT = survminer::BMT,
    BRCAOV = survminer::BRCAOV.survInfo,
    `NCCTG Lung Cancer` = survival::lung
  )

  # check for validity
  available_data_str <- paste(names(available_data), collapse = '", "')

  if(length(nm) > 1){
    stop(glue::glue('Too many dataset names provided!
                    Please select single dataset from the following options: "{available_data_str}"'),
         call. = FALSE)
  }

  if(!nm %in% names(available_data)){

    stop(glue::glue('Invalid dataset name!  Options include: "{available_data_str}"'), call. = FALSE)

  }

  # return the dataset

  available_data[[nm]]
}


