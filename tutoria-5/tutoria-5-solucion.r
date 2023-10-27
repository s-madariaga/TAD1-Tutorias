
# Opciones del script
rm(list = ls())
options(scipen = 999)
# Sys.setlocale(category = "LC_ALL", locale = "hi-IN")

# Paquetes instalados requeridos
if(!require(here)){
  install.packages("here")
} # ¿Qué estoy haciendo aquí?

if(!require(knitr)){
  install.packages("knitr")
} # ¿Qué estoy haciendo aquí?

# Librerías

if(!require(pacman)){
  install.packages("pacman")
}

pacman::p_load(readr, 
                dplyr,
                tidyr,
                stringr,
               lubridate,
                data.table)

# library(readr)
# library(dplyr)
# library(tidyr)
# library(stringr)
# library(data.table)

# Importemos nuestra base de datos

titanic <- read_csv("https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv")
head(titanic)

# 1. Limpiar y correcto formato -------------------------------------------


# 1.1. Verificar siempre la clase de los datos ----------------------------

glimpse(titanic)

sapply(titanic, class)

# Suòngamos:
titanic <- titanic %>% 
  mutate(Survived = as.character(Survived))

glimpse(titanic)

# Corregir siempre
titanic <- titanic %>% 
  mutate(Survived = as.numeric(Survived))

glimpse(titanic)

# 1.2. Algunas funciones de texto importante ------------------------------

# Limpiar los nombres de la base de datos

# str_to_lower
c("Manzana", "Naranja", "Plátano", "Palta") %>% str_to_lower

# str_to_upper
c("Manzana", "Naranja", "Plátano", "Palta") %>% str_to_upper

# str_replace_all
c("Manzana", "Naranja", "Plátano", "Palta") %>% str_replace_all("a", "4")
c("ManzanaP", "Naranja", "Plátano", "Palta") %>% str_replace_all("^P", "")
c("ManzanaP", "Naranja", "Plátano", "Palta") %>% str_replace_all("a$", "")

# str_detect: frutas que terminan con a
c("Manzana", "Naranja", "Plátano", "Palta") %>% str_detect("a$")

#' Recomendación: estudiar expresiones regulares en https://cran.r-project.org/web/packages/stringr/vignettes/regular-expressions.html
#' no relevante para el curso, pero si para su formación en R

# Unir dos valores ~~~~~~~~~~~~~~~~~~~~

paste0("El número", 1:3*2, "es par")
paste("El número", 1:3*2, "es par")

# Función paste
titanic %>% 
  mutate(id_age= paste0(PassengerId,"_",Age)) %>% 
  select(PassengerId, Age, id_age) %>% 
  head()

# Función unite
titanic %>% 
  unite(id_age, PassengerId, Age, sep = "_", remove = FALSE) %>% 
  select(PassengerId, Age, id_age) %>% 
  head()

# Para "guardar los cambios", suscriba la base de datos o genere una nueva.



# 2. Uniones de tablas de datos -------------------------------------------

## Uniones por filas

data_1 <- tribble(
  ~"id", ~"anio", ~"edad",
  1, 2000, 25,
  1, 2001, 26,
  1, 2002, 27
)

data_2 <- tribble(
  ~"id", ~"anio", ~"edad",
  2, 2000, 44,
  2, 2001, 45,
  2, 2002, 46
)

# ¿Cuál es la mejor union para estos datos?
data_master <- bind_rows(data_1, data_2) ## S.
data_master

## Uniones por columna

data_3 <- tribble(
  ~"id", ~"anio", ~"edad",
  # 1, 2000, 25,
  1, 2001, 26,
  1, 2002, 27,
  2, 2000, 44,
  2, 2001, 45,
  # 2, 2002, 46
)

data_4 <- tribble(
  ~"id", ~"anio", ~"edad",
  1, 2000, 25,
  # 1, 2001, 26,
  1, 2002, 27,
  2, 2000, 44,
  # 2, 2001, 45,
  2, 2002, 46
)


# ¿Cuál es la mejor union para estos datos?
data_master <- full_join(data_3, data_4, by = c("id", "anio", "edad")) # S
data_master

# 3. Pivotear tablas de datos ---------------------------------------------

data_master <- bind_rows(data_1, data_2)

# Wide: transforme esta base de datos a wide
data_wide <- data_master %>%  # S
  pivot_wider(names_from = anio,
              values_from = edad)

data_wide

# Long: transforme esta base dedatos a long
data_long <- data_wide %>%  ## S
  pivot_longer(cols = 2:4,
               names_to = "anio",
               values_to = "edad")

data_long


# 4. Repaso programación funcional ----------------------------------------

# Programación fucional: programación orientada a funciones

# Bucles for

#' (Borrar) Reforzar idea base: el bucle for recorre los elementos
#' Aplica un bloque de código a cada elemeneto (de forma eterada)
#' Sea i ese elemento (o cualquier otro índice)

colores = c("Rojo", "Azul", "Amarillo")

for(color in colores){
  print(paste("El color", color, "es primario"))
}

# Cualquier objeto de la estructura de datos, el bucle lo itera

# Trabajaremos con esta base de datos
iris_filtrado <- iris %>% select(-Species)

# Vemos variable por variable si la distribución es normal
for (variable in names(iris_filtrado)) {
  resultado_prueba <- shapiro.test(iris_filtrado[[variable]])
  p_valor <- resultado_prueba$p.value
  if (p_valor < 0.05) {
    print(paste("La variable", variable, "no sigue una distribución normal."))
  } else {
    print(paste("La variable", variable, "sigue una distribución normal."))
  }
}

# Veamos los histogramas!
par(mfrow = c(3, 2))
for (variable in names(iris_filtrado)) {
  hist(iris_filtrado[[variable]], main = "", xlab = variable)
}

dev.off()


## Propuesto: ¿Se puede realizar este código de otra manera la referencia
## a las variables?

## RESPUESTA: con Sapply

## Sapply

funcion_sapply <- function(x){
  resultado_prueba <- shapiro.test(x)
  p_valor <- resultado_prueba$p.value
  if (p_valor < 0.05) {
    paste("no es normal")
  } else {
    paste("es normal")
  }
}

## Bases de datos (sapply)
iris_filtrado %>% 
  sapply(funcion_sapply)

iris_filtrado %>%  ## AA
  sapply(function(x){
    resultado_prueba <- shapiro.test(x)
    p_valor <- resultado_prueba$p.value
    return(!p_valor < 0.05)
})

## Modifica cada elemento de la estructura: ejemplo de reescalación
iris_filtrado %>% 
  sapply(function(x){x*10})

## Lapply: para las listas
data_5 <- sample_n(iris_filtrado, size = 10)
data_6 <- sample_n(iris_filtrado, size = 10)

# Acumulamos todas las bases en una lista
lista_bases <- list(data_5, data_6)

# A cada una de las bases de datos
lista_bases_procesada <- lista_bases %>% 
  lapply(
    function(x){
      
      # Ponemos los nombres en minuscula
      colnames(x) <- str_to_lower(colnames(x))
      
      # ¿Puedo añadir otro proceso en el bloque? EJ: Reescalar con 10
      x <- x %>% mutate_all(function(x){x * 10}) ## A
      
      # y otros ajustes
      return(x)
    }
  )

# Observemos:
lista_bases_procesada

# Unimos las bases de datos:
do.call(bind_rows, lista_bases_procesada)

data_unida <- bind_rows(lista_bases_procesada)

data_unida %>% class

# 5. Manejo de directorios y documentos -----------------------------------

# Archivos del directorio
getwd()

dir()
dir("Input")

here::here()
dir(here::here())

dir.create("Output")
file.edit("nuevo_script.r") # Ojo con la extensión
file.edit("script.existente.r") # Mostrar el directorio


list.files()
list.files("Input")

# Ejemplo: ¿cuál esel error?
list.files("Input/")
file.edit("Input/distractor.csv.txt")
list.files("Input/", pattern = ".csv")

# Es necesario distinguir:
list.files("Input/", pattern = ".csv$")



##########################################################################.
# Ejercicio final ---------------------------------------------------------
##########################################################################.

#' A continuación, usted trabajará con 4 bases de datos, aplicando
#' programación funcional.
#' 
#' amazon_prime_titles.csv
#' disney_plus_titles.csv
#' hulu_titles.csv
#' netflix_titles.csv
#' 
#' Las cuatro cuentan con las mismas variables:
#' 
#' • show_id      : identificador por show (no coincide entre las bases).
#' • type         : tipo de audiovisual: TV Show o Movie.
#' • title        : título del audiovisual.
#' • director     : director del audiovisual.
#' • cast         : reparto del audiovisual.
#' • country      : país de filmación.
#' • date_added   : día añaddo a la plataforma.
#' • release_year : año de realización.
#' • rating       : calificación del audiovisual.
#' • duration     : duración del audiovisual.
#' • listed_in    : categorías en las que ha sido catalogada.
#' • description  : reseña del audiovisual.
#' • source       : a qué plataforma pertenecen: Netflix, Amazon prime, Hulu, Disney +-
#' 
#' El cliente busca tener una base de datos compacta en la que pueda
#' buscar sus películas favoritas en la plataforma en la que estén disponible.
#' Considerando que aun faltan serviios de streaming a añadir
#' Automatice un proceso en la que procese y una estas tablas de datos, 
#' para que el cliente pueda observar todas sus opciones. incluso
#' para tiempos venideros.

# Ejercicios --------------------------------------------------------------

# Ejercicio a -------------------------------------------------------------

#' Proponga un método para unir las bases de datos.

# Generamos una lista que va a contener las bases de datos
databases <- list()

# Contemplamos nuestras bases de datos
my_files <- list.files("Input/", pattern = ".csv$")

for(database in my_files){
  databases[[database]] <- fread(paste0("Input/",database)) # Fread es para importación optimizada
}

# Unir las bases de datos
data_master <- do.call(bind_rows, databases)
data_master <- bind_rows(databases) ## A: es otra forma


# Ejercicio b. ------------------------------------------------------------

#' En muchas plataformas se deben repetir las mismas películas
#' pero es probable que el título se escriba diferente.
#' En ausencia de cualqueir identificador o etiquieta única del
#' producto, debe uniformar el título de las películas.
#' 
#' Al proceso anterior,
#' Proponga un procesamiento para Para uniformar el nombre de 
#' las películas transformando en minúculas y elimine cualquier signo
#' de puntuación, tilde y carácter extraño.

##~~ Proceso individual ~~~~~~~~~~~~~

netflix <- fread("Input/netflix_titles.csv")

netflix <- netflix %>% 
  mutate(title = str_to_lower(title),
         title = iconv(title, to='ASCII//TRANSLIT'),
         title = str_replace_all(title, ":|;|,|\\.|\"",""))

##~~ Proceso global ~~~~~~~~~~~~~~~~~

# Generamos una lista que va a contener las bases de datos
databases <- list()

# Contemplamos nuestras bases de datos
my_files <- list.files("Input/", pattern = ".csv$")

for(database in my_files){
  data <- read_csv(paste0("Input/",database))
  
  data <- data %>% 
  mutate(title = str_to_lower(title),
         title = iconv(title, to='ASCII//TRANSLIT'),
         title = str_replace_all(title, ":|;|,|\\.|\"",""))
  
  databases[[database]] <- data
}

databases

## Comprobemos nuestros datos
data_master <- bind_rows(databases)
View(data_master)

#' Ejercicio c. Al proceso anterior añada:
#' genere una variable "fecha_acotada" que sea:
#' mes, año de la variable "date_added"

##~~ Proceso individual ~~~~~~~~~~~~~
netflix <- netflix %>%
  mutate(mes = lubridate::month(mdy(date_added), label = TRUE),
         annio = year(mdy(date_added)),
         fecha_acotada = paste0(mes, ", ", annio))

# Comprobamos nuestros resultados:
netflix %>% 
  select(mes, annio, fecha_acotada) %>%
  head() %>% 
  knitr::kable()

##~~ Proceso global ~~~~~~~~~~~~~
for(database in my_files){
  data <- read_csv(paste0("Input/",database))
  
  data <- data %>% 
  mutate(title = str_to_lower(title),
         title = iconv(title, to='ASCII//TRANSLIT'),
         title = str_replace_all(title, ":|;|,|\\.|\"",""))
  
  data <- data %>%
    mutate(mes = lubridate::month(mdy(date_added), label = TRUE),
           annio = year(mdy(date_added)),
           fecha_acotada = paste0(mes, ", ", annio))
  
  databases[[database]] <- data
}

databases

#' Ejercicio d. Al proceso anterior, añada:
#' Elimine la "s" del identificador (show_id) y sustituya
#' por un identificador único cada película, aunque se repita!

##~~ Proceso individual ~~~~~~~~~~~~~
netflix <- netflix %>% 
  mutate(show_id = str_replace_all(show_id, "^s", ""))

##~~ Proceso global ~~~~~~~~~~~~~
for(database in my_files){
  data <- read_csv(paste0("Input/",database))
  
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
  
  databases[[database]] <- data
}

data_master <- bind_rows(databases)

#' Ejercicio e. Con la base de datos ya unida,
#' Convierta a Wider (database)

data_master_wide <- data_master %>% 
  select(title, type, source) %>% 
  unique() %>% # Agregar
  pivot_wider(names_from = source, 
              values_from = source)

data_master_wide %>% View

## Ejercicio f. Unida la base de datos, convierta a data longer

data_master_long <- data_master_wide %>% 
  pivot_longer(cols = 3:5,
               names_to = "variable_procedencia",
               values_to = "source") %>% 
  select(-variable_procedencia) %>% 
  na.omit()

## Ejercicio g. Proceso automatizado

# Empaquetamos todos los pasos anteriores en una función
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

mi_lista_final <- procesamiento(dir = "Input/")

mi_lista_final %>% class

# Función corregida:
file.edit("Intput/automatizacion_correcta.r")


#################################################################################.
## Propuesto ----------------------------------------------------------------------
#################################################################################.

##' PROPUESTO: haga el mismo ejercicio, pero aplicando lapply y siguiendo el ejemplo
##' del script que se presenta en la sección de lapply (líneas 237-260) y siguiendo
##' el ejercicio (a) de este Ejercicio final.

procesamiento_prop <- function(dir) {
  
  # Extraer los archivos
  my_files <- list.files(dir, pattern = ".csv$")
  
  databases <- list()
  
  # Importamos todas las bases de datos
  for (i in my_files) {
    databases[[i]] <- fread(paste0("Input/", i))
  }
  
  databases <- lapply(databases, function(data) {
    data <- data %>%
      mutate(title = str_to_lower(title),
             title = iconv(title, to = "ASCII//TRANSLIT"),
             title = str_replace_all(title, ":|;|,|\\.|\"",""),
             mes = lubridate::month(mdy(date_added), label = TRUE),
             annio = year(mdy(date_added)),
             fecha_acotada = paste0(mes, ", ", annio),
             show_id = str_replace_all(show_id, "s", ""))
    return(data)
  }) 
  
  data_master <- bind_rows(databases)
  
  data_master_wide <- data_master %>% 
    select(title, type, source) %>% unique() %>% 
    pivot_wider(names_from = source, values_from = source)
  
  data_master_long <- data_master_wide %>% 
    pivot_longer(cols = 3:5, names_to = "variable_procedencia", values_to = "source") %>% 
    select(-variable_procedencia) %>% 
    na.omit()
  
  return(list("data_master" = data_master, 
              "data_master_wide" = data_master_wide, 
              "data_master_long" = data_master_long))
}

mi_lista_final <- procesamiento_prop(dir = "Input/")

## Notas aparte:

# Cómo recorrer mi directorio
for (i in my_files){
  read_csv(paste0(here::here(),"/Input/",i))
}





