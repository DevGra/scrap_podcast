library(tidyverse)  
library(rvest)    
library(stringr)
library(downloader)
library(httr)

url <- "https://www.podbean.com/podcast-detail/pb-wkssp-21a086/Pizza+de+Dados"
setwd('C:/Users/cgt/Documents/carlos/SCRAP/scrap_podcast/')
dir_current <- getwd()

# pagination <- read_html(url)
# pg <- pagination %>%
#   html_nodes()

html <- read_html(url) 

# ---- PAGINAÇAO ------------------------
pages <- html %>%
  html_nodes('.pagination') %>%
  html_nodes('li')

# retorna 5 links(anterior, pg 1, pg2, pg3, proxima) o primeiro e o último link são excluidos
# -------------------------------------

i <- 2 # excluo o primeiro link
while (i < length(pages)) { # excluo o segundo link
  print(pages[i])
  link_pg <- pages[i] %>% 
    html_node('a') %>% 
    html_attr('href')
  link <- paste0("https://www.podbean.com", link_pg)  # /podcast-detail/pb-wkssp-21a086/Pizza+de+Dados/ no primeiro loop
  
  pg_down <- read_html(link)
  
  title <-  pg_down %>%
    html_nodes('.items') %>%
    html_nodes('tr') %>%
    html_nodes('td') %>% 
    html_nodes('a') %>% 
    html_text() 
    
  title <- title[seq(from = 1, to = length(title), by = 3)] # para pegar apenas os links

  links <-  pg_down %>%
    html_nodes('.items') %>%
    html_nodes('tr') %>%
    html_nodes('td') %>% 
    html_nodes('.download') %>% 
    html_attr('href')
  
  if (length(links) == length(title)) {
    # seq_along(links) - tentar usar
    for (l in 1:length(links)) {
      
      pg <- read_html(links[l])
      link <- pg %>% 
        html_nodes(".btn-group") %>% 
        html_node("a") %>% 
        html_attr("href")
      title <- str_replace(title[l], ":", " -")
      exten_file <- str_sub(link[l], -4)
      #download.file(link, dest = sprintf("%s",paste(dir_current, "down", paste0(title, exten_file), sep = '/')) , mode = "wb")
      print(sprintf("%s",paste(dir_current, "down", paste0(title, exten_file), sep = '/')))
    }
  
  }else {
    print(" Não foram capturados todos os links")
  }
  
  i <- i + 1
}
  









#size_td <- length(pages_data)
  # posicao/sequencia que estão os links , depois da segunda posiçao, pega de 4 em 4
  #.[seq(from = 2, to = size_td, by = 4)] %>% 
  

i <- 1
while (i <= length(pages_data)) {
  texto <- pages_data[[i]] %>%
  html_nodes('a') %>%
  html_attr('title')
  i <- i + 1  
}




#--------- BACKUP -------
# pages_data <- html %>%
# html_nodes('.left-content') 
# 
# pages_data[[1]]
# length(pages_data)
# # conteudo
# i <- 1 
# while (i <= length(pages_data)) {
#   # oegando o texto do link
#   texto <- pages_data[[i]] %>%
#     html_nodes("a") %>%
#     html_text()
#   
#   # retitando apenas o atribute href dos links
#   links_scrap <- pages_data[[i]] %>%
#     html_nodes("a") %>%
#     html_attr("href") 
#   
#   url_link <- read_html(links_scrap)
#   link <- url_link %>%
#     html_nodes('.btn-group') %>%
#     html_node("a") %>%
#     html_attr("href")
#   #download.file(link, dest = sprintf("%s",paste(dir_current, texto, sep = '/')) , mode = "wb")
#   download.file(URLencode(link), sprintf("%s",paste(dir_current, texto, sep = '/')))
#   
#   print(link)
#   
#   i <- i + 1
#   print(texto)
# 
# }

  
  
  