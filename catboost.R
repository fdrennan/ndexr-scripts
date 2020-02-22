library(catboost)
library(tidyverse)
dataset <- 
  read.table("/home/ubuntu/templates/processed.cleveland.data", sep = ",")
target <- dataset$V14 
label_values = if_else(target != 0, 1, 0)
dataset = dataset[colnames(dataset) != "V14"]


if(FALSE) {
  fit_params <- list(iterations = 100,
                     loss_function = 'Logloss',
                     task_type = 'GPU')
} else {
  fit_params <- list(iterations = 100,
                     loss_function = 'Logloss')
}

pool = catboost.load_pool(dataset, label = label_values)

model <- catboost.train(pool, params = fit_params)
