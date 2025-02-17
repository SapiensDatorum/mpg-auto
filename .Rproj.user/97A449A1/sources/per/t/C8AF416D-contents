# Lista de pacotes necessários
packages <- c(
  "tidyverse",       # Inclui ggplot2, dplyr, tidyr, readr, readxl, haven, etc.
  "effects",         # Para efeitos marginais e gráficos
  "gridExtra",       # Para organizar múltiplos gráficos
  "broom",           # Para limpar resultados de modelos
  "kableExtra",      # Para tabelas formatadas
  "pROC",            # Para curvas ROC e análise de classificação
  "caret",           # Para machine learning e validação de modelos
  "MASS",            # Para análise estatística avançada
  "pscl",            # Para modelos de regressão especializados
  "lmtest",          # Para testes de hipóteses em modelos lineares
  "openxlsx",        # Para leitura/escrita de arquivos Excel
  "yardstick",       # Para métricas de avaliação de modelos
  "car",             # Para diagnóstico de regressão
  "ggraph",          # Para gráficos de redes e grafos
  "plotly",          # Para gráficos interativos
  "ggstance",        # Para gráficos ggplot2 com orientação horizontal
  "olsrr",           # Para análise de regressão linear
  "PerformanceAnalytics", # Para análise de desempenho financeiro/estatístico
  "correlation"      # Para análise de correlação
)
# Verifica se os pacotes estão instalados, e instala se necessário
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
  library(pkg, character.only = TRUE)
}

# Aplicando a função para cada pacote da lista
lapply(packages, install_if_missing)

df_auto <- read.table("auto-mpg.data", quote="\"", comment.char="")
df <- df_auto

#  1. mpg:           continuous
#  2. cylinders:     multi-valued discrete
#  3. displacement:  continuous
#  4. horsepower:    continuous
#  5. weight:        continuous
#  6. acceleration:  continuous
#  7. model year:    multi-valued discrete
#  8. origin:        multi-valued discrete
#  9. car name:      string (unique for each instance)

# Renomeando as colunas
colnames(df_auto) <- c("mpg", "cylinders", "displacement", "horsepower", 
                       "weight", "acceleration", "model_year", "origin", "car_name")

# Definindo as colunas numéricas e categóricas
colunas_num <- c("mpg", "displacement", "horsepower", "weight", "acceleration")
colunas_categoricas <- c("cylinders", "model_year", "origin", "car_name")

# Convertendo colunas categóricas
df_auto[colunas_categoricas] <- lapply(df_auto[colunas_categoricas], as.factor)

# Usando lapply para converter as variáveis
df_auto[colunas_num] <- lapply(df_auto[colunas_num], as.numeric) 
# Usando lapply para converter as variáveis
df_auto[colunas_categoricas] <- lapply(df_auto[colunas_categoricas], as.factor)

summary(df_auto)
str(df_auto)

# Usando lapply para gerar os histogramas
#lapply(colunas_num, function(col) {
#  hist(df_auto[[col]], main = paste("Histograma de", col), xlab = col, col = "lightblue", border = "black")
#})
# Usando lapply para gerar os histogramas com informações no topo das colunas
lapply(colunas_num, function(col) {
  # Gerando o histograma e armazenando o objeto
  h <- hist(df_auto[[col]], main = paste("Histograma de", col), 
            xlab = col, col = "lightblue", border = "black", plot = FALSE)
  
  # Desenhando o histograma
  hist(df_auto[[col]], main = paste("Histograma de", col), 
       xlab = col, col = "lightblue", border = "black")
  
  # Adicionando as informações no topo das colunas
  text(h$mids, h$counts, labels = h$counts, pos = 3, cex = 0.8, col = "red")  # Mostra os counts
  text(h$mids, h$density, labels = round(h$density, 2), pos = 1, cex = 0.8, col = "blue")  # Mostra a densidade
})

# Usando lapply para gerar os boxplots
#lapply(colunas_num, function(col) {
#  boxplot(df_auto[[col]], main = paste("Boxplot de", col), xlab = col, col = "lightblue", border = "black")
#})
# Usando lapply para gerar os boxplots com informações de quartis e outros dados
invisible(lapply(colunas_num, function(col) {
  # Calculando as estatísticas do boxplot
  box_stats <- boxplot(df_auto[[col]], plot = FALSE)
  
  # Gerando o boxplot
  boxplot(df_auto[[col]], main = paste("Boxplot de", col), 
          ylab = col, col = "lightblue", border = "black")
  
  # Adicionando as informações no gráfico
  # Exibindo o mínimo, Q1, mediana, Q3, e máximo
  text(1, box_stats$stats[1], labels = paste("Mínimo: ", round(box_stats$stats[1], 2)), pos = 3, cex = 0.8, col = "red")
  text(1, box_stats$stats[2], labels = paste("Q1: ", round(box_stats$stats[2], 2)), pos = 3, cex = 0.8, col = "blue")
  text(1, box_stats$stats[3], labels = paste("Mediana: ", round(box_stats$stats[3], 2)), pos = 3, cex = 0.8, col = "black")
  text(1, box_stats$stats[4], labels = paste("Q3: ", round(box_stats$stats[4], 2)), pos = 3, cex = 0.8, col = "blue")
  text(1, box_stats$stats[5], labels = paste("Máximo: ", round(box_stats$stats[5], 2)), pos = 3, cex = 0.8, col = "red")
}))

# Usando um loop for para gerar os resumos das colunas numéricas com seus nomes
for (col in colunas_num) {
  cat("\nResumo da coluna:", col, "\n")  # Exibe o nome da coluna
  print(summary(df_auto[[col]]))  # Exibe o resumo estatístico da coluna
}

#df_auto$cylinders <- as.character(df_auto$cylinders)
df_auto$cylinders <- as.numeric(df_auto$cylinders)
df_auto <- df_auto %>%
  separate(car_name, into = c("marca", "modelo"), sep = " ", extra = "merge") %>%
  mutate(marca = as.factor(marca), modelo = as.factor(modelo))
summary(df_auto)

library(ggplot2)
library(FactoMineR)
library(factoextra)

# Selecionar as variáveis de interesse
df_pca <- df_auto[, c("horsepower", "mpg", "cylinders", "displacement", "weight", "acceleration")]

# Remover linhas com valores ausentes (se necessário)
df_pca <- na.omit(df_pca)

# Padronizar as variáveis (opcional, mas recomendado)
df_pca <- scale(df_pca)

# Aplicar a PCA
pca_result <- prcomp(df_pca, scale = TRUE)

# Resumo dos resultados
summary(pca_result)

# Gráfico de scree plot
fviz_eig(pca_result)

# Gráfico das variáveis
fviz_pca_var(pca_result, col.var = "contrib", gradient.cols = c("blue", "yellow", "red"), repel = TRUE)

# Gráfico dos indivíduos
fviz_pca_ind(pca_result, col.ind = "cos2", gradient.cols = c("blue", "yellow", "red"), repel = TRUE)

analise_correl <- select(df_auto,mpg, horsepower, cylinders, displacement, weight, acceleration)
chart.Correlation((analise_correl),histogram=TRUE)

#análise do volume das categorias das variáveis categóricas
#==========================================================
dados <- df_auto$model_year
frequencias <- table(dados)
barplot(
  frequencias,
  main = "Distribuição do Ano do Modelo",
  xlab = "Categorias",
  ylab = "Frequência",
  col = "grey",
  border = "black"
)


############### criação do modelo

df_auto_modelo <- df_auto %>%
  select(mpg, weight, acceleration, model_year)
# Remover linhas com valores ausentes (se necessário)
df_auto_modelo <- na.omit(df_auto_modelo)
df_auto_modelo$weight <- df_auto_modelo$weight / 1000
# Calcula o lambda ótimo usando powerTransform (modelo sem covariáveis: mpg ~ 1)
lambda <- powerTransform(mpg ~ 1, data = df_auto_modelo)
print(summary(lambda))  # Verifique o resultado e o valor de lambda

# Extrai o lambda ótimo
lambda_opt <- lambda$lambda
cat("Lambda ótimo:", lambda_opt, "\n")

# Aplica a transformação Box-Cox na variável mpg usando bcPower
df_auto_modelo$mpg_boxcox <- bcPower(df_auto_modelo$mpg, lambda_opt)

# Criar variáveis dummy para as variáveis categóricas
df_auto_modelo <- df_auto_modelo %>%
  select(mpg_boxcox, weight, acceleration, model_year)

#reordenando para remover a dummy de maior volume
# Reordenando os níveis para escolher a referência manualmente
df_auto_modelo$model_year <- factor(df_auto_modelo$model_year, levels = c("73", "70", "71", "72", "74", "75", "76", "77", "78", "79", "80", "81", "82"))

# Criar variáveis dummy removendo uma categoria de referência automaticamente
df_auto_modelo_dummies <- df_auto_modelo %>%
  model.matrix(~ . , data = .) %>%  # Mantém a interceptação, eliminando um grau de liberdade por variável categórica
  as.data.frame()

# Remover a coluna da interceptação
df_auto_modelo_dummies <- df_auto_modelo_dummies %>% select(-`(Intercept)`)

#modelo nulo
lm_mpg_nulo <- lm(mpg_boxcox ~ 1, data=df_auto_modelo_dummies) # modelo nulo corresponde a estimar beta zero = Y_barra = chute média
summary(lm_mpg_nulo) 

lm_mpg_full <- lm(mpg_boxcox ~ weight + acceleration + model_year70 + model_year71 + model_year72 + 
                    model_year74 + model_year75 + model_year76 + model_year77 + model_year78 + 
                    model_year79 + model_year80 + model_year81 + model_year82, data = df_auto_modelo_dummies) # modelo com todas as variáveis
summary(lm_mpg_full)

# Step partindo do modelo nulo até o modelo completo
forw <- step(lm_mpg_nulo, scope=list(lower=lm_mpg_nulo, upper=lm_mpg_full), direction = "forward")
summary(forw)  

# melhor AIC
lm_mpg_aic <- lm(mpg_boxcox ~ weight + model_year80 + model_year82 + 
                   model_year81 + model_year79 + model_year78 + model_year77 + 
                   model_year76 + model_year74 + model_year75 + model_year71 + 
                   acceleration, data = df_auto_modelo_dummies)
summary(lm_mpg_aic)

ols_vif_tol(lm_mpg_aic)

mean_residuos <- mean(residuals(lm_mpg_aic))
print(mean_residuos) # Deve ser próximo de 0

hist(residuals(lm_mpg_aic), main = "Histograma dos Resíduos", xlab = "Resíduos")

# Teste de normalidade (Shapiro-Wilk)
resultado <- shapiro.test(residuals(lm_mpg_aic))
print(resultado$p.value)
# Não passou no teste de normalidade p-valor > 0.05 

# Verificar usando o teste de normalidade do KolmogorovSmirnov

residuos <- residuals(lm_mpg_aic)
media_residuos <- mean(residuos)
desvio_residuos <- sd(residuos)

# Realiza o teste de Kolmogorov-Smirnov para verificar a normalidade
ks_test <- ks.test(residuos, "pnorm", mean = media_residuos, sd = desvio_residuos)

# Exibe o resultado do teste
print(ks_test)

# Teste mais robusto e também não passou no teste, indicando que os resíduos
# não seguem um distribuição normal.

qqnorm(residuals(lm_mpg_aic), main = "QQ Plot dos Resíduos")
qqline(residuals(lm_mpg_aic), col = "red")

# gráfico dos resíduos padronizados
residuos_padronizados <- rstandard(lm_mpg_aic)
plot(residuos_padronizados, main = "Resíduos Padronizados", ylab = "Resíduos Padronizados")
abline(h = c(-3, 3), col = "red") # Limites para outliers

library(lmtest)
bptest(lm_precos_aic)


mse <- mean(residuals(lm_precos_aic)^2)
print(mse)

rmse <- sqrt(mse)
print(rmse)


# Qualidade e Acurácia dos modelos


