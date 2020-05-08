library(shiny)
library(leaflet)
library(spdplyr)
library(rmapshaper)
library(sf)
library(shinythemes)

tracts1950 <- readRDS("tracts1950.RDS")
tracts1960 <- readRDS("tracts1960.RDS")
tracts1970 <- readRDS("tracts1970.RDS")
tracts1980 <- readRDS("tracts1980.RDS")
tracts1990 <- readRDS("tracts1990.RDS")
tracts2000 <- readRDS("tracts2000.RDS")
tracts2010 <- readRDS("tracts2010.RDS")
tracts2018 <- readRDS("tracts2018.RDS")
pal <- colorNumeric("viridis", NULL)


ui <- navbarPage(theme = shinytheme("cosmo"),
    "Wealth in Michigan",
               tabPanel("About",br(),
                        h2("Visualizing Wealth Over Time In Michigan"),
                        column(6, p("The goal of this project is to illuminate patterns of wealth inequality over the
                        past seventy years in Michigan and its implications on the state we see today. Growing
                        up in a small town in West Michigan, it was easy to see the drastic disparities, particularly
                        in wealth and education, between communities just miles apart and the differences in opportunity as a result of underfunded schools and lack of resources."), br(),
                         
                        p("Through my analysis, I created interactive maps by census tract that highlight the median 
                        family income in each census tract. This allows us to closely examine differences between neighborhoods,
                        especially in sprawling urban zones such as Detroit and Grand Rapids. In tandem with visualizing the geographic 
                        state of wealth in Michigan, I also examined the differences in educational attainment to see if differences in the
                        number of educated persons by census tract are correlated to differences in median family income."), br(),
                          
                        p("I hope that the findings of this project can be used to identify and support underserved communities in my home
                        state, especially as poor communities and communities of color are currently the hardest hit by the COVID-19 pandemic. 
                        In a post-COVID society, I hope this could also serve to highlight disparities in opportunity and guide toward changes that will 
                        correct wealth inequality and its outcomes in Michigan."),
                        br(), h2("Data"), 
                        p("For this project, I collected data for median household income and educational attainment for each census tract from each decennial 
                        census from 1950 to 2010 from the NHGIS database, as well the 2018 American Communities Survey. The median household income for 1960 and 1970 had to be approximated
                        as the data was only available in a number of families within certain income ranges. Additionally, in this project, educational attainment is
                        defined as the number of people who attended college in some capacity. 
"),
                        a("Image Credit: Kwamikagami", href = "https://commons.wikimedia.org/wiki/File:Lake_Huron-Michigan_(satellite).png"),
                        h2("About Me"),
                         p("My name is Henry Austin and I am currently a first-year student at Harvard College. I am planing on studying Social Studies with a focus on
                          inequality and a secondary in Computer Science. You can reach me at"), a("henryaustin@college.harvard.edu", href = "mailto: henryaustin@college.harvard.edu"), "or",
                        a("LinkedIn", href = "https://www.linkedin.com/in/henry-austin-8947b9199/."), br()),
                        column(1, align = "right", imageOutput("grandhavensunset", height = "70%") )),
                        
                tabPanel("Median Family Income",
                    tabsetPanel(type = "tabs",
                         tabPanel("1950",
                         leafletOutput("map1950")),
                         tabPanel("1960",
                         leafletOutput("map1960")),
                         tabPanel("1970",
                         leafletOutput("map1970")),
                         tabPanel("1980",
                         leafletOutput("map1980")),
                         tabPanel("1990",
                         leafletOutput("map1990")),
                         tabPanel("2000",
                         leafletOutput("map2000")),
                         tabPanel("2010",
                         leafletOutput("map2010")),
                         tabPanel("2018",
                         leafletOutput("map2018")))),
                    tabPanel("Analysis",
                            tabsetPanel(type = "tabs",
                                        
                            tabPanel("Detroit and Grand Rapids Over Time",
                                     
                            fixedRow(column(5,
                            p("The gifs show the development of wealth in two of Michigan’s largest cities, Detroit (pictured top) and Grand Rapids (pictured below). 
                                                The first image shows each of the cities in 1950, then 1960, and so on. The data for some regions (notably Grand Rapids in 1950) along
                                                with other census tracts is missing as there was not data available at this time. It is particularly notable to observe the concentration 
                                                (and lack of concentration) of wealth in these areas over time. Looking at Detroit, the movement of wealth away from the city center and areas
                                                such as Grosse Pointe and toward suburban regions such as Bloomfield Hills, Birmingham, and Northville. In Grand Rapids, similar trends are present
                                                as initial wealth in 1960 moves away from the city center and becomes very concentrated in areas such as East Grand Rapids. This visualization 
                                                shows the impact of “white flight” on these urban centers. In the mid 20th century, African-American families began moving into major metropolitan
                                                areas in larger numbers, leaving the Jim Crow South. This prompted a dramatic decrease in the white population in these areas as the result of 
                                                discrimination and racial tensions.", a('Between 1960 and 1970 the white populations of central cities in U.S. metropolitan areas declined by 9.6%.',href = "https://www.irp.wisc.edu/publications/focus/pdfs/foc32a.pdf"
)," 
                                                This resulted in “city tax bases eroding and job markets declining as companies seek cheaper, newer, or more accessible facilities in the suburbs, 
                                                their schools and services struggle against the combined impact of inflation, unemployment, and shrinking federal assistance.” This can be directly
                                                observed as the median household income increases in the suburban areas outside of both Grand Rapids and Detroit, while the median household income 
                                                within these cities decreases and grows at a much slower rate over the following decade.")), br(),
                            
                                 column(5, offset = 2, imageOutput("detroit", height = "90%"), br(),
                                         imageOutput("grandrapids", height = "90%"))), br(),
                                    
                                     fixedRow(column(5,
                                         p("Another interesting aspect of this is the impact of redlining on current wealth distributions in these cities. Redlining is a form 
                                                             of discrimination through which banks and other companies denied loans, insurance, and mortages to certain areas, particularly neighborhoods
                                                             which consisted of predominately African-American residents. The maps on the left, created in the 1930s, were created by the Home Owners Loan Corporation
                                                             which graded each neighborhood arbitrarily based factors such as racial demographics. Areas with a “yellow” or “red” score were ineligible from receiving 
                                                             backing from the Federal Housing Administration as part of the New Deal of the early 1930s. With this the government deliberately created mass
                                                             disinvestment and severe inequality in resources between these areas and others just a few blocks away. Despite redlining being banned in the 1960s,
                                                             the damage inflicted upon these communities is  clearly still felt today as the map of median household income in 2018 mirrors that of the redlining 
                                                             map. These factors highlight the racialized nature of wealth inequality in the state as well as the impact it has on communitiies today.")),
                                         
                                                column(6, imageOutput("redliningdetroit", height = "1%", width = "1%"), br(),
                                                imageOutput("redlininggrandrapids", height = "1%",width = "1%")))),
                            
                                         tabPanel("Education and Income",
                            fixedRow(column(5, p("I also examined the relationship between education and median household income. Do census tracts with a higher median household income have a “more educated” population? 
                                                 The table illustrates the correlation coefficients between the median household income and the education attainment (number of individuals who attended college in some capacity).
                                                 Data for this was available only from 1990 to 2010. Over this time span, the correlation between these two variables becomes increasingly negative, changing from a strong positive
                                                 correlation to a strong negative one across these decades. Many factors could have contributed to this, but I suggest that the increase in overall population across the time span may
                                                 have resulted in an artificial decrease in this correlation, making it difficult to see the real correlation between an increase in median household income and education attainment 
                                                 in this data.")),
                                   column(5, imageOutput("education")), br(),
                                   
                                   fixedRow(column(5, p(" I also tested to see if there was a correlation between the median household income in each census year and median household income in 2018 to see if the income decades ago 
                                   could be a predictor of current household income. As evidenced in the table, over time in the correlation between the variables becomes stronger. This makes sense because with every decade closer
                                   to 2018, there is less time for median household income of each census tract to change. However, I suggest that there are more factors at play. Perhaps the correlation since 2000 has become particularly
                                   strong as the result of segregation into communities based on class, as well as more rigid geographic wealth disparities between the rich and poor areas, especially following the 2008 Great Recession, housing discrimination, and other historic policies
                                   such as redlining, which caused massive upward redistributions of wealth. Further research into this topic should explore wealth before and directly after modern crises such as the Great Recession and COVID-19 pandemic, as well other 
                                   government policies and the impact they have on the geographic
                                    distribution of wealth and census tract demographic composition.")), 
                                   column(5, imageOutput("income"))))))))

                            
                         
                

server <- function(input, output) {

    output$map1950 <- renderLeaflet({
        leaflet(tracts1950) %>%
            addTiles() %>%
            addPolygons(popup = paste0("Median Family Income: $", tracts1950$MedianHHIncome1949), stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
                        fillColor = ~pal(MedianHHIncome1949)) %>%
            addLegend(pal = pal, values = ~MedianHHIncome1949, title = "Median Income", opacity = 1.0)
    })
    
    output$map1960 <- renderLeaflet({
        leaflet(tracts1960) %>%
            addTiles() %>%
            addPolygons(popup = paste0("Median Family Income: $", tracts1960$MedianIncome.x), stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
                        fillColor = ~pal(MedianIncome.x)) %>%
            addLegend(pal = pal, values = ~MedianIncome.x, title = "Median Income", opacity = 1.0)
    })
    
    output$map1970 <- renderLeaflet({
        leaflet(tracts1970) %>%
            addTiles() %>%
            addPolygons(popup = paste0("Median Family Income: $", tracts1970$MedianIncome), stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
                        fillColor = ~pal(MedianIncome)) %>%
            addLegend(pal = pal, values = ~MedianIncome, title = "Median Income", opacity = 1.0)
    })
    
    output$map1980 <- renderLeaflet({

        leaflet(tracts1980) %>%
            addTiles() %>%
            addPolygons(popup = paste0("Median Family Income: $", tracts1980$MedianHHIncome1980),stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
                        fillColor = ~pal(MedianHHIncome1980)) %>%
            addLegend(pal = pal, values = ~MedianHHIncome1980, title = "Median Income",  opacity = 1.0)
    })
    
    output$map1990 <- renderLeaflet({
        leaflet(tracts1990) %>%
            addTiles() %>%
            addPolygons(popup = paste0("Median Family Income: $", tracts1990$MedianHHIncome1990), stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
                        fillColor = ~pal(MedianHHIncome1990)) %>%
            addLegend(pal = pal, values = ~MedianHHIncome1990, title = "Median Income", opacity = 1.0)
    })
    
    output$map2000 <- renderLeaflet({
        leaflet(tracts2000) %>%
            addTiles() %>%
            addPolygons(popup = paste0("Median Family Income: $", tracts2000$MedianHHIncome2000), stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
                        fillColor = ~pal(MedianHHIncome2000)) %>%
            addLegend(pal = pal, values = ~MedianHHIncome2000, title = "Median Income", opacity = 1.0)
    })
    
    output$map2010 <- renderLeaflet({
        leaflet(tracts2010) %>%
            addTiles() %>%
            addPolygons(popup = paste0("Median Family Income: $", tracts2010$MedianHHIncome2010), stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
                        fillColor = ~pal(MedianHHIncome2010)) %>%
            addLegend(pal = pal, values = ~MedianHHIncome2010, title = "Median Income", opacity = 1.0)
    })
    output$map2018 <- renderLeaflet({
        leaflet(tracts2018) %>%
            addTiles() %>%
            addPolygons(popup = paste0("Median Family Income: $", tracts2018$MedianHHIncome2018), stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.8,
                        fillColor = ~pal(MedianHHIncome2018)) %>%
            addLegend(pal = pal, values = ~MedianHHIncome2018, title = "Median Income", opacity = 1.0)
    })
    
    output$detroit <- renderImage({
        # Return a list containing the filename
        list(src = "detroit.gif",
             contentType = 'image/gif'
             # width = 400,
             # height = 300,
             # alt = "This is alternate text"
        )}, deleteFile = FALSE)
    
    output$grandrapids <- renderImage({
        # Return a list containing the filename
        list(src = "grandrapids.gif",
             contentType = 'image/gif'
            # width =300,
             #height = 300
             # alt = "This is alternate text"
        )}, deleteFile = FALSE)
    
    output$grandhavensunset <- renderImage({
        # Return a list containing the filename
        list(src = "Lake_Huron-Michigan_(satellite).png",
             contentType = 'image',
             width = 500,
             height = 500
             # alt = "This is alternate text"
        )}, deleteFile = FALSE)
    
    output$redliningdetroit <- renderImage({
        # Return a list containing the filename
        list(src = "redliningdetroit.jpg",
             contentType = 'image',
             width = 700,
             height = 300
             # alt = "This is alternate text"
        )}, deleteFile = FALSE)
    
    output$redlininggrandrapids <- renderImage({
        # Return a list containing the filename
        list(src = "redliningrandrapids.jpg",
             contentType = 'image',
             width = 600,
             height = 400
             # alt = "This is alternate text"
        )}, deleteFile = FALSE)
    
    output$education <- renderImage({
        # Return a list containing the filename
        list(src = "educationvsincome.png",
             contentType = 'image',
             width = 800,
             height = 200
             # alt = "This is alternate text"
        )}, deleteFile = FALSE)
    
    output$income <- renderImage({
        # Return a list containing the filename
        list(src = "incomeprediction.png",
             contentType = 'image',
             width = 1000,
             height = 400
             # alt = "This is alternate text"
        )}, deleteFile = FALSE)
}

# Run the application 
shinyApp(ui = ui, server = server)
