
########################################################.
## Tutoría 1: Introducción a R y Estructuras de Datos ##
########################################################.


# Recomiendo esta configuración inicial en sus scripts:
rm(list = ls()) # Borrar objetos de la memoria
options(scipen = 999) # Eliminar notación científica


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

##* Para tener un directorio de referencia en R debes fijar el directorio.

getwd() # La carpeta de proyecto es mi raíz

# Pero, ¿qué pasa cuando no estoy en un proyecto?

# 2. Objetos en R ---------------------------------------------------------

# Constantes
pi
exp(1)

# Con el signo <- asignamos un valor o estructura a un objeto
## Ejercicio: Calcule el área de un círculo de radio 2. Considere A = r*pi^2
radio <- 2
radio*pi**2

## Sobre el nombre de los objetos:

##* No puede empezar con un número.
##* No puede tener espacios entre medio.
##* Evitar los carácteres extraños como tildes y ñ.
##* Estilos:
##* - snake_case
##* - camelCase
##* - PascalCase


# Guardar objeto
area_circulo <- radio*pi**2

# Guardar y ejecutar la mismo tiempo
(area_circulo <- radio*pi**2)


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
class(caracter)

# Confirmar clase
is.character(caracter)
is.numeric(caracter)

## 5.2. Transformación y coerción ------------------------------------------

as.character(entero)

# 6. Estructuras de datos -------------------------------------------------

##* Vectores. Arreglo de valores de 1 dimensión. Solo puede tener datos de un tipo de dato
##* Matrices. Estructura de 2 dimensiones. Solo puede tener datos de un tipo de valor.
##* DataFrames. Es lo que reconoce R como bases de datos. Son relacionales y puede contener variables de distinto tipo.
##* Listas. Conjunto que pueden contener diferentes objetos sin importar su estructura. (No es relevante para este taller)
##* Arrays. Conjunto que pueden contener dferentes objetos, pero solo puede tener un único tipo de valor. (No es relevante para este taller)


## 6.1. Vectores -----------------------------------------------------------

## ~~~~ Definición ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Arreglo unidimensional con un solo tipo de dato.

## Con la función c(), podemos elaborar un vector a mano

c(1, 2, 3)

vector_1 <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)
vector_2 <- c("a", "b", "c")

## Concatenar dos vectores
vector_3 <- c(vector_1, vector_2)

# Secuencia
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
vector_bool <- c(TRUE, FALSE)
vector_bool

vector_enteros <- as.numeric(vector_bool)
vector_enteros

as.character(vector_enteros)
as.character(vector_bool)

# Implícita:
## i) Objetos con restricciones (vectores)
c(1, 2, 3, "Hola")
c(1, 2, 3, TRUE)

## ii) Estructura
vector_a <- c(1, 2, 3)
vector_b <- c(1, 2, 3, 4)

vector_c <- vector_a + vector_b

vector_c # ¿de dónde sacó el vector_c su último elemento, si a y b tienen diferentes dimensiones?

cbind(vector_a, vector_b, vector_c)


### 6.2.1. Operaciones con vectores -----------------------------------------

## Aritméticas

### Constantes
(vector_1 <- -1:-3)
vector_1 + 1
vector_1 / 2

### Entre vectores
vector_2 <- 1:3
vector_1 + vector_2
vector_1 / vector_2

## Lógicas
vector_2
vector_2 > 2
vector_2 >= 2
vector != 3


## 6.2. Matrices -------------------------------------------------------------

## ~~~~ Definición ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Conjunto de datos ordenados en dos dimensiones. Solo un tipo de dato.

# Matriz de un vector con dimensión nx1
matriz_0 <- matrix(c(1, 2, 3, 4, 5, 6))
matriz_0

# Vector reorganizado como matriz:
matriz_1 <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2) # Con epecificar nrow o ncol, basta
matriz_2 <- matrix(c(1, 2, 3, 4, 5, 6), ncol = 3, byrow = TRUE)

# Segundo método: Vectores como columnas
vector_1 <- 1:5
vector_2 <- rep(1, times = 5)
vector_3 <- seq(2, 10, by = 2) ## O bien: vector_1*2

matriz_3 <- cbind(vector_1, vector_2, vector_3)

# Vectores como filas
matriz_4 <- rbind(vector_1, vector_2, vector_3)

# Ejercicios --------------------------------------------------------------

## 1) Genere la matriz: {0 0 0 \\ 1 1 1 \\ 2 2 2}

v1 <- rep(0, 3)
v2 <- rep(1, 3)
v3 <- rep(2, 3)

(A <- matrix(c(v1, v2, v3), ncol = 3))
(A <- rbind(v1, v2 , v3))

## Propuesto,
## ¿cómo añadir una cuarta columna vector_4 que sea el resultado de vector_3 - 1?

vector_4 <- vector_3 - 1 
cbind(matriz_3,  vector_4)

## 2) Genere la matriz: {0 1 2 \\ 0 1 2 \\ 0 1 2}

(A <- matrix(c(v1, v2, v3), ncol = 3))
(A <- cbind(v1, v2 , v3))


### 6.2.1. Dimensionalidad e índices -----------------------------------------

# Dimensiones: Aij
# POr convención: primero va la fila,luego la columna.
dim(matriz_3)

# Índices

## Matriz[i, j]

matriz_3[1, 1]
matriz_3[2,]
matriz_3[, 2]

matriz_3



### Coerción: ejemplos con matrices -----------------------------------------

# Coerción implícita

## Propiedad: solo un tipo de dato
matrix(c(1, 2, 3, TRUE), ncol = 2)
matrix(c(1, 2, 3, "Hola"), ncol = 2)

vector_a1 <- 5:3
vector_a2 <- c("Chile", "Argentina", "Bolivia")

cbind(vector_a1, vector_a2)

## Estructura
matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 3)

vector_a1 <- c(1, 2, 3)
vector_a2 <- c(1, 2, 3, 4)

cbind(vector_a1, vector_a2)


### 6.2.2. Operaciones entre matrices ----------------------------------------------
A <- matrix(1:4, ncol = 2) ## Sean A y B, bla bla bla
B <- cbind(c(3, 7), c(4, 10))
x <- matrix(c(1,2))

## Operaciones
diag(A)
det(A)
t(A)
A + B
A %*% B
A %*% x
solve(A)

## Ejercicios: -------------------------------------------------------------

## 1) Muestre que AA-1 = I
solve(A)
A%*%solve(A)

## 2) Calcule Ax
A %*% x

## 3) Calcule AtA
t(A) %*% A

## 4) Pruebe que: XtX es la suma de sus elementos al cuadrado
x <- iris$Sepal.Length
X <- matrix(x)

t(X) %*% X
sum(x**2)

## 5) Calcule correlación, XtXn^(-1)
x1 <- rnorm(100, mean = 4, sd = 1.2)
x2 <- rnorm(100, mean = 5, sd = 1.5)

z1 <- scale(x1)
z2 <- scale(x2)

X <- cbind(z1, z2)

t(X) %*% X*(1/100)
cor(X)

## Matriz de correlación con varias variables (propuesto)


### 6.2.3. Comentarios para abordar la pregunta 1c ---------------------------------------

## 1) Para confeccionar su matriz X, consideren la notación matricial del modelo teórico (vector de puros 1, como primer vector)
## 2) Siempre debe verificar sus resultados, utilizando la función para estimar los coeficientes de regresión en R: lm

## lm(Y ~ X, data = datos)
head(cars)
lm(dist ~ speed, data = cars)

## La operación matricial debe contener estos dos resultados

## 6.3. DataFrames ---------------------------------------------------------

## ~~~~ Definición ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##* Definición: Es lo que R reconoce como Base de Datos. Es un marco de datos relacional
##* que tiene un conjunto de variables.


### 6.3.1. Generación manual ------------------------------------------------

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
head(data)
tail(data)

dim(data) # Las filas y columnas tienen interpretación
nrow(data)
ncol(data)

# Observar contenidos
str(data)
names(data)

## Seleccione las dos primeras variables
data[, c(1,2)]
data %>% select(1,2)

## Seleccione la variable edad
data[, 1]
data$edad

## Elimine la variable edad
data[, -1]
data %>% select(-1)
data %>% select(-edad)

# Añadir variable
data$nacimiento # Todavía no existe
data$nacimiento <- 2023 - data$edad
data

# Con mutate
data %>% mutate(nacimiento_2 = 2023 - edad)

# Cuidado con los NAs
data$dummy_variable <- c(rep(1,7), NA)

mean(data$dummy_variable)
mean(data$dummy_variable, na.rm = TRUE)


# Manipulación de datos con dplyr ------------------------------------------------

## Filter
data %>% filter(nivel_educacional == "Básica")

## Group by y summarise, dos funciones comunes
data %>% 
  mutate(sexo = ifelse(sexo == 1, "Hombre", "Mujer")) %>% 
  group_by(sexo) %>% 
  summarise(promedio = mean(edad, na.rm = TRUE))

## Renombrar variables
data %>% 
  rename("sexo_asignado" = "sexo")

## Importante: si quieres aplicar estos cambios a tu data, debes reescribir el objeto


# 7. APIs -----------------------------------------------------------------

## Trabajaremos con el paquete de R que consulta la API del Banco Mundial
library(WDI)

## Documentación: https://github.com/vincentarelbundock/WDI

## 7.1. Hacer la consulta --------------------------------------------------

## El paquete WDI consulta la API del Banco Mundial, en función de:
##* - Identificador del índicador (obligatorio)
##* - Otras especificaciones opcionales: periodo, cache, datos extra, etc.

## Cómo obtener el ID del indicador:
##* - Usar la función WDIsearch
##* - Portal de indicadores del Banco Mundial: https://data.worldbank.org/indicator (RECOMENDADA)

WDIsearch(string = "Life expectancy")

## Ok, pero mejor ir a la página oficial y sacar de ahí el ID


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


## Filtramos por américa latina y el caribe
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
  summarise(promedio = mean(life_exp, na.rm = TRUE)) # Omitir los NA's, siempre

## Recuerden que las funciones de estadísticos descriptivos son:
##* Centro: mean, median
##* Dispersión: sd, var
##* Posición: min, max


# 8. Consideraciones finales ----------------------------------------------

##* Lógica vertical del flujo de ejecución
##* Trabajar en proyectos o fijar el directorio
##* Comentarios descriptivos
##* Nombres de objetos descriptivos



