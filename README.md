# Covid Dashboard using shinydashboard

This is a dashboard for covid-19 cases in Colombia, inspired by the one published by the Colombian National Health Institute -INS- availiable in this [page](https://www.ins.gov.co/Noticias/paginas/coronavirus.aspx), using the shiny and shinydashboard packages in R.

## Contents

The repository contains the following:

- `preparations.R`: Contains come preliminary steps before running the covid dashboard. These steps include loading the required packages, downloading the most recent data from INS and creating the geometries needed for the maps.
- `app` folder: This folder contains `ui.R` and `server.R` needed to run the dashboard.
- `data` folder: This folder has the main covid-19 cases used to run the dashboard and is the default destination for the downloaded data using `preparations.R`.
- `geometry`: Contanins the `marker_points.shp` used to create a map with leaflet. It is also the default destination of some downloads in `preparations.R` in order to create said shapefile.

## Instructions

First, set your working directory to the folder in which you downloaded or cloned the respository. Make sure you are not inside any subfolder in the repository.

Then, load and run the `preparations.R` file up until line 32. If you want to know how the included shapefile was created, run lines 32 to 43.

After that, you can run the dashboard by opening either `ui.R` or `server.R` and clicking the Run App button from withing RStudio or by typing:

```r
shiny::runApp("app")
```

## License

This project is published under the [MIT](https://github.com/camartinezbu/covid-dashboard-replica-colombia/blob/master/LICENSE) license.
