procesamiento <- function(dir){
  
  # Extrarer los archivos
  my_files <- list.files(dir, pattern = ".csv$")
  
  # Lista de datos
  databases <- list()
  
  for(i in 1:length(my_files)){
    
    file <- my_files[i]
    
    data <- read_csv(paste0(dir, file))
    
    data <- data %>% 
      mutate(title = str_to_lower(title),
             title = iconv(title, to='ASCII//TRANSLIT'),
             title = str_replace_all(title, ":|;|,|\\.|\"",""))
    
    data <- data %>%
      mutate(mes = lubridate::month(mdy(date_added), label = TRUE),
             annio = year(mdy(date_added)),
             fecha_acotada = paste0(mes, ", ", annio))
    
    data <- data %>% 
      mutate(show_id = str_replace_all(show_id, "s", ""))
    
    databases[[i]] <- data
  }
  
  #dataset colection
  
  data_master <- do.call(bind_rows, databases)
  
  data_master_wide <- data_master %>% 
    select(title, type, source) %>% 
    unique() %>% # Agregar
    pivot_wider(names_from = source, 
                values_from = source)
  
  data_master_long <- data_master_wide %>% 
    pivot_longer(cols = 3:5,
                 names_to = "variable_procedencia",
                 values_to = "source") %>% 
    select(-variable_procedencia) %>% 
    na.omit()  
  
  return(list("data_master" = data_master, 
              "data_master_wide" = data_master_wide, 
              "data_master_long" = data_master_long))
}
