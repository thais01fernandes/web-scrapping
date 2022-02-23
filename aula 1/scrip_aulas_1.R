install.packages("httr")
install.packages("jsonlite")

library(httr)
library(jsonlite)
library(tidyverse)


# AULA 1 

# raspando informações de um CPF


cep <- "35702453"

u_base <- "https://brasilapi.com.br/api"
endpoint_cep <- "/cep/v2/" 

u_cep <- paste0(u_base, endpoint_cep, cep)
r_cep <- GET(u_cep)
r_cep


# diferentes formas de pegar o resultado: 

content(r_cep) # retorna o conteúdo em lista
content(r_cep, as = "text") # retorna uma string com arquivo JSON 
content(r_cep, as = "raw")  # retorna o arquivo no formato bruto, pouco utilizado
content(r_cep, as = "parsed") # é o padrão da função content 

# guardando na memória ram (Depois voltar no 1:45, não entendi essa parte)

r_cep <- GET(u_cep, write_disk("output/cep.json"))
read_json("output/cep.json") # lendo no R o arquivo guardado

fromJSON(content(r_cep, as = "text"))

# raspando informações da tabela FIP 


endpoint_fipe_tabelas <- "/fipe/tabelas/v1"
u_fipe_tabelas <- paste0(u_base, endpoint_fipe_tabelas)
r_fipe_tabelas <- GET(u_fipe_tabelas)

content(r_fipe_tabelas, simplifyDataFrame = TRUE) %>% 
  tibble::as_tibble()

#library(magrittr)

content(r_fipe_tabelas, simplifyDataFrame = TRUE) |>
  tibble::as_tibble()

# equivale a  # porém esse código não funcionou
r_fipe_tabelas %>% 
  content(as = "text") %>% 
  fromJSON(simplifyDataFrame = TRUE) %>% 
  tibble::as_tibble() 

## 

endpoint_fipe <- "/fipe/marcas/v1/"
tipo_veiculo <- "carros"
u_fipe <- paste0(u_base, endpoint_fipe, tipo_veiculo)
r_fipe <- GET(u_fipe)

content(r_fipe, simplifyDataFrame = TRUE)

tab_referencia <- "270"

r_fipe_270 <- GET(
  u_fipe,
  query = list(tabela_referencia = tab_referencia,
               outro = 3)
)

r_fipe_270

content(r_fipe_270, simplifyDataFrame = TRUE)


# consultar tabela fipe de carros -----------------------------------------

## infelizmente ainda não dá para pegar a lista de carros pela Brasil API
## https://github.com/BrasilAPI/BrasilAPI/issues/373

## Mas nós podemos pegar aqui: https://www.tabelafipebrasil.com/fipe/carros
## (depois podemos fazer isso via web scraping!)

endpoint_preco <- "/fipe/preco/v1/"
cod_veiculo <- "060006-7"
u_preco <- paste0(u_base, endpoint_preco, cod_veiculo)

r_preco <- GET(u_preco)
content(r_preco, simplifyDataFrame = TRUE)


r_preco <- GET(u_preco, query = list(tabela_referencia = tab_referencia))
content(r_preco, simplifyDataFrame = TRUE)

baixa_preco_tab_referencia <- function(cod_veiculo, tab_referencia) {
  endpoint_preco <- "/fipe/preco/v1/"
  u_preco <- paste0(u_base, endpoint_preco, cod_veiculo)
  r_preco <- GET(u_preco, query = list(tabela_referencia = tab_referencia))
  content(r_preco, simplifyDataFrame = TRUE)
}


tabelas <- 270:273

purrr::map_dfr(tabelas, ~baixa_preco_tab_referencia("060006-7", .x))

baixa_preco_tab_referencia("060006-7", "270")

## Exemplos de aula 2 -----------------------------------------

u_base_sabesp <- "https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
data_consulta <- "2022-02-09"
data_consulta2 <- "2022-02-10"
u_sabesp <- paste0(u_base_sabesp, data_consulta)
r_sabesp <- httr::GET(u_sabesp, httr::config(ssl_verifypeer = FALSE))

httr::httr_options() |> View()

tabela <- r_sabesp |>
  httr::content(simplifyDataFrame = TRUE) |>
  purrr::pluck("ReturnObj", "sistemas")

# TODO: transformar isso numa função
u_sabesp2 <- paste0(u_base_sabesp, data_consulta2)
r_sabesp2 <- httr::GET(u_sabesp2, httr::config(ssl_verifypeer = FALSE))

tabela2 <- r_sabesp2 |>
  httr::content(simplifyDataFrame = TRUE) |>
  purrr::pluck("ReturnObj", "sistemas")


lista <- list(
  nome = "julio",
  endereco = list(
    rua = "dos bobos",
    numero = "zero"
  )
)

lista$endereco$numero

lista |>
  purrr::pluck("endereco", "numero")



