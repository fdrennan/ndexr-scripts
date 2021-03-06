rm(list = ls())
library(lightgbm)
library(tictoc)
data(agaricus.train, package = "lightgbm")
train <- agaricus.train
# train$data[, 1] <- 1:6513
dtrain <- lgb.Dataset(train$data, label = train$label)
data(agaricus.test, package = "lightgbm")
test <- agaricus.test
dtest <- lgb.Dataset.create.valid(dtrain, test$data, label = test$label)
valids <- list(test = dtest)

params <- list(objective = "regression",
               metric = "rmse",
               device = "gpu",
               gpu_platform_id = 0,
               gpu_device_id = 0,
               nthread = 1,
               boost_from_average = FALSE,
               num_tree_per_iteration = 10,
               max_bin = 32)
tic()
model <- lgb.train(params,
                   dtrain,
                   20000,
                   valids,
                   # min_data = 1,
                   learning_rate = .001,
                   early_stopping_rounds = 30, 
                   verbose = 1)
toc()

# > toc()
# 37.905 sec elapsed

