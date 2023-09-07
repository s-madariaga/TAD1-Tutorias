
#############################################################.
## Tutoría 4: tidyr y esenciales de programación funcional ##
#############################################################.

## Presionar: "Ctrl + Shift + o" para ver un índice

# Setting
rm(list = ls())
options(scipen = 9999)

# Paquetes
pacman::p_load(tidyverse, janitor, knitr, kableExtra, Hmisc, vtable)


## ==========================================================================.
##
## Literatura Recomendada
##
## - Advanced R. Link: http://adv-r.had.co.nz/Functional-programming.html
## - Modern R with the tidyverse: Funcions. Link: https://modern-rstats.eu/functional-programming.html
##
## ==========================================================================.

# 01. Repaso tutoría anterior ---------------------------------------------


## Alternativa para importamos los datos: RData
## Vamos a importar un enviroment entero, con los objetos de esta tutoría.
## Esto puede ser muy útil para exportar objetos y funciones de otros proyectos
## Tabmién, para importar datos muy pesados.

## Por ejemplo, podemos improtar los objetos generados en este script:
file.edit("objetos.r")

# Importamos objetos:
rm(list = ls())
load("objetos_2.RData")

# Fin de la demostración. Eliminamos los objetos.
rm(list = ls())


# Etonces, aquí tenemos los objetos de nuestra tutoría 4:
load("enviroment.RData")


## 01.1. dplyr -------------------------------------------------------------

# mutate, mutate_all, mutate_at y mutate_if
glimpse(ENS)

ENS <- ENS %>% 
  clean_names() %>% 
  mutate(sexo = factor(sexo, level = c(1, 2), labels = c("Hombre", "Mujer"))) %>% 
  mutate_at(vars(depresion, diabetes, asma), ~factor(., level = c(1, 2), labels = c("Si", "No")))

glimpse(ENS)

# Siempre es conveniente tipificar nuestrasvariables
# Observa lo que sucede con esta conversión (coerción)

ENS %>% 
  mutate_all(as.numeric)

  
# summarise, sumarise_all, summarise_at, summarise_if
ENS %>% 
  summarise(promedio = mean(presion_pad, na.rm = TRUE),
            desviacion_estandar = sd(presion_pad, na.rm = TRUE),
            mediana = mean(presion_pad, na.rm = TRUE),
            mininimo = min(presion_pad, na.rm = TRUE),
            maximo = max(presion_pas, na.rm = TRUE)) 

## Ejemplo summarise_all: cantidad de casos peridods (%)
ENS %>% 
  summarise_all(~sum(is.na(.))/length(.))

## Pero me quedó "a lo ancho" (wide), ¿Cómo puedo arreglarlo?
## Esto lo solucionaremos en la sección de tidyr,


# Familia de funciones join
## Cuidado con el variable.x y variable.y

datos_1 <- data.frame(
  id = c(1, 2, 5),
  edad = c(25, 67, 44),
  sexo = c(1, 2, 1)
)

datos_2 <- data.frame(
    id = c(1, 3, 5, 6),
    edad = c(25, 15, 44, 67)
  )


## Qué va a pasar en cada uno de estos casos?

# Inner join
datos_1 %>% 
  inner_join(datos_2)

## Full join
datos_1 %>% full_join(datos_2, by = c("id", "edad"))

## Left/right join
datos_1 %>% left_join(datos_2)
datos_1 %>% right_join(datos_2)


## Antijoin ¿para qué puede usarse?. Ejemplo interesante: eliminar conectores

## Base de datos de palabras repetidas
opiniones

## Creamos una base de datos de conectores
conectores <- data.frame(
    palabra = c("de", "en", "la", "me", "a", "al")
  )


## Hacemos un antijoin
opiniones %>% 
  anti_join(conectores, by = "palabra")

## ¿Qué otros conectores podemos agregar?
## Existen bases de datos de conectores: "https://raw.githubusercontent.com/7PartidasDigital/AnaText/master/datos/diccionarios/vacias.txt"


## 01.2. tidyr -------------------------------------------------------------

# Pivotar una tabla

# Elscoc

## Revise elsoc: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/QZEDUC

## A continuación, se presenta un estracto de las bases de datos de elsoc
## Cada una de ellas presenta la variable x05_01: confianza ne el gobierno
## JUnto a las variables idencuesta y años. Hay dos formas de organizar estas tablas.
## Observe estas estructuras de datos: ¿cuál es la diferencia entre ambas?
head(elsoc_long)
head(elsoc_wide)

# Convierta la base wide a long
head(elsoc_wide)

elsoc_wide %>% 
  pivot_longer(cols = -idencuesta,
               names_to = "ola",
               values_to = "c05",
               names_pattern = "c05_(\\d{4})") # TODO: ver cómo aplicar una función para recodificar


## DUDA: prescindir de expresiones regulares para cambiar a longer -----
## gsub es una función que me permite reemplazar.
elsoc_wide %>%
  pivot_longer(cols = -idencuesta,
               names_to = "ola",
               values_to = "c05") %>%
  mutate(ola = gsub("c05_", "", ola))

# Convierta la base de long a wide
head(elsoc_long)

elsoc_long %>% 
  pivot_wider(names_from = ola,
              values_from = c05_01)

## Ejemplo de aplicación: estadísticos descriptivos.

tabla2

ENS %>% 
  select(-c(zona,  sexo)) %>% 
  mutate_all(as.numeric) %>% 
  summarise_all(
    list(
      promedio = ~mean(., na.rm = TRUE),
      desv.estandar = ~sd(., na.rm = TRUE),
      mediana = ~mean(., na.rm = TRUE),
      mininimo = ~min(., na.rm = TRUE),
      maximo = ~max(., na.rm = TRUE)
    )
  ) %>% 
  pivot_longer(cols = everything(),
               names_to = c("variable", ".value"),
               names_pattern = "(.*)_(.*)") %>% 
  kbl() %>% 
  kable_classic_2()


# Unite y Separate
data_ficticia <- data.frame(variable_1 = c(1, 2, 3, 4),
                            variable_2 = c(5, 6, 7, 8))

# Unite
data_ficticia %>% unite(col = variable_3, # Ponemos nombre a la nueva columna de datos unidos
                        variable_1:variable_2, # Decimos qué columnas queremos unir
                        sep = "-",
                        remove = FALSE) # Con qué caracter las "pegaremos" (o separaremos).
?unite
# Guardamos
data_ficticia <- data_ficticia %>% unite(col = variable_3, variable_1:variable_2, sep = "-")

# Separate
data_ficticia %>% separate(col = variable_3, # Columna que quieres separar 
                           sep = "-",  # Indicamos el carácter por medio del cual se hará la separación
                           into = c("variable_1", "variable_2")) # Cómo se llamarán las variavbles que contendrán las dos partes

rm(data_ficticia)

# 02. Introducción a programación funcional -------------------------------

## 02.1. Funciones ---------------------------------------------------------

## Funciones

## Bloque
{
  print("mensaje 1")
  print("mensaje 2")
}


## Haga la función de una suma
suma <- function(x, y){
  resultado <- x + y
  return(resultado) # return, opcional.
}


######################.
##Pequeño ejercicio ##
######################.

## Arme una función del promedio.
promedio <- function(x){sum(x)/length(x)}

mean(c(1, 2, 3))

promedio(c(1, 2, 3))

## Arme una función que cuente los NA.

data <- data.frame(vector = c(1, 2, 3, NA))

contar_nas <- function(v){sum(is.na(v))}

contar_nas(data$vector)

## Ejemplo de argumentos evaluados
promedio <- function(x, rounded = 2, na_remove = TRUE){
  round(mean(x, na.rm = na_remove), rounded)
}

vector <- c(6.34435, 7.3453, 2.76576)
promedio(vector, rounded = 3)

## Cómo funciona la función round
round(5.4)
round(5.5)

## 02.2. Estructuras de control --------------------------------------------

## Si una condición se cumple, se ejecuta el bloque.
## De lo contrario, continúa, o podemos usar "else" para que ejecute otro bloque.

## Recuerde que las operaciones lógicas tienen como resultado un booleano:
a <- 2
b <- 3

b > a # Comparación de valores
a == b

if(TRUE){
  print("Este bloque se va a ejecutar")
}

if(a < b){
  print("Este bloque jamás se va a ejecutar")
}

if(FALSE){
  print("Este bloque no se ejecutará")
}
print("Este bloque es continuación")



## Ejemplo
numero <- 3

## ¿El número es 2?
if(numero == 2){
  print("El número es 2")
}

# Suponga que quiero multiplicar por 2 solo los "números 2", 
# Cualquier otro número, le sumo 1.

numero <- 10

if(numero == 2){
  numero*2
} else {
  numero + 1
}

# Ifelse: vectorización del flujo de control
sexo <- c(1, 2, 2, 1)
sexo <- ifelse(sexo == 2, "Hombre", "Mujer")


## 02.3. Loops -------------------------------------------------------------

### For ------------

## Recorra e imprima todos los países del vector "paises":
paises <- c("Estados Unidos", "Canadá", "México", "Brasil", 
            "Argentina", "Chile", "España", "Francia", "Alemania", "Italia")

for(pais in paises){
  print(paste0("Mi país es: ", pais))
}

# Imprimir solo países que empiezan con C
for(pais in paises){
  if(grepl("^C", pais)){
    print(pais)
  }
}

## Rellenar un vector
promedios <- c()

ENS_numericas <- ENS %>% select_if(is.numeric)

for(i in 1:ncol(ENS_numericas)){
  
  promedios[i] <- mean(ENS_numericas[[i]], na.rm = TRUE)

}


### While --------------

## Recorra todas los países del vector "países".

conteo <- 1
while(conteo <= length(paises)){
  
  print(paises[conteo])
  
  conteo <- conteo + 1
}

## Recorra solo los 5 primeros países.
conteo <- 1
while(conteo <= 5){
  
  print(paises[conteo])
  
  conteo <- conteo + 1
}


## 02.4. Familia Apply ------------------------------------------------------

### Sapply -----------------
ENS_numericas %>% 
  sapply(function(x) sum(is.na(x)))

 
### Lapply -----------------

## Soporte de valores
ENS %>%
  select_if(is.factor) %>%
  lapply(unique)


## 02.5. PURRR -------------------------------------------------------------

numeros <- c(0, 5, 8, 3, 2, 1)

multiplicar_dos <- function(x){2*x}

map(numeros, multiplicar_dos)
map_dbl(numeros, multiplicar_dos)
map_df(data.frame(numeros), multiplicar_dos)


## 02.6. Ejercicios --------------------------------------------------------

## Arme una función que muestre la distribución de lanzar n veces un dado.

dado <- function(n){
  total_lanzamientos <- c()
  
  for(i in 1:n){
    lanzamiento <- sample(1:6, size = 1)
    total_lanzamientos[i] <- lanzamiento
  }
  hist(total_lanzamientos)
}

dado(n = 1000)

## Arme una tabla de promedios con intervalos de confianza utilizando 
## summarise all, sapply y map ¿cuál es la diferencia?

promedio_intervalo <- function(x){
  promedio <- round(mean(x, na.rm= TRUE), 2)
  int_1 <- round(promedio + 1.96*sd(x, na.rm = TRUE), 2)
  int_2 <- round(promedio - 1.96*sd(x, na.rm = TRUE), 2)
  
  paste0(promedio, " [", int_1, " - ", int_2, "]")
}

ENS_numericas %>% 
  summarise_all(promedio_intervalo) %>% 
  pivot_longer(cols = everything(),
               names_to = "variables",
               values_to = "promedio con intervalo") %>% 
  kbl() %>% 
  kable_styling()


## Asigne nombres tipo snake case a la base de datos de ENS, pero conserve los
## nombres originales como etiquetas.

## Es un ejercicio más largo, así que lo dejo escrito.
load("enviroment.RData")

original_names <- names(ENS)
ENS <- clean_names(ENS)
                           
for(i in 1:length(names(ENS))){ #ncol
    variable <- names(ENS)[i]
    label(ENS[[variable]]) <- original_names[i]
}

vtable(ENS)

##* Genere una estructura de control que parta en dos los datos (split).
##* Si los datos son pares, haga un split entre la mitad de los datos.
##* Si es impar, haga un split que se aproxime a esta decsión.

if(nrow(ENS)%%2 == 0){
  middle <- nrow(ENS)/2
  
  data_split_1 <- ENS[1:middle,]
  data_split_2 <- ENS[middle:nrow(ENS),] # ¿Existe otra forma de realizar esta función?
  
  } else {
  
  middle <- round(nrow(ENS)/2) + 1
  
  data_split_1 <- ENS[1:middle,]
  data_split_2 <- ENS[middle:nrow(ENS),]
    
}

# POdemos transformarlo a función
split_data <- function(data){
  if(nrow(data)%%2 == 0){
  middle <- nrow(data)/2
  
  data_split_1 <<- data[1:middle,]
  data_split_2 <<- data[middle:nrow(data),] # ¿Existe otra forma de realizar esta función?
  
  } else {
  
  middle <- round(nrow(data)/2) + 1
  
  data_split_1 <<- data[1:middle,]
  data_split_2 <<- data[middle:nrow(data),]
    
}
}

split_data(ENS)
split_data(elsoc_long)

