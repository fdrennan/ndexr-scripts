library(RPostgreSQL)
library(tidyverse)
library(dbplyr)
library(DBI)

public_ip = "drenr.com" # ^^ your ip above
# https://dba.stackexchange.com/questions/31210/preventing-postgresql-from-starting-on-boot-in-ubuntu
# system('sudo /usr/bin/pg_ctlcluster 9.5 main start')
con <- dbConnect(PostgreSQL(),
                 dbname   = 'public',
                 host     = public_ip,
                 port     = 5432,
                 user     = "postgres",
                 password = "Rockies23")




dbWriteTable(con, 'flights', nycflights13::flights, append = TRUE)
dbWriteTable(con, 'mtcars', mtcars, append = TRUE)
dbWriteTable(con, 'iris', iris, append = TRUE)
mtcars_data <-
  tbl(con, in_schema('public', 'mtcars'))

mtcars_data %>% 
  group_by(cyl) %>% 
  summarise(mpg = mean(mpg)) %>% 
  collect

db_drop_table(con, 'mtcars', force = TRUE)

system('sudo pg_ctlcluster 9.5 main stop')
