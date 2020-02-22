library(sparklyr)
library(biggr)
library(reticulate)
# install_python(envname = 'biggr')
use_virtualenv('biggr')

# configure_aws(
#   aws_access_key_id     = "XXX",
#   aws_secret_access_key = "XXX",
#   default.region        = "us-east-2"
# )

spark_master_data <-
  spark_master(InstanceType = 't2.large',
               KeyName = "Shiny",
               SecurityGroupId = 'sg-0e8841d7a144aa628',
               InstanceStorage = 50)

spark_slave(InstanceType = 't2.large',
            KeyName = "Shiny",
            SecurityGroupId = 'sg-0e8841d7a144aa628',
            InstanceStorage = 50,
            master_ip = "18.221.178.253",
            n_instances = 5)

# spark-2.1.0-bin-hadoop2.7/sbin/start-master.sh
# spark-2.1.0-bin-hadoop2.7/sbin/start-slave.sh 18.221.178.253:7077
# spark-2.1.0-bin-hadoop2.7/sbin/stop-slave.sh


conf <- spark_config()
conf$spark.executor.memory <- "2GB"
conf$spark.memory.fraction <- 0.9

sc <- spark_connect(master="spark://ip-172-31-14-0.us-east-2.compute.internal:7077",
                    version = "2.1.0",
                    config = conf,
                    spark_home = "/home/ubuntu/spark-2.1.0-bin-hadoop2.7/")


library(ggplot2)
library(dplyr)
library(tictoc)
library(nycflights13)

iris_tbl <- copy_to(sc, iris, "iris", overwrite = TRUE)
iris_tbl

flights_tbs <- copy_to(sc, flights, "flights", overwrite = TRUE)
tic()
flights_tbs %>%
  group_by(year, month, day) %>%
  count
toc()
if(TRUE) {
  
  kmeans_model <-
    iris_tbl %>%
    ml_kmeans(formula= ~ Petal_Width + Petal_Length, k = 3)
  
  predicted <- ml_predict(kmeans_model, iris_tbl) %>%
    collect
  
  table(predicted$Species, predicted$prediction)
  
  ml_predict(kmeans_model) %>%
    collect() %>%
    ggplot(aes(Petal_Length, Petal_Width)) +
    geom_point(aes(Petal_Width, Petal_Length, col = factor(prediction + 1)),
               size = 2, alpha = 0.5) +
    geom_point(data = kmeans_model$centers, aes(Petal_Width, Petal_Length),
               col = scales::muted(c("red", "green", "blue")),
               pch = 'x', size = 12) +
    scale_color_discrete(name = "Predicted Cluster",
                         labels = paste("Cluster", 1:3)) +
    labs(
      x = "Petal Length",
      y = "Petal Width",
      title = "K-Means Clustering",
      subtitle = "Use Spark.ML to predict cluster membership with the iris dataset."
    )
}


if (TRUE) {
  lm_model <- iris_tbl %>%
    select(Petal_Width, Petal_Length) %>%
    ml_linear_regression(Petal_Length ~ Petal_Width)
  
  iris_tbl %>%
    select(Petal_Width, Petal_Length) %>%
    collect %>%
    ggplot(aes(Petal_Length, Petal_Width)) +
    geom_point(aes(Petal_Width, Petal_Length), size = 2, alpha = 0.5) +
    geom_abline(aes(slope = coef(lm_model)[["Petal_Width"]],
                    intercept = coef(lm_model)[["(Intercept)"]]),
                color = "red") +
    labs(
      x = "Petal Width",
      y = "Petal Length",
      title = "Linear Regression: Petal Length ~ Petal Width",
      subtitle = "Use Spark.ML linear regression to predict petal length as a function of petal width."
    )
}

if (TRUE) {
  # Prepare beaver dataset
  beaver <- beaver2
  beaver$activ <- factor(beaver$activ, labels = c("Non-Active", "Active"))
  copy_to(sc, beaver, "beaver")
  
  beaver_tbl <- tbl(sc, "beaver")
  
  glm_model <- beaver_tbl %>%
    mutate(binary_response = as.numeric(activ == "Active")) %>%
    ml_logistic_regression(binary_response ~ temp)
  
  glm_model
}
6
It's'
