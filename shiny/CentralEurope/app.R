#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(gapminder)
data(gapminder)
# Countries of interest
cc <- c("Albania",
        "Austria",
        "Belgium",
        "Bosnia and Herzegovina",
        "Bulgaria",
        "Czech Republic",
        "Germany",
        "Greece",
        "Holland",
        "Hungary",
        "Poland",
        "Serbia",
        "Romania",
        "Slovak Republic",
        "Slovenia")
animationOptions(
    interval = 2000,
    loop = TRUE,
    playButton = NULL,
    pauseButton = NULL
)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Central Europe"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("year",
                        "Year:",
                        min = 1952,
                        max = 2002,
                        step = 5,
                        value = 1952,
                        animate = TRUE),
            tags$h4("Central European Countries in years 1952 - 2002"),
            tags$p("Hit the play button or move the slider to see 14 Central European Coutries statistics."),
            tags$p("The following aestetics are employed:"),
            tags$div(
                tags$ul(
                    tags$li("X-axis - Life Expectancy"),
                    tags$li("size - Population (Mln)"),
                    tags$li("color - GDP per Capita (USD)")
                )
            )
        ),
        # Show a plot of the generated distribution
        mainPanel(
            h3(textOutput("output_countries_years")),
            textOutput("info"),
            textOutput("more_info"),
            plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate data based on input$year from ui.R
        # draw the histogram with the specified number of bins
        gapminder %>%
            filter(country %in% cc & year == input$year ) %>%
            ggplot() +
            aes(x = lifeExp, y = country) +
            coord_cartesian(xlim = c(53, 80)) +
            aes(size = pop/1e6, col = gdpPercap) +
            geom_point(shape = 19, alpha = 0.5) +
            scale_color_gradientn(colours = rainbow(4), limits = c(500, 33000), name = "GDP per Capita (USD)") +
            scale_size_area(max_size = 20, limits = c(1, 100), name = "Population (Mln)") +
            labs(x = "Life Expectancy",
                 y = "",
                 title = paste("Central European Countries (", input$year, ")"))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
