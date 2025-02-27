# toySurvivalApp

#### A skill demonstration by Jennifer Beckman

<!-- badges: start -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

## Installation:

1.  Clone this repository onto local machine.

    [`git clone https://github.com/beckmj/toySurvivalApp.git`](https://github.com/beckmj/toySurvivalApp.git){.uri}

2.  On the "Build" tab, select "Install".

3.  To launch the app, run the following command from any R Studio session.

    `toySurvivalApp::run_app()`

## Features:

### Shiny Modules

In this demo, the visualization module was separated from the data preview module. This increases the readability of the module, as it is designed with a single clear purpose. Modularizing also allows for isolating the functionality while building and debugging. Each module is set up with a `mod_*_demo()` function that runs the code in a miniature app with hard-coded inputs. The app can be tested interactively and its outputs, if any, are visible to the developer.

To see modularization in action, please view the `R/mod_view_eda.R` file or run `toySurvivalApp:::mod_view_eda_demo()`.

### Multi-format exports with Quarto

Posit's markdown system, Quarto, allows for generation of different file types from the same document. Functions used within the application can be re-used in the document generation, ensuring parity between what was viewed in the application and what is shared with external audiences.

Please view the Quarto template at `inst/app/www/quarto/tbl_template.qmd` .

### Editable plots

Automating plot outputs is ideal, but there are always edge cases that manage to break the formatting. There are several techniques that can empower users to get the view that best represents their data:

-   plotly exports: Within the application, a user can frame the data on the interactive plot and export as a .png.

-   ggplot exports: Users can convert a ggplot image into separate drawing objects in Microsoft Office (PowerPoint is recommended for ease of manipulation). This allows users to move data labels and make cosmetic changes to color or fonts without needing to modify the underlying ggplot code. This technique is appropriate for any ggplot-supported geometry.

### Testing Applications

This application uses a [golem](https://engineering-shiny.org/golem.html?q=www#golem) framework, meaning that the application is an R package and can be verified with `testthhat`. Individual tests can be found in tests/testthat/ or can be run with `devtools::test()` .
