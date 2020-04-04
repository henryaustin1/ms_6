#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(spdplyr)
library(rmapshaper)
library(sf)

data1950<-read.csv("nhgis0013_ds82_1950_tract.csv")%>%
    filter(STATE == "Michigan" & B0F001 > 0)%>%
    mutate(MedianHHIncome1949 = B0F001)%>%
    select(GISJOIN,MedianHHIncome1949)

# Import Census Tract Shapefile into R as SpatialPolygonsDataFrameFormat (SP Dataframe)
# dsn is location of folder which contains shapefiles, (.proj, .shp etc.)
# layer is the filename of the .shp file inside the
# folder dsn points to. 

tracts1950 <-sf::st_read(dsn = "nhgis0012_shapefile_tl2008_us_tract_1950",
                         layer = "US_tract_1950_conflated")

# Select Michigan observations only using NHGISST variable
# NHGISST should be consistent between census years, but you might need to double-check this
# if you try 1960, 1970.
# The code is 260 for Michigan because Michigan's FIPS code is 260. Google
# Michigan FIPS code for more information.
# Need to have spdplyr package loaded to use tidyverse commands on
# SpatialPolygonsDataFrame aka `filter' and 'mutate'
# join the data1950 data with the MedianHHIncome variable by 'GISJOIN'
# so that the tract lines and income data are in one object

tracts1950<-
    tracts1950 %>% filter(NHGISST == "260")%>%
    merge(data1950, "GISJOIN")


# Set projection of tracts dataset to `projection` required by leaflet

tracts1950<-sf::st_transform(tracts1950,  crs="+init=epsg:4326")

# Condense size of data for faster processing

tracts1950<-rmapshaper::ms_simplify(tracts1950)

# Set palette color

pal <- colorNumeric("viridis", NULL)








ui <- fluidPage(

    # Application title
    titlePanel("Median Income in 1950"),

    # Sidebar with a slider input for number of bins 
    ui <- fluidPage(
        leafletOutput("mymap"),
        p(),
        actionButton("recalc", "New points")
    )
    
        )


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$mymap <- renderLeaflet({
        leaflet(tracts1950) %>%
            addTiles() %>%
            addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1,
                        fillColor = ~pal(MedianHHIncome1949)) %>%
            addLegend(pal = pal, values = ~MedianHHIncome1949, opacity = 1.0)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
