
###############################################.
## Tutoría 3: manejo y ordenamiento de datos ##
###############################################.

## Puede ver un índice apretando: Ctrl + Shift + O

# Coniguración inicial
rm(list = ls())
options(scipen = 999)

# Librerías
library(tidyverse)
library(janitor)
library(readxl)
library(haven)
library(foreign)
library(knitr)
library(kableExtra)
library(tidytext)


# Parte 1: Limpieza de bases de datos y manejo de variables -------------


## a) ----------------------------------------------------------------------
# Importación eficiente de los datos. Importe la base de datos ENS.RData con la 
# función correcta ¿por qué el formato requiere este método de importación? (
# Hint: el formato RData es un formato nativo de R, que a diferencia de otras bases 
# de datos, solo requiere de la función "load", y el objeto es guardado en el 
# enviroment.)



## b) ----------------------------------------------------------------------
# Renombrar variables. Los nombres de sus columnas tienen algunos nombres extraños. 
# Cambie el nombre de estas variables de su nombre original al estilo snake_case. 
# Luego, asigne etiquetas a sus variables.


## c) ----------------------------------------------------------------------
# Manejo de variables en R. Use la función glimpse() para observar la base de 
# datos. Como puede observar, el tipo y clase de las variables presentan 
# categorías equivocadas. En particular, se observan dos errores que deben ser 
# arreglados:


## i)
# Tipo de dato de las variables. Como puede observar, las variables Depresión, 
# Diabetes y Asma, son reconocidos por R como character (string), 
# pero sus valores son numéricos. ¿Es posible identificar la causa de este cambio 
# de tipología? Cambie las variables al formato correcto.


## ii)
# Clase de las variables. ¿Qué otros cambios debe realizar a sus variables 
# respecto a su clase? Realice los cambios correspondientes a sus variables 
# según la medición correspondiente. Al finalizar, exporte la base de datos en 
# los formatos RData, excel, stat y spss.



# Parte 2: manejo de base de datos con dplyr ------------------------------


## a) ----------------------------------------------------------------------
# Creación de variables con mutate. Genere las siguientes variables continuas y 
# categóricas y añádalas a la base de datos:


# i)
# hta: Diagnóstico de Hipertensión. Utilice las varialbes de presion_pad y 
# presion_pas para construir la variable "padece hipertensión" (hta). Según la 
# OMS, se considera que el paciente tiene la presión alta cuando la presión está 
# por sobre los 140/90 mmHg (PAS/PAD).


# ii)
# grupos_edad: grupos de categoría de la edad. Agrupe las siguientes edades en 
# sus categorías de edad: "15 a 24 años", "25 a 44 años", "45 a 64 años" y 
# "65 años o más".


# iii)
# indice_riesgo: Índice de Factores de Riesgo. En una base de datos aparte, 
# genere un índice en donde se suman la cantidad de afecciones a la salud 
# presentes en la base de datos.


## b) ----------------------------------------------------------------------
# Generación y visualización de tablas con kable. Genere las siguientes tablas 
# en formato académico. Asegúrese de facilitar el formato correcto apoyándose en 
# las herramientas que R brinda para tal ocasión.

# i)
# Una tabla con los valores perdidos de las variables.

# ii)
# Una tabla de estadísticos descriptivos de las variables continuas.


## c) ----------------------------------------------------------------------
# Funciones de la familia join. Las bases de datos opiniones_1.xlsx y 
# opiniones_2.xlsx tiene la repetición de palabras de malestar por id de paciente. 
# Una ambas bases de datos con el mejor método y elimine los conectores de la 
# tabla resultante.


# Parte 3: introducción al manejo de estructura de los datos con tidyr --------


## a) ----------------------------------------------------------------------
# Pivotear una tabla de datos. Una dos bases de datos pacientes_1.xlsx y 
# pacientes_2.xlsx para ello, uilice el mejor método. Exporte una base de datos 
# en formato wide y otra base de datos en formato long.

