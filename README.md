# Regressão Linear com Box‑Cox - Estudo de Caso com o Dataset Auto MPG

Este projeto apresenta uma análise completa do dataset *Auto MPG*, utilizando técnicas de modelagem de regressão linear para prever o consumo de combustível (mpg). Foram exploradas desde a leitura e tratamento dos dados, passando por uma análise exploratória (univariada e bivariada), até a aplicação da transformação Box‑Cox na variável resposta. Além disso, foi considerada uma abordagem alternativa com Análise de Componentes Principais (PCA) para contornar problemas de multicolinearidade.  

**Fonte de Dados: UCI Machine Learning Repository - Auto MPG Data** - https://archive.ics.uci.edu/ml/datasets/auto+mpg 

**Autor:** Rogério Coelho  
**Data:** 2025-02-11

---

## Sumário

- [Introdução](#introdução)
- [Descrição do Projeto](#descrição-do-projeto)
- [Dados](#dados)
- [Análise Exploratória](#análise-exploratória)
- [Diagnóstico e Transformação](#diagnóstico-e-transformação)
- [Modelagem](#modelagem)
- [Alternativa com PCA](#alternativa-com-pca)
- [Resultados e Conclusões](#resultados-e-conclusões)
- [Estrutura do Repositório](#estrutura-do-repositório)
- [Requisitos e Instalação](#requisitos-e-instalação)
- [Como Contribuir](#como-contribuir)
- [Licença](#licença)
- [Contato](#contato)

---

## Introdução

Na era dos dados, construir modelos preditivos robustos é essencial para a tomada de decisões fundamentadas. Este projeto demonstra como a aplicação de técnicas estatísticas, como a transformação Box‑Cox, pode melhorar a adequação de um modelo de regressão linear, estabilizando a variância dos resíduos e atendendo aos pressupostos necessários para uma análise confiável.

---

## Descrição do Projeto

O estudo tem como objetivo principal prever o consumo de combustível (mpg) em veículos, utilizando dados do dataset *Auto MPG*. Para isso, foram realizadas as seguintes etapas:

- **Leitura e Tratamento dos Dados:** Inclusão dos nomes das colunas, conversão dos tipos (variáveis numéricas e categóricas) e tratamento de valores ausentes (especialmente na variável *horsepower*).  
- **Análise Exploratória:** Geração de histogramas, boxplots e gráficos de dispersão para identificar distribuição, outliers e relações entre as variáveis.  
- **Diagnóstico Estatístico:** Avaliação de heterocedasticidade (por meio do teste Breusch‑Pagan) e multicolinearidade (utilizando análises de correlação e VIF).  
- **Transformação Box‑Cox:** Aplicação na variável resposta (*mpg*) para melhorar a normalidade dos resíduos e a efetividade do modelo.  
- **Modelagem:** Construção de modelos de regressão linear com seleção stepwise, comparando um modelo tradicional com um modelo alternativo baseado em PCA.  
- **Validacão dos Modelos:** Uso de métricas, como R², RMSE, MAE e MAPE, além de análise dos resíduos, para avaliar a qualidade dos modelos.

---

## Dados

O projeto utiliza o arquivo `auto-mpg.data`, contendo as seguintes variáveis:

- **mpg:** Milhas por galão (consumo de combustível)
- **cylinders, displacement, horsepower, weight, acceleration:** Características dos veículos
- **model_year, origin:** Informações sobre o ano e local de fabricação
- **car_name:** Nome completo do veículo, do qual foram extraídas as variáveis *marca* e *modelo*

Os dados foram limpos e transformados, convertendo variáveis categóricas e numéricas conforme a necessidade da análise.

---

## Análise Exploratória

A etapa de Análise Exploratória (EDA) incluiu:

- **Análise Univariada:** Geração de histogramas e boxplots para examinar a distribuição das variáveis numéricas.  

- **Análise Bivariada:** Criação de gráficos de dispersão (com jitter e boxplots) para avaliar a relação entre *mpg* e outras variáveis, como *cilinders* e *weight*.

- **Estudo das Variáveis Categóricas:** Análise de frequências e criação de gráficos para variáveis como *model_year*, *origin* e *marca*.

---

## Diagnóstico e Transformação

Durante o diagnóstico do modelo, foram identificados:

- **Heterocedasticidade:** Evidenciada pelos testes estatísticos e gráficos de resíduos, sinalizando uma variância não constante.  
- **Multicolinearidade:** Forte correlação entre variáveis (por exemplo, *horsepower*, *displacement* e *weight*) que pode comprometer a estabilidade do modelo.

Para contornar esses problemas, foi aplicada a **transformação Box‑Cox** na variável resposta (*mpg*), utilizando o lambda ótimo calculado com o pacote *car*:


---

## Modelagem

Com os dados transformados, o modelo de regressão linear foi construído e ajustado utilizando:

- **Seleção de Variáveis (Stepwise):** Procedimento iterativo para identificar os preditores mais significativos.  
- **Criação do Modelo:** Inclusão de variáveis como *weight*, *acceleration* e as dummies de *model_year*, com análise de indicadores como R², RMSE e testes de diagnóstico dos resíduos.


---

## Alternativa com PCA

Devido à multicolinearidade entre as variáveis, foi explorada uma abordagem alternativa com Análise de Componentes Principais (PCA). Essa técnica reduziu a dimensionalidade dos dados, combinando variáveis correlacionadas em componentes principais, os quais foram usados como preditores no modelo.  


---

## Resultados e Conclusões

- **Transformação Box‑Cox:** Contribuiu para a melhoria da normalidade dos resíduos e para a melhor adequação do modelo de regressão linear.
- **Modelo Tradicional vs. Modelo com PCA:**  
  - O modelo com PCA obteve métricas de ajuste surpreendentemente altas (ex.: R² ≈ 0.9997 e RMSE muito baixo), mas apresenta desafios na interpretação dos componentes.  
  - O modelo original, mesmo com bons indicadores de ajuste (R² ≈ 0.8846), apresentou evidências de heterocedasticidade pelos testes (p‑valor do Breusch‑Pagan < 0.05).
- **Conclusão Geral:** A combinação de técnicas de transformação e seleção de variáveis, aliada à utilização de métodos alternativos como o PCA, demonstrou ser eficaz para lidar com problemas comuns em modelagem preditiva, como heterocedasticidade e multicolinearidade.

---

## Estrutura do Repositório

├── README.md # Este arquivo
├── Regressao-Linear-BoxCox.pdf                   # Documento completo do estudo
├── auto-mpg.data # Dataset utilizado na análise
├── BoxCox.Rmd                                    # Código completo que gerou o documento pdf
└── Regressao_Linear_BoxCox.R 


