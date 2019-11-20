library(shiny)
library(plotly)

ds <- read.csv('2019-11-01_sigesguarda_-_Base_de_Dados.csv', header = TRUE, sep = ";", encoding = "latin1")
porBairro <- as.data.frame(summary(ds$ATENDIMENTO_BAIRRO_NOME))
origChamado <- as.data.frame(table(ds$ORIGEM_CHAMADO_DESCRICAO))
origChamado <- origChamado[order(origChamado[2], decreasing = TRUE), ]
meses <- c('JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ')

# linhas: [2015]
n2015 <- as.data.frame(table(ds[ds$OCORRENCIA_ANO == 2015, "OCORRENCIA_MES"]))
n2016 <- as.data.frame(table(ds[ds$OCORRENCIA_ANO == 2016, "OCORRENCIA_MES"]))
n2017 <- as.data.frame(table(ds[ds$OCORRENCIA_ANO == 2017, "OCORRENCIA_MES"]))
n2018 <- as.data.frame(table(ds[ds$OCORRENCIA_ANO == 2018, "OCORRENCIA_MES"]))
n2019 <- as.data.frame(table(ds[ds$OCORRENCIA_ANO == 2019, "OCORRENCIA_MES"]))

# add 0 to remaining months
n2019 <- rbind(n2019, data.frame(Var1="11", Freq=NA))
n2019 <- rbind(n2019, data.frame(Var1="12", Freq=NA))

# dia
ocorrencia_por_dia <- as.data.frame(table(ds$OCORRENCIA_DIA_SEMANA))
    #adiciona total
total_ocorrencias <- sum(ocorrencia_por_dia[,2])

# renomeação de nomes do dataframe
colnames(n2015)[2] = 'Freq2015' 
colnames(n2016)[2] = 'Freq2016'
colnames(n2017)[2] = 'Freq2017'
colnames(n2018)[2] = 'Freq2018'
colnames(n2019)[2] = 'Freq2019'

# Junta-se os anos numa variável auxiliar para plotá-los todos juntos
aux <- merge(n2015,n2016)
aux <- merge(aux, n2017)
aux <- merge(aux, n2018)
aux <- merge(aux, n2019)

aux <- aux[order(aux$Var1),]

# Adiciona os meses ao data-frame
aux['MES'] <- as.data.frame(meses)

years <- as.data.frame(n2015)

ui <- fluidPage(
    titlePanel("Segurança em Curitiba - Parte 2 | Alunos: Enzo Vinicius Haguiwara e Daniel Machado Pintos"),

    mainPanel(
        h1("Número total de ocorrências registradas por bairro, desde 2015 até novembro de 2019"),
        h5("Dica: Clique, arraste e solte no gráfico para dar zoom em uma área."),
        h5("Clique duas vezes no gráfico para retirar o zoom."),
        plotlyOutput("barBairros"),
        h1("Percentual de chamados pela origem do chamado."),
        h5("Dica: Clique em uma das legendas para removê-la da visualização, assim pode-se analisar mais profundamente."),
        plotlyOutput("pieOrigChamados"),
        h1("Número de chamados registrados por mês, agrupado por ano, desde 2015 até novembro de 2019"),
        h5("Dica: Clique em uma das legendas para removê-la da visualização."),
        plotlyOutput("linePerYear", width = "100%", height = "600px"),
        h1("Número total decrescente de chamados registrados por dia da semana, desde 2015 até novembro de 2019"),
        plotlyOutput("barDias"),
        width = 12
    )

)

server <- function(input, output) {

    output$barBairros <- renderPlotly({
        plot_ly(porBairro, x = porBairro[, 1], y = row.names(porBairro))%>%
            layout(
                title = 'Número de ocorrências por bairro',
                yaxis = list(
                    categoryorder = "array", 
                    categoryarray = row.names(porBairro),
                    title = "Nome do Bairro"
                )
            )
    })
    
    output$barDias <- renderPlotly({
        plot_ly(porBairro, y = ocorrencia_por_dia[,2], x = ocorrencia_por_dia[,1])%>%
            layout(title = 'Número de ocorrências por dia',
                   xaxis = list(
                       categoryorder = "total descending", 
                       categoryarray = ocorrencia_por_dia[,2],
                       title = "Dia da semana"
                   ))
    })
    
    
    output$linePerYear <- renderPlotly({
        plot_ly(aux, x = ~MES, y = ~Freq2015, labels = meses, name='2015', width = 4, type='scatter', mode='lines')%>%
            add_trace(y = ~Freq2016, name = '2016', line = list(color = 'rgb(0, 0, 255)', width = 4)) %>%
            add_trace(y = ~Freq2017, name = '2017', line = list(color = 'rgb(255, 0, 0)', width = 4)) %>%
            add_trace(y = ~Freq2018, name = '2018', line = list(color = 'rgb(0, 255, 0)', width = 4)) %>%
            add_trace(y = ~Freq2019, name = '2019', line = list(color = 'rgb(255, 0, 255)', width = 4)) %>%
            layout(
                title = 'Número de Ocorrencias por mês a cada ano', 
                xaxis = list(
                    categoryorder = "array", 
                    categoryarray = aux$MES,
                    title = "Mês"
                    ),
                yaxis = list(title='Frequência')
            )
    })
    
    output$pieOrigChamados <- renderPlotly({
        plot_ly(origChamado, labels = ~Var1, values = ~Freq, type = 'pie')%>%
            layout(title = 'Origem dos chamados')
    })
}

shinyApp(ui = ui, server = server)
