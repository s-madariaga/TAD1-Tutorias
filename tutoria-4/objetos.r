
# Un número
number <- 1

# Un vector
colores <- c("rojo", "azul", "verde")

# Un modelo de regresión simple
mi_modelo <- lm(Sepal.Length~Sepal.Width, data = iris)

# Un gráfico
mi_plot <- iris %>% 
  ggplot() + aes(x = Sepal.Length, y = Sepal.Width, 
                 color = Species, shape = Species) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Largo del sepal",
    y = "Ancho del sepal",
    color = "Especies",
    shape = "Especies",
    title = "Relación entre el largo y ancho del sepal",
    subtitle = "(relación del ancho y largo del sepal en mm)"
  ) +
  theme(
    plot.title = element_text(face = "bold"),
    text = element_text(size = 15),
    axis.title = element_text(color = "grey50", size = 13, 
                              face = "italic", hjust = 1),
    legend.title = element_text(face = "bold", size = 13)
  )


# Guardamos todo en un archvio ".RData"
save(colores, mi_modelo, mi_plot, number, file = "input/objetos.RData")




