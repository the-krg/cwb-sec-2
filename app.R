library(shiny)
library(plotly)

ds <- read.csv('2019-11-01_sigesguarda_-_Base_de_Dados.csv', header = TRUE, sep = ";", encoding = "latin1")
porBairro <- as.data.frame(summary(ds$ATENDIMENTO_BAIRRO_NOME))
origChamado <- as.data.frame(table(ds$ORIGEM_CHAMADO_DESCRICAO))
origChamado <- origChamado[order(origChamado[2], decreasing = TRUE), ]

ui <- fluidPage(
    titlePanel("Segurança em Curitiba - Parte 2"),


    mainPanel(
       plotlyOutput("barBairros"),
       plotlyOutput("barOrigChamados")
    )

)

server <- function(input, output) {

    output$barBairros <- renderPlotly({
        plot_ly(porBairro, x = porBairro[, 1], y = row.names(porBairro))%>%
            layout(title = 'Número de ocorrências por bairro')
    })
    
    output$pieOrigChamados <- renderPlotly({
        plot_ly(origChamado, labels = ~Var1, values = ~Freq, type = 'pie')
    })
    
    output$barOrigChamados <- renderPlotly({
        plot_ly(origChamado, y = ~Var1, x = ~Freq)
    })
    
}

shinyApp(ui = ui, server = server)
