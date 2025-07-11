#Dibujar modelo no lineal sigmoidal

```{r}
library(nlme)
modelo_sigmoidal <- nls(
  formula = peso_perdido ~ exp(a + b / dias),
  data    = df,
  start   = list(a = 1, b = 1)
)
tidy(modelo_sigmoidal) |> 
  kable()

aug <- augment(modelo_sigmoidal, newdata = df)

rmse(aug, truth = peso_perdido, estimate = .fitted)
rsq(aug, truth = peso_perdido, estimate = .fitted)

library(ggplot2)
grid <- tibble(dias = seq(min(df$dias), max(df$dias), length.out = 200)) |>
  bind_cols(.pred = predict(modelo_sigmoidal, newdata = grid))

ggplot(df, aes(dias, peso_perdido)) +
  geom_point(alpha = 0.4) +
  geom_line(data = grid, aes(dias, .pred), size = 1) +
  labs(title = "Fit of peso_perdido = exp(a + b/dias) via nls", y = "peso_perdido", x = "dias")
```