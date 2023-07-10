
########################################################.
## Tutoría 1: Introducción a R y Estructuras de Datos ##
########################################################.


# Recomiendo esta configuración inicial en sus scripts:
rm(list = ls())
options(scipen = 999)


## Introducción al manejo básico de R:

## -------------- COMENTARIOS
# Este es un comentario

#* Este es un comentario con *, +, >: comentarios continuos
#* (Continuación)

# Ctrl + Shift + R para generar "headers" ----------------------------------

# Ctrl + Shift + O para ver un otline


## -------------- ORDEN DE EJECUCIÓN
## En R, los diferentes comandos se ejecutan línea por línea, con una lógica vertical
print("Primer evento")
print("Segundo evento")

# También, puedo ejecutar dos líneas al mismo tiempo, usando ";"
print("Primer evento"); print("Segundo evento")

## Es cuestión de gustos. Lo común es hacer lo primero, ya que es más amable a la vista.


## -------------- EJECUTAR INSTRUCCIONES DESDE EL SCRIPT
## Con Ctrl + Enter envían una instrucción a la consola, desde el script
## En Rstudio, solo se envía a consola lo que tengo marcado:

sum(c(1, 2, 3)) # ¿qué pasa si solo marco el c(1, 2, 3)?


## -------------- PIPE OPERATOR
## Otro apunte importante: la ayudante usa mucho el pipe operator.
## COn el pipe operator, estas dos sintaxis son equivalentes:

filter(iris, Species == "setosa")
iris %>% filter(Species == "setosa")


# 1. Fijar el directorio --------------------------------------------------

## Para tener un directorio de referencia en R, debes fijar el directorio con setwd()

## getwd() Ver el directorio actual


## setwd() Fijar un directorio


# Pero, ¿qué pasa cuando no estoy en un proyecto?

# 2. Objetos en R ---------------------------------------------------------

# Constantes
pi
exp(1)

# Con el signo <- asignamos un valor o estructura a un objeto

## Ejercicio: Calcule el área de un círculo de radio 2. Considere A = r*pi^2


# Guardar objeto


# Guardar y ejecutar la mismo tiempo


# 3. Funciones ---------------------------------------------------------------

## A estos objetos podemos aplicar funciones.

## 3.1. Ejemplos de funciones en R -----------------------------------------

vector <- c(1, 2, 3, 5)

length(vector)
sum(vector)
mean(vector)
sd(vector)
table(c(c(0, 0, 0), c(1, 1)))

## 3.2. Documentación ------------------------------------------------------

# Consultar la documentación
?mean

# Argumentos de la función
args(mean)

# Ejemplos
example(mean)

## 3.2. Librerías y paquetes -----------------------------------------------

##* Algunas funciones están asociadas a paquetes:
##* - Si no los has instalado, debes usar la función "install.packages"
##* - Luego, para cargarlo, usas lafunción "library"
##* install.packages debes usarlo una vez, library debes usarlo cada vez que uses esa función

library(dplyr) # filter, select, mutate, rename, gruop_by, summarise ..
library(tidyr) # tibble, gather, spread ...
library(readxl) # read_excel
library(WDI) # Acceso facilitado a la World Bank API

# 4. Operaciones ----------------------------------------------------------

## 4.1. Aritméticas --------------------------------------------------------

a <- 1
b <- 2

a + b  ## R como calculadora
a - b
a / b
a*b
a**2

# Paréntesis
(a + b) / b

a %% b # módulo
a %/% b # div. entera

## 4.2. Lógicas ------------------------------------------------------------

# Operadores
a > b
a == b
a != b

# Álgebra de eventos
c <- a > b
d <- a != b

c|d
c&d


# 5. Tipo de datos --------------------------------------------------------

caracter <- "Hola, ¿Qué tal?" ## string
entero <- 1L
numerico <- 0.5
booleano <- TRUE
perdido <- NA
no_existe <- NULL


## 5.1. Comprobar el tipo de dato ------------------------------------------

# Obtener clase (función class)


# Confirmar clase

## Preguntar ¿caracter, es de clase character?
is.character(caracter)

## Preguntar: ¿caracter, es de clase numeric?
is.numeric(caracter)


## 5.2. Transformación y coerción ------------------------------------------

# Puedo transformar los enteros a character

# Pero no puedo transformar los character a entero

# 6. Estructuras de datos -------------------------------------------------

##* Vectores. Arreglo de valores de 1 dimensión. Solo puede tener datos de un tipo de valor.
##* Matrices. Estructura de 2 dimensiones. Solo puede tener datos de un tipo de valor.
##* DataFrames. Es lo que reconoce R como bases de datos. Son relacionales y puede contener variables de distinto tipo.
##* Listas. Conjunto que pueden contener diferentes objetos sin importar su estructura. (No es relevante para este taller)
##* Arrays. Conjunto que pueden contener dferentes objetos, pero solo puede tener un único tipo de valor. (No es relevante para este taller)


## 6.1. Vectores -----------------------------------------------------------

## ~~~~ Definición ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Arreglo unidimensional con un solo tipo de dato.

## Con la función c(), podemos elaborar un vector a mano

## vector 1: numético


## vector 2: strings



## Concatenar dos vectores, con c()



# Vectores con patrones específicos
secuencia_1 <- 1:5
secuencia_2 <- seq(from = 1, to = 5, by = 0.1)
repeticion <- rep(5, 10)
x <- rnorm(100, mean = 4, sd = 1.2) # Variable aleatoria simulada


### 6.1.1. Dimensionalidad e índice -----------------------------------------

# Los vectores solo tienen una dimensión. Para comprobar la dimensionalidad use "length"
length(vector)

# Índice
vector[2]
vector
vector[1:3]

# Propiedad: los vectores solo admiten un tipo de dato
vector_3 <- c(1, 2, 3, 4)
class(vector_3)

# ¿Qué pasa si añado varios tipos de datos?
vector_4 <- c(1, 2, 3, "Hola")
vector_4
class(vector_4)

## Esto se conoce como cohersión


### *Coerción: ejemplos con vectores -----------------------------------------

## Jerarquía de la coerción: LÓGICO -> ENTERO -> NUMÉRICO -> TEXTO

# Explícita
## Ejemplo: bool --> numeric

## Ejemplo: bool y numeric --> caracter


# Implícita:
## i) Objetos con restricciones (vectores)

# Ejemplo: cuando añado tipos de datos mixtos a un vecto


## ii) Estructura
# Ejemplo: suma de vectores, con vectores con dimensiones desiugales


## Comparemos con cbind, para ver qué pasó


### 6.2.1. Operaciones con vectores -----------------------------------------

## Aritméticas

### Operaciones con constantes
(vector_1 <- -1:-3)

# Suma 1

# Divide por 2



### Entre vectores
vector_2 <- 1:3

# Suma entre vectores


# División entre vectores


## N: Es importante considerar que: es una suma/división ordenada


## Lógicas

## Ejemplo: Elementos del vector 2 mayores a 2

## Ejemplo: Elementos del vector 2 diferentes a 3


# La verdad, no tiene mucho sentido hacer estas operaciones entre dos vectores


## 6.2. Matrices -------------------------------------------------------------

## ~~~~ Definición ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Conjunto de datos ordenados en dos dimensiones. Solo un tipo de dato.

# Método 1: Reorganización de un vector con la función matrix:

# Ejemplo: Matriz de un vector con dimensión n x 1. El vector es una secuencia del 1 al 6


# Vector reorganizado como matriz:

# Ejemplo: Matriz con dimensiones 3x2 con una secuencia del 1 al 6



# Ejemplo: Reproduzca esta matriz:

## 1  2  3
## 4  5  6



# Segundo método: Vectores como columnas

## Haga una matriz que contenga las siguientes columnas:
##> vector 1: una secuencia de enteros del 1 al 5
##> vector 2: una repetición del número 1
##> vector 3: Una secuencia del 2 al 10


## Propuesto,
## ¿cómo añadir una cuarta columna vector_4 que sea el resultado de vector_3 - 1?



# ¿Y por filas?



# Ejercicios --------------------------------------------------------------

## 1) Genere la matriz: {0 0 0 \\ 1 1 1 \\ 2 2 2}


## 2) Genere la matriz: {0 1 2 \\ 0 1 2 \\ 0 1 2}



### 6.2.1. Dimensionalidad e índices -----------------------------------------

# Dimensiones: Aij
# POr convención: primero va la fila, luego la columna.

(A_ij <- cbind(1:5, 1:5*2, 1:5*3))

# Consulte las dimensiones de la matriz con dim()


# Índices

## Matriz[i, j]

## Consulte el elemento de la fila 1 y la columna 1


# Consulte toda la fila 2


# Consulte toda la columna 2



### Coerción: ejemplos con matrices -----------------------------------------

# Coerción implícita

## i) Restricción de la estructura

## Propiedad: solo un tipo de dato
vector_a1 <- 5:3
vector_a2 <- c("Chile", "Argentina", "Bolivia")

## Ejemplo: una estos dos vectores en una matriz


## Recordar: LÓGICO -> ENTERO -> NUMÉRICO -> TEXTO

## ii) Estructura

## Cree una matriz con dos columas: el vector a1 con una secuencia del 1 al 3
## y el vector a2, con una secuencia del 1 al 4.



### 6.2.2. Operaciones entre matrices ----------------------------------------------
A <- matrix(1:4, ncol = 2) ## Sean A y B, bla bla bla
B <- cbind(c(3, 7), c(4, 10))
x <- matrix(c(1,2))


# Diagonal de A


# Determinante de A


# Transpuesta de A (A^t)


# Suma entre A y B


# Multiplicación entre A y B


# Inversa de A (A^(-1))



## Ejercicios: -------------------------------------------------------------

## 1) Muestre que AA-1 = I



## 2) Calcule Ax



## 3) Calcule A^tA



## 4) Muestre que: XtX es la suma de sus elementos al cuadrado
x <- iris$Sepal.Length


## 4) Muestre que: XtXn^(-1) es equivalente a la matriz de covarianza
x1 <- rnorm(100, mean = 4, sd = 1.2)
x2 <- rnorm(100, mean = 5, sd = 1.5)


## Matriz de correlación con varias variables (propuesto)



### 6.2.3. Comentarios para abordar la pregunta 1c ---------------------------------------

## 1) Para confeccionar su matriz X, consideren la notación matricial del modelo teórico (vector de puros 1, como primer vector)
## 2) Siempre debe verificar sus resultados, utilizando la función lm

## lm(Y ~ X, data = datos)
head(cars)
lm(dist ~ speed, data = cars)


## 6.3. DataFrames ---------------------------------------------------------

## ~~~~ Definición ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##* Es lo que R reconoce como Base de Datos. Es un marco de datos relacional
##* que tiene un conjunto de variables.


### 6.3.1. Generación manual ------------------------------------------------

# Podemos generar manualmente, con la función data.frame
data <- data.frame(edad = c(24, 60, 15, 31, 56, 70, 23, 44),
                   sexo = c(1, 0, 0, 1, 0, 0, 1, 1),
                   nivel_educacional = c("Básica", "Universitaria", 
                                         "Media", "Posgrado", "Posgrado", 
                                         "Básica", "Media", "Posgrado"))

## Observación interesante: las variables son, estructuralmente hablando, vectores.
data$edad

### 6.3.2. Importación de la base de datos ----------------------------------

## Lo común no es hacerlas a mano, sino importarlas

library(readxl)
data <- read_excel("datos.xlsx") # una pequeña base de datos :)

## Ver en files > hacer click en la data


## 6.3.3. Exploración y manipulación ------------------------------------------------------

# Primeras o últimas 5 observaciones



# Dimensionalidad

## ¿Cuántas observaciones tiene?


## ¿Cuántas variables tiene?


# Observar contenido
## Con str: ver la info de las variables


## Ver los nombres de las variables


## Seleccione las dos primeras variables



## Seleccione la variable edad



## Elimine la variable edad



# Añadir variable

## Ejemplo: añada una vairable llamada "año de nacimiento"


# ¿y con mutate?


# Cuidado con los NAs

## Ejemplo: vea lo que sucede con esta variable que tiene un NA
data$dummy_variable <- c(rep(1,7), NA)


# Manipulación de datos con dplyr ------------------------------------------------

## Filtrar la data por nivel educacional de básica


## Group by y summarise, dos funciones comunes. Agrupar por sexo y calcula el promedio de edad 


## Renombrar variables

## Ejemplo: Renombre la variable "sexo" como "sexo_asignado"


## Importante: si quieres aplicar estos cambios a tu data, debes reescribir el objeto

# 7. APIs -----------------------------------------------------------------

## Trabajaremos con el paquete de R que consulta la API del Banco Mundial

library(WDI)

## Documentación: https://github.com/vincentarelbundock/WDI

## 7.1. Hacer la consulta --------------------------------------------------

## Cómo obtener el ID del indicador:

## 1) Usar la función WDIsearch

WDIsearch(string = "Life expectancy")

## 2) Portal de indicadores del Banco Mundial: https://data.worldbank.org/indicator



## 7.2. Extracción de los datos por medio de la consulta -------------------

data_life_expectancy <- WDI(indicator = 'SP.DYN.LE00.IN', 
                            country = "all", 
                            start = 2015, 
                            end = 2020,
                            extra = TRUE) # Más características de los países

## Observemos nuestra data
head(data_life_expectancy)


## ¿Cómo me aseguro que la data es de los años 2015-2020?

## Está especificado en la función, pero puede que algunos años falten.
## Recomiendo esta exploración:

table(data_life_expectancy$year)


## Filtramos por américa latina y el caribe ("Latin America & Caribbean")
data_life_expectancy <- data_life_expectancy %>% 
  filter(region=="Latin America & Caribbean")

## Observemos nuevamente:
head(data_life_expectancy)


## Renombramos: algunos ajustes adicionales
data_life_expectancy <- data_life_expectancy %>% 
  rename("life_exp" = "SP.DYN.LE00.IN")

## 7.3. Estadísticos descriptivos ------------------------------------------

data_life_expectancy %>% 
  group_by(region, year) %>% 
  summarise(promedio = mean(life_exp)) # ¿por qué solo hay NA`s?

## Recuerden que las funciones de estadísticos descriptivos son:
##* Centro: mean, median
##* Dispersión: sd, var
##* Posición: min, max


# 8. Consideraciones finales ----------------------------------------------

##* Lógica vertical del flujo de ejecución
##* Trabajar en proyectos o fijar el directorio
##* Comentarios descriptivos
##* Nombres de objetos descriptivos



