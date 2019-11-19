library(shiny)

ds <- read.csv('2019-11-01_sigesguarda_-_Base_de_Dados.csv', header = TRUE, sep = ";", encoding = "latin1")
por_bairro <- as.data.frame(summary(ds$ATENDIMENTO_BAIRRO_NOME))

ui <- fluidPage(
    titlePanel("Segurança em Curitiba - Parte 2"),


    mainPanel(
       plotOutput("distPlot")
    )

)

server <- function(input, output) {

    output$distPlot <- renderPlot({
        x    <- por_bairro[, 1]
        bins <- row.names(por_bairro)
        
        barplot(por_bairro[,1], names.arg = row.names(por_bairro), horiz=TRUE)
    })
}

shinyApp(ui = ui, server = server)
