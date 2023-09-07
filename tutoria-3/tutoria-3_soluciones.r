
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
library(tidytext) ##Existe una forma más eficiente?


pacman::p_load(tidyverse,
              janitor,
              readxl,
              haven,
              foreign,
              knitr,
              kableExtra,
              tidytext)

# Parte 1: Limpieza de bases de datos y manejo de variables -------------


## a) ----------------------------------------------------------------------
# Importación eficiente de los datos. Importe la base de datos ENS.RData con la 
# función correcta ¿por qué el formato requiere este método de importación? (
# Hint: el formato RData es un formato nativo de R, que a diferencia de otras bases 
# de datos, solo requiere de la función "load", y el objeto es guardado en el 
# enviroment.)

load("Input/ENS.RData")
head(ENS)


## b) ----------------------------------------------------------------------
# Renombrar variables. Los nombres de sus columnas tienen algunos nombres extraños. 
# Cambie el nombre de estas variables de su nombre original al estilo snake_case. 
# Luego, asigne etiquetas a sus variables.

# Opción 1

## Ayudas:
## Expresión regular para cualquier carácter con tilde: 

names(ENS)

str_replace(str_to_lower(colnames(ENS)), " ", "_")

# Pero todavía hay tildes!

janitor::clean_names(ENS)

## Mucho mejor

ENS <- clean_names(ENS)


## c) ----------------------------------------------------------------------
# Manejo de variables en R. Use la función glimpse() para observar la base de 
# datos. Como puede observar, el tipo y clase de las variables presentan 
# categorías equivocadas. En particular, se observan dos errores que deben ser 
# arreglados:

glimpse(ENS)

## i)
# Tipo de dato de las variables. Como puede observar, las variables Depresión, 
# Diabetes y Asma, son reconocidos por R como character (string), 
# pero sus valores son numéricos. ¿Es posible identificar la causa de este cambio 
# de tipología? Cambie las variables al formato correcto.

## A qué se debe esto?
ENS$depresion %>% table

# Por coerción
ENS_prueba <- ENS %>% 
  mutate_at(vars(diabetes, depresion, asma), as.numeric)


# Observemos:
glimpse(ENS_prueba)

## Eliminamos el valor perdido
ENS_dep_limpia <- ENS %>% 
  mutate(depresion = ifelse(depresion == "Sin datos", NA, depresion))

ENS_prueba2 <- ENS_dep_limpia %>% 
  mutate_at(vars(diabetes, depresion, asma), as.numeric)



glimpse(ENS_prueba2)

ENS <- ENS_prueba2

# Eliminamos la prueba
rm(ENS_prueba, ENS_prueba2, ENS_dep_limpia)


## ii)
# Clase de las variables. ¿Qué otros cambios debe realizar a sus variables 
# respecto a su clase? Realice los cambios correspondientes a sus variables 
# según la medición correspondiente. Al finalizar, exporte la base de datos en 
# los formatos RData, excel, stat y spss.

glimpse(ENS)

# RBase

# ENS$comuna <- factor(ENS$comuna) # desbloquear este comentario para observar ######## ---

# Dplyr methods
# ENS <- ENS %>% 
#   mutate(comuna = factor(comuna))

glimpse(ENS)

## Hagamos lo mismo con el resto de variables
ENS <- ENS %>% 
  mutate(comuna = factor(comuna),
         sexo = factor(sexo, level = c(1, 2) , labels = c("Hombre", "Mujer"))) %>% 
  mutate_at(vars(depresion, diabetes, asma), ~factor(., level = c(1,2), labels = c("Si", "No")))

glimpse(ENS)


## =================================================================================== ##
## Discusión: A veces, no me conviene tener variables categóricas de "Sí" y "No"
## A veces, quizñas me conviene tener variables de 0 y 1, para poder contar cuantas
## Personas tienen esta condición o no, lo cual me servirá para hacer gráficos.
## Esto depende de los objetivos del análisis.
## =================================================================================== ##


# Exportamos las bases de datos

## RData, formato nativo
dir.create("Output")
save(ENS, file = "Output/ENS.RData")

## Excel, librería «openlsx»
library(openxlsx)
write.xlsx(ENS, file = "Output/ENS.xlsx")

## Stata, librería «haven» y «foreing»
# haven
write_dta(ENS, "Output/ENS.dta")

# foreing
write.dta(ENS, "Output/ENS_foreign.dta")


## Spss, libraría «haven»
write_sav(ENS, "Output/ENS.sav")

## =================================================================================== ##
## Discusión: ¿cómo quedan los formatos de las variables al importar a estos formatos?
## Importe y aplique glimpse()
## =================================================================================== ##

## Pruebe aquí:
rm(ENS)
load("Output/ENS.RData") # .rds
glimpse(ENS)

ENS_1 <- read_excel("Output/ENS.xlsx")
glimpse(ENS_1)

ENS_2 <- read_dta("Output/ENS.dta")
glimpse(ENS_2)
ENS_2$sexo

ENS_3 <- read_dta("Output/ENS_foreign.dta")
glimpse(ENS_3)

ENS_4 <- read_sav("Output/ENS.sav")
glimpse(ENS_4)

# Pero ojo, los labels están presentes:
ENS$depresion

rm(list = ls())

# Parte 2: manejo de base de datos con dplyr ------------------------------

## a) ----------------------------------------------------------------------
# Creación de variables con mutate. Genere las siguientes variables continuas y 
# categóricas y añádalas a la base de datos:

load("Output/ENS.RData")

## Problemas sobre creación de variables categóricas (ifelse y case_when)

# i)
# hta: Diagnóstico de Hipertensión. Utilice las varialbes de presion_pad y 
# presion_pas para construir la variable "padece hipertensión" (hta). Según la 
# OMS, se considera que el paciente tiene la presión alta cuando la presión está 
# por sobre los 140/90 mmHg (PAS/PAD).

## Creamos la variable con la función "ifelse".
ENS
ENS <- ENS %>%
  mutate(hta = ifelse(presion_pas >= 140 & presion_pad >= 90, 1, 0))
# ii)
# grupos_edad: grupos de categoría de la edad. Agrupe las siguientes edades en 
# sus categorías de edad: "15 a 24 años", "25 a 44 años", "45 a 64 años" y 
# "65 años o más".

ENS <- ENS %>% 
  mutate(grupos_edad = case_when(edad < 25 ~ 1,
                                 edad < 45 ~ 2,
                                 edad < 65 ~ 3,
                                 edad >= 65 ~ 4),
         grupos_edad = factor(grupos_edad, level = c(1, 2, 3, 4),
                              labels = c("15 a 24 años", "25 a 44 años",
                                         "45 a 64 años", "65 años o más")))

# iii)
# indice_riesgo: Índice de Factores de Riesgo. En una base de datos aparte, 
# genere un índice en donde se suman la cantidad de afecciones a la salud 
# presentes en la base de datos.

## En primer lugar, debemos transformar los factores de riesgo a numéricas

ENS <- ENS %>% 
  mutate_at(vars(hta, asma, diabetes, depresion), ~ifelse(. == "No", 0, 1)) %>%  # ¿por qué empezar en el "No"?
  mutate(indice_riesgo = hta + asma + diabetes + depresion,
         
         ### duda: ¿qué pasaría si quiero categorizar "indice_riesgo"? ----
         indice_riesgo_categorica = case_when(indice_riesgo <= 2 ~ 1,
                                              indice_riesgo <= 6 ~ 2,
                                              indice_riesgo > 6 ~ 3))





##########################.
## Propuesta interesante:

## ¿Alguna vez les tocó enfrentarse a una encuesta así?

ENS_modular <- ENS %>% 
  rename(factor_depresion = depresion, 
         factor_diabetes = diabetes,
         factor_asma = asma, 
         factor_hta = hta) %>% 
  relocate(starts_with("factor_"), .after = last_col())

head(ENS_modular)
View(ENS_modular)

## ¿Existe una forma de abordar estas variables, siendo que tienen el mismo sufijo?

ENS_modular %>%
  mutate_at(vars(starts_with("factor_")), ~ifelse(. == "Si", 1, 0))


## b) ----------------------------------------------------------------------
# Generación y visualización de tablas con kable. Genere las siguientes tablas 
# en formato académico. Asegúrese de facilitar el formato correcto apoyándose en 
# las herramientas que R brinda para tal ocasión.

# i)
# Una tabla con los valores perdidos de las variables.

# Sigamos esta idea:
ENS %>% 
  summarise_all(~sum(is.na(.)))

# Armamos la tabla

tabla_1 <- ENS %>% 
  summarise_all(list(
    missings = ~sum(is.na(.))*100/length(.)
  )) %>%  pivot_longer(cols = everything(),
               names_to = c("variable", ".value"),
               names_pattern = "(.*)_(.*)")


# Usamos las herramientas de kableExtra para facilitar el copiar y pegar:
tabla_1 %>%
  kbl(
    col.names = c("Missings (N)", "Missings %"),
    caption = "Tabla 1: casos perdidos por variables",
    digits = 2
  )




# ii)
# Una tabla de estadísticos descriptivos de las variables continuas.

# Usamos la misma estructura:
tabla_2 <- ENS %>%
  select(grep("^edad|pad|pas|peso|talla", colnames(.))) %>% # ¿Existe otra forma de seleccionar?
  summarise_all(list(
    media = ~mean(., na.rm = TRUE),
    desviacion = ~sd(., na.rm = TRUE)
  )) %>%
  pivot_longer(cols = everything(), 
               names_to = c("variable", ".value"), 
               names_pattern = "(.*)_(.*)")


## Usamos las herramientas de kableExtra para facilitar el copiar y pegar:
tabla_2 %>%
  kbl(
    col.names = c("variables", "media", "desviación"),
    caption = "Tabla 2: Estadísticos descriptivos",
    digits = 2
  )


## c) ----------------------------------------------------------------------
# Funciones de la familia join. Las bases de datos opiniones_1.xlsx y 
# opiniones_2.xlsx tiene la repetición de palabras de malestar por id de paciente. 
# Una ambas bases de datos con el mejor método y elimine los conectores de la 
# tabla resultante.

## Importamos las bases de datos:
opiniones_1 <- read_excel("Input/opiniones_1.xlsx")
opiniones_2 <- read_excel("Input/opiniones_2.xlsx")


# Unimos las bases de datos con la familia join ¿cuál es el mejor método?

# Qué suceede aquí?
opiniones_1 %>% full_join(opiniones_2, by = c("frases", "id"))

opiniones_1 %>% inner_join(opiniones_2, by = c("frases", "id"))

# Nos decidimos por full_join()
opiniones <- opiniones_1 %>% full_join(opiniones_2, by = c("frases", "id"))


## Ahora, armamos una base de datos que va a mostrar la cantidad de palabras:
conteo_palabras <- opiniones %>%
  unnest_tokens(palabra, frases, strip_numeric = TRUE) %>% # Sacar números
  count(palabra, sort = TRUE) %>% 
  tibble

conteo_palabras

## ¿Cómo eliminar conectores? Momento de usar ANTI_JOIN

## Ojo: "stopwords" es una base de datos que uniremos negativamente con la otra base
stopwords <- data.frame(palabra = c("a", "en", "de"))

conteo_palabras_1 %>% 
  anti_join(stopwords, by = "palabra")

# Así vamos eliminado las stop words!

## SUGERENCIA AVANZADA: ¿Cómo eliminar conectores? Sugerencia avanzada:
## Importe esta base de datos:
## "https://raw.githubusercontent.com/7PartidasDigital/AnaText/master/datos/diccionarios/vacias.txt"


# Parte 3: introducción al manejo de estructura de los datos con tidyr --------

## a) ----------------------------------------------------------------------
# Pivotear una tabla de datos. Una dos bases de datos pacientes_1.xlsx y 
# pacientes_2.xlsx para ello, uilice el mejor método. Exporte una base de datos 
# en formato wide y otra base de datos en formato long.

# Importamos las bases de datos:
pacientes_1 <- read_excel("Input/pacientes_1.xlsx")
pacientes_2 <- read_excel("Input/pacientes_2.xlsx")

## ¿En qué estructura están los datos? Respuesta: 
pacientes_1

## ¿Cómo podemos cambiar la estructura de los datos? ¿Tiene sentido en esta base?

pacientes_1 %>% 
  pivot_wider(names_from = Sexo,
              values_from = Peso)

## Tiene más sentido:
pacientes_1 %>%
  select(-id) %>% 
  pivot_wider(names_from = Sexo,
              values_from = Peso,
              names_prefix = "Peso_")

## Continuará ...





