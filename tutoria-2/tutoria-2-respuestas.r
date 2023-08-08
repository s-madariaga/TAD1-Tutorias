
########################.
## Tutoría 2: Tarea 2 ##
########################.

# Encabezado
rm(list = ls())
options(scipen = 999)

# Paquetes
library(tidyverse) # Incluye los paquetes dplyr y ggplot
library(haven)
library(readxl)
library(lubridate)
library(vtable)
library(knitr)


############################################################################.
# 1. Proyectos en R -------------------------------------------------------

## Idea: en Rstudio, lo primero (correcto) es crear un proyecto.

# Dos opciones:
# 1) Todavía no has creado una carpeta: crear una carpeta y crea el archivo de proyecto.
# 2) Ya existe una carpeta en donde tienes tus archivos: Crea el archivo de proyecto


## Conceptos importantes:

## Path: dirección de mi carpeta
path <- "C:/Users/Sofía/Descargas/mi_carpeta" # Dirección de la carpeta de descargas

## Directorio: carpeta en donde desemboca mi path
getwd()

## Proyecto: es el entonro de trabajo de mi archivo de proyecto.


############################################################################.
# 2. Importación y exportación de data.frames -----------------------------

## Importamos la base de datos
netflix <- read_sav("C:/Users/Sofía/Descargas/input/Netflix_movies_and_TV_Shows_database.sav") # Pregunta: ¿es correcto usar este path?


# Forma correcta cuando se trabaja con proyectos:
netflix <- read_sav("input/Netflix_movies_and_TV_Shows_database.sav")

ens <- read_excel("input/ENS.xlsx")


## Recomendaciones:

## Use una carpeta para guardar las bases de datos
## Rstudio tiene las herramientas para asegurar una importación correcta


############################################################################.
# 3. Funciones para la exploración inicial --------------------------------

## Use el operador "$"
netflix$show_id

## head primeros n = 5 datos
head(netflix)
?head
head(netflix, n = 10)


## tail
tail(netflix)


## str/glimpse/vtable
str(netflix)
glimpse(netflix)
vtable(netflix)


##########################.
##* Resumen de casos perdidos

## 1) Una sola variables
sum(is.na(netflix$show_id))

## 2) Todas las variables
netflix %>% 
  sapply(mi_function) ## Para usar esta variable debo aplicar una función, pero ¿qué función?

netflix %>% 
  summarise_all(function(x){sum(is.na(x))})


# 4. Manejo de fechas con lubridate ---------------------------------------

## Observemos las variables de tiempo de esta base de datos
glimpse(netflix)
netflix %>% select(date_added, release_year)


## Creamos fechas con sus nuevos formatos
netflix$fecha_1 <- mdy(netflix$date_added)
netflix$fecha_2 <- make_date(netflix$release_year, month = 1, day = 1)


## ¿Cómo extraigo años, meses y días?
year(netflix$fecha_1)
month(netflix$fecha_1)
day(netflix$fecha_1)

## Difftime

## Para ello, usaremos una base de datos nueva


difftime(netflix$fecha_1, netflix$fecha_2)
?difftime
difftime(netflix$fecha_1, netflix$fecha_2, units = "weeks")


# Eliminemos esas variables
netflix_subset <- netflix %>% select(-c(fecha_1, fecha_2))


# 5. dplyr ----------------------------------------------------------------

############################.
## select ------------------
glimpse(netflix)

## 1) Selección positiva
netflix %>% 
  select(1:4)

netflix %>% 
  select(type, title, director, date_added, release_year, listed_in, duration)

## 2) Selección negativa (-variable)
netflix %>% 
  select(-1)

netflix %>% 
  select(-c(show_id, cast, rating, duration))



############################.
## filter ------------------

## Use la base de datos de Netflix: filtre solo las películas
netflix %>% filter(type == "Movie")


## Para un filtro más sofisticado usar:
## - "|" para la unión (se cumple la característica 1 ó se cumple la característica 2).
## - "&" para la intersección (esto y esto)

## Películas que fueron rodadas sobre los 2000s
netflix %>% filter(type == "Movie" & release_year >= 2000)

## Use la base de datos de Netflix:
## filtre los productos que estén listados como "Crime" o que tengan clasificación R (restringido)
netflix %>% filter(listed_in == "Crime" | rating == "R")



############################.
## mutate ------------------

### Modificar variable existente y añadir variables nuevas

## Modifique las variable date_added y extraiga solo su año,
## luego convierta en un formato de fecha la variable release_year
netflix <- netflix %>% 
  mutate(date_added_year = year(mdy(date_added)),
         full_date_release = make_date(release_year))

## Construya un identificador de casos.
netflix %>% 
  mutate(id = 1:nrow(.)) %>% 
  select(id)# ¿Hay una mejor manera de generar esta variable?


## Probemos una transformación más compleja
## Use la base de datos de la ENS: calcule el IMC a partir del peso y la altura

## IMC = PESO^2/ALTURA (cm)
ens <- ens %>% 
  mutate(imc = Peso/(Talla/100)**2)


############################.
## arrange ----------------

## Haga un ranking por año
netflix %>% 
  select(title, release_year) %>% 
  arrange(desc(release_year)) ## ¿Cómo puedo hacer para que salgna las más nuevas?




############################.
## case_when ---------------

## Use la base de datos de la ENS: genere categorías de edad con la base de datos de salud
ens <- ens %>% 
  mutate(categoria_edad = case_when(Edad < 25 ~ 1,
                                    Edad < 45 ~ 2,
                                    Edad < 65 ~ 3,
                                    Edad >= 65 ~ 4),
         categoria_edad = factor(categoria_edad, levels = c(1,2,3,4),
                                 labels = c("15 a 24 años", "25 a 44 años", "45 a 64 años", "65 años o más")))



## Ejemplo con categorías
netflix %>% 
  mutate(categoria_resumida = case_when(listed_in %in% c("Documentaries", "Docuseries", "Drama", "Comedy", "Action") ~ 1,
                                        listed_in %in% c("Thriller", "Sci-Fi", "Crime", "Horror") ~ 2)) %>% 
  select(categoria_resumida, listed_in)

## ¿Por qué usar "factor"? Me permite seguir un orden:
ens %>% 
  select(Edad, categoria_edad) %>% 
  arrange(categoria_edad)



############################.
## group_by y summarise ----

## Use la base de datos de Netflix: agrupe por año de realización y por tipo.
## Cuente cuantas series y películas hay por año.
netflix %>%  
  group_by(release_year, type) %>% 
  summarise(conteo_agrupacion = n())

netflix %>% 
  filter(release_year %in% c(2020, 2021)) %>% 
  group_by(type, release_year) %>% 
  summarise(conteo_agrupacion = n())

# Parece una tabla muy grande. Puedo añadir un filtro. ¿Qué pasa si no pongo bien el > o >=?



############################################################################.
## 5.1. Tablas de resumen con dplyr ----------------------------------------

## Con dplyr

## Nota: es importante que reporte su tabla como corresponde.
## Indique el título de la tabla con la enumeración correspondiente.
## Indique la fuente de dónde provienen los datos.


## Ejercicio 1:
## Cuántas películas han sido añadidas por netflix los años 2020, 2021 y 2022 y 
# clasifique entre películas y series.
## Incluya el porcentaje.
netflix %>%
  filter(release_year %in% c(2020, 2021, 2022)) %>% 
  group_by(release_year, type) %>% 
  summarise(n = n()) %>% 
  mutate("%" = n/sum(n)) ## ¿Cómo puedo hacer que sea un porcentaje? ¿Cómo puedo mejorar esta tabla?

netflix %>% 
  filter(release_year >= 2020) %>% 
  group_by(release_year, type) %>% 
  summarise(n = n()) %>% 
  mutate(porcentaje = paste0(round(n*100/sum(n), 2), "%"))


## Ejercicio 2:
## Cálcule el promedio de cigarros por rango etario que fuman personas hipertensas
## Organice por por sexo
## Solo incluya los rangos etarios 25-44, 45-65 y  65 o más.
ens %>% 
  filter(categoria_edad %in% c("25 a 44 años", "45 a 64 años", "65 años o más")) %>% 
  filter(presión_PAD > 80 & presión_PAS > 140) %>% 
  mutate(Sexo = factor(Sexo, levels = c(1, 2), labels = c("Hombre", "Mujer"))) %>% 
  group_by(Sexo, categoria_edad) %>% 
  summarise(promedio_cigarrillos = mean(`n°_cigarrillos`, na.rm = TRUE))

ens %>% 
  mutate(Sexo = factor(Sexo, levels = c(1, 2), labels = c("Hombre", "Mujer"))) %>% 
  filter(presión_PAD > 80 & presión_PAS > 140) %>% 
  filter(categoria_edad %in% c("25 a 44 años", "45 a 64 años", "65 años o más")) %>% 
  group_by(Sexo, categoria_edad) %>% 
  summarise(promedio_cigarrillos = mean(`n°_cigarrillos`, na.rm = TRUE))


## ¿Y si quiero contar a las personas hipertensas? (propuesto)

ens %>% 
  mutate(Sexo = factor(Sexo, levels = c(1, 2), labels = c("Hombre", "Mujer"))) %>% 
  filter(presión_PAD > 80 & presión_PAS > 140) %>% 
  filter(categoria_edad %in% c("25 a 44 años", "45 a 64 años", "65 años o más")) %>% 
  group_by(Sexo, categoria_edad) %>% 
  summarise(n = n())


# 6. Funciones en R -------------------------------------------------------

## Declarar una función

# nombre <- function(inputs, ...){
#   bloque_de_cóoigo
#   resultado <- código
#   return(resultado)
# }

## Haga una función llamada suma, que sume dos números a y b

suma <- function(a, b){
  a + b
}


suma(a = 1, b = 2)

## Haga una función que dé el área de un círculo

area_circulo <- function(radio){
  area <- pi*radio**2
  return(area)
}

## Para evaluar missing values
## NAs mutate_if(is.character, function(x) {ifelse(x == "", NA,x)}) -- Propuesto

cuenta_perdidos <- function(vector){sum(is.na(vector))}

cuenta_perdidos(ens$`n°_cigarrillos`)

ens %>% 
  summarise_all(cuenta_perdidos)

## 6.1. Bucles ------------------------------------------------------------


## Bucle for

## Implementación básica
for(i in 1:5){
  print("Repetición")
}


## El k (índice), solo aparecerá en la iteración si lo indico.
for(k in c("Elemento 1", "Elemento 2", "Elemento 3")){
  print("Mensaje repetido")
}

## Colores primarios
colores <- c("Rojo", "Amarillo", "Azul")

for(color in colores){
  print(paste("El", color, "es un color primario"))
}

## Ejercicio final:

## Haga una función llamada "mis_muesrtas", que saque m muestras de n elementos de una variable

mis_muestras <- function(variable, n, m){
  muestras <- list()
  for(i in 1:m){
    muestras[[i]] <- sample(variable, size = n)
  }
  print(muestras)
}

mis_muestras(variable = ens$imc, n = 100, m = 10)

# 7. Cierre ---------------------------------------------------------------

## Peqeños tips:
## 1) Use pipe operator %>% o |>.
## 2) Trabaje en proyectos y use el debido directorio.
## 3) Reporte sus tablas con el formato académico (no imágenes).


