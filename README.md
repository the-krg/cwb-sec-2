# cwb-sec-2
### Metodologia

Acessar o site dos dados abertos de Curitiba
https://www.curitiba.pr.gov.br/dadosabertos/busca/?grupo=12

Obter dados abertos da SigesGuarda
http://dadosabertos.c3sl.ufpr.br/curitiba/Sigesguarda/

Obter dicionário de dados
https://mid.curitiba.pr.gov.br/dadosabertos/Sigesguarda/2015-11-25_sigesguarda_-_Dicionario_de_Dados.xlsx

Remover linhas referentes aos anos de 2009 até 2014

Ler arquivo, encoding latin1
```R
ds <- read.csv('2019-11-01_sigesguarda_-_Base_de_Dados.csv', header = TRUE, sep = ";", encoding = "latin1")
```

Remover colunas desnecessárias para a análise
```R
ds <- within(ds, rm(
  OCORRENCIA_CODIGO, 
  SERVICO_NOME,
  SITUACAO_EQUIPE_DESCRICAO,
  NUMERO_PROTOCOLO_156,
  SECRETARIA_SIGLA,
  SECRETARIA_NOME,
  REGIONAL_FATO_NOME,
  OPERACAO_DESCRICAO,
  NATUREZA1_DEFESA_CIVIL,
  NATUREZA2_DEFESA_CIVIL,
  NATUREZA3_DEFESA_CIVIL,
  NATUREZA4_DEFESA_CIVIL,
  NATUREZA5_DEFESA_CIVIL,
  FLAG_EQUIPAMENTO_URBANO,
  FLAG_FLAGRANTE
  )
)
```


