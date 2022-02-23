library(tidyselect)
library(httr)

u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"
endpoint <- "/Posicao"

u_sptrans_busca <- paste0(u_sptrans, endpoint)
r_sptrans <- GET(u_sptrans_busca)
content(r_sptrans)

api_key <- "4af5e3112da870ac5708c48b7a237b30206806f296e1d302e4cb611660e2e03f"
