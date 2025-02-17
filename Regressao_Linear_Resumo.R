  library(readr)
  library(openxlsx) #biblioteca para escrever arquivo em excel
  library(haven)
  library(readxl)
  library(tidyverse)
  library(yardstick) #biblioteca para calcular medidas de erro
  library(lmtest) # calcula o teste de homogeneidade de variancia
  library(car) # calcula vif
  library(ggraph)
  library(plotly)
  library(ggstance)
  library(jtools)
  library(olsrr)
  library(PerformanceAnalytics)
  library(correlation)
  library(dplyr)
  
  precos <- readRDS("~/Documentos/ASN.Rocks/Regressão Linear Resumo/precos.rds")
  precos_novo <- precos
  precos_living <- precos
  summary(precos)
  

  ########## trabalhando com a área total do imóvel (evitando os zeros das áreas dos imóveis)
  summary(precos_novo)
  
  precos_novo <- precos_novo %>%
    mutate(area_total = Basement_Area + Lot_Area + Gr_Liv_Area + Garage_Area + Deck_Porch_Area) %>%
    select(SalePrice, area_total, Age_Sold, Bedroom_AbvGr, Total_Bathroom,Heating_QC, Season_Sold)
  
  precos_novo$Heating_QC <- factor(precos_novo$Heating_QC)
  precos_novo$Season_Sold <- factor(precos_novo$Season_Sold)
  
  lambda <- 
  
  precos_novo$SalePrice <- log(precos_novo$SalePrice)
  precos_novo$area_total <- log(precos_novo$area_total)
  summary(precos_novo)
  
  analise_correl_precos <- select(precos_novo,SalePrice,area_total,Age_Sold,Bedroom_AbvGr,Total_Bathroom)
  chart.Correlation((analise_correl_precos),histogram=TRUE)
  
  ggplotly(
    ggplot(precos_novo, aes(x=log(area_total), y=log(SalePrice))) +
      geom_point()
  )
  hist(precos_novo$area_total)
  hist(precos_novo$SalePrice)
  
  #análise do volume das categorias das variáveis categóricas
  #==========================================================
  dados <- precos_novo$Heating_QC
  frequencias <- table(dados)
  barplot(
    frequencias,
    main = "Distribuição das Categorias",
    xlab = "Categorias",
    ylab = "Frequência",
    col = "grey",
    border = "black"
  )

  # Agrupar categorias com fct_collapse
  precos_novo$heating_agrupada <- fct_collapse(
    precos_novo$Heating_QC,
    FAGdPo = c("Fa", "Gd", "Po"), # Agrupar "FA", "Gd", "Po" em "Outros"
    TA = "TA",                    # Manter "TA"
    Ex = "Ex"                     # Manter "Ex"
  )

  #análise do volume das categorias das variáveis categóricas
  dados <- precos_novo$heating_agrupada
  frequencias <- table(dados)
  barplot(
    frequencias,
    main = "Distribuição das Categorias",
    xlab = "Categorias",
    ylab = "Frequência",
    col = "grey",
    border = "black"
  )
  
#======================================== Season Sold
  dados <- precos_novo$Season_Sold
  frequencias <- table(dados)
  barplot(
    frequencias,
    main = "Distribuição das Categorias",
    xlab = "Categorias",
    ylab = "Frequência",
    col = "grey",
    border = "black"
  )
  
  # Agrupar categorias com fct_collapse
  precos_novo$season_agrupada <- fct_collapse(
    precos_novo$Season_Sold,
    v1e4 = c("1", "4"),          # Agrupar "1 e 4"
    v2 = "2",                    # Manter "2"
    v3 = "3"                     # Manter "3"
  )
  
  #análise do volume das categorias das variáveis categóricas
  dados <- precos_novo$season_agrupada
  frequencias <- table(dados)
  barplot(
    frequencias,
    main = "Distribuição das Categorias",
    xlab = "Categorias",
    ylab = "Frequência",
    col = "grey",
    border = "black"
  )
  
  # Criar variáveis dummy para as variáveis categóricas
  precos_novo <- precos_novo %>%
    select(SalePrice, area_total, Age_Sold, Bedroom_AbvGr, Total_Bathroom,heating_agrupada, season_agrupada)
  
  #reordenando para remover a dummy de maior volume
  # Reordenando os níveis para escolher a referência manualmente
  precos_novo$heating_agrupada <- factor(precos_novo$heating_agrupada, levels = c("Ex", "FAGdPo", "TA"))
  precos_novo$season_agrupada <- factor(precos_novo$season_agrupada, levels = c("v3", "v2", "v1e4"))
  
  # Criar variáveis dummy removendo uma categoria de referência automaticamente
  precos_dummies <- precos_novo %>%
    model.matrix(~ . , data = .) %>%  # Mantém a interceptação, eliminando um grau de liberdade por variável categórica
    as.data.frame()
  
  # Remover a coluna da interceptação
  precos_dummies <- precos_dummies %>% select(-`(Intercept)`)

  #modelo nulo
  lm_precos_nulo <- lm(SalePrice ~ 1, data=precos_dummies) # modelo nulo corresponde a estimar beta zero = Y_barra = chute média
  summary(lm_precos_nulo) 
  
  lm_precos_full <- lm(SalePrice ~ area_total + Age_Sold + Bedroom_AbvGr + Total_Bathroom + heating_agrupadaFAGdPo + heating_agrupadaTA + season_agrupadav2 + season_agrupadav1e4, data=precos_dummies) # modelo com todas as variáveis
  summary(lm_precos_full)
  
  # Step partindo do modelo nulo até o modelo completo
  forw <- step(lm_precos_nulo, scope=list(lower=lm_precos_nulo, upper=lm_precos_full), direction = "forward")
  summary(forw)  
  
  # melhor AIC
  lm_precos_aic <- lm(SalePrice ~ Total_Bathroom + Age_Sold + area_total + heating_agrupadaTA + heating_agrupadaFAGdPo + Bedroom_AbvGr, data=precos_dummies)
  summary(lm_precos_aic)
  
  ols_vif_tol(lm_precos_aic)
  
  mean_residuos <- mean(residuals(lm_precos_aic))
  print(mean_residuos) # Deve ser próximo de 0
  
  hist(residuals(lm_precos_aic), main = "Histograma dos Resíduos", xlab = "Resíduos")
  
  # Teste de normalidade (Shapiro-Wilk)
  resultado <- shapiro.test(residuals(lm_precos_aic))
  print(resultado$p.value)
  
  qqnorm(residuals(lm_precos_aic), main = "QQ Plot dos Resíduos")
  qqline(residuals(lm_precos_aic), col = "red")
  
  # gráfico dos resíduos padronizados
  residuos_padronizados <- rstandard(lm_precos_aic)
  plot(residuos_padronizados, main = "Resíduos Padronizados", ylab = "Resíduos Padronizados")
  abline(h = c(-3, 3), col = "red") # Limites para outliers
  
  library(lmtest)
  bptest(lm_precos_aic)

  
  mse <- mean(residuals(lm_precos_aic)^2)
  print(mse)
  
  rmse <- sqrt(mse)
  print(rmse)
  
  library(car)
  leveneTest(residuals(lm_precos_aic) ~ fitted(lm_precos_aic))
  
  bartlett.test(residuals(lm_precos_aic) ~ fitted(lm_precos_aic))
  