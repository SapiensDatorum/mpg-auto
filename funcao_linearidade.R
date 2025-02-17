# Carregar pacotes necessários
install_if_missing <- function(packages) {
  missing_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(missing_packages)) {
    install.packages(missing_packages)
  }
}

required_packages <- c("ggplot2", "dplyr")
install_if_missing(required_packages)
lapply(required_packages, library, character.only = TRUE)

# Função para processar os dados
criar_dataframe_ordenado <- function(df, coluna_numerica, coluna_categorica) {
  # Verificar se as colunas existem no dataframe
  if (!(coluna_numerica %in% colnames(df))) {
    stop(paste("Erro: A coluna numérica", coluna_numerica, "não existe no dataframe."))
  }
  
  if (!(coluna_categorica %in% colnames(df))) {
    stop(paste("Erro: A coluna categórica", coluna_categorica, "não existe no dataframe."))
  }
  
  # Criar um dataframe auxiliar contendo apenas as colunas informadas
  df_aux <- df[, c(coluna_numerica, coluna_categorica)]
  
  # Verificar se a primeira coluna é numérica
  if (!is.numeric(df_aux[[coluna_numerica]])) {
    stop(paste("Erro: A coluna", coluna_numerica, "não é numérica."))
  }
  
  # Ordenar o dataframe pela coluna numérica em ordem crescente
  df_aux <- df_aux[order(df_aux[[coluna_numerica]]), ]
  
  # Número total de observações
  n <- nrow(df_aux)
  
  # Tamanho de cada decil (aproximadamente 10% do total)
  tamanho_decil <- ceiling(n / 10)
  
  # Criar a coluna percentis atribuindo os números dos decis
  df_aux$percentis <- rep(1:10, each = tamanho_decil, length.out = n)
  
  # Converter a variável categórica para numérica (1 = 1, 0 = 0)
  df_aux[[coluna_categorica]] <- as.numeric(df_aux[[coluna_categorica]] == "1")
  
  # Agrupar por percentis e calcular estatísticas
  resumo <- df_aux %>%
    group_by(percentis) %>%
    summarise(
      frequencia_1 = sum(.data[[coluna_categorica]]), # Frequência de "1"
      media_valor = mean(.data[[coluna_numerica]], na.rm = TRUE)
    )
  
  # Imprimir a tabela resultante
  print(resumo)
  
  # Criar gráfico de dispersão média x percentis
  ggplot(resumo, aes(x = frequencia_1, y = media_valor)) +
    geom_point(color = "blue", size = 3) +
    geom_line(color = "red") +
    labs(title = "Média do Valor por Percentil", x = "Percentis (Decis)", y = "Média do Valor") +
    theme_minimal()
}

# Exemplo de uso
set.seed(123)
df_exemplo <- data.frame(
  ID = 1:237,  # Simulando 250 observações
  Categoria = sample(c("0", "1"), 237, replace = TRUE),  # "0" ou "1" como caracteres
  Valor = runif(237, min = 10, max = 100)  # Gera valores aleatórios entre 10 e 100
)

# Chamar a função
criar_dataframe_ordenado(df_exemplo, "Valor", "Categoria")
