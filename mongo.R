# https://github.com/fdrennan/drenr_aws/blob/master/pages/html_files/2018-02-13-setting-up-mongodb-with-r-on-aws.Rmd
# use admin
# db.createUser(
#   {
#     user: "mongo",
#     pwd: "password",
#     roles: [ "root" ]
#   }
# )
# sudo vim /etc/mongod.conf
# sudo service mongod stop
# sudo service mongod start
library(mongolite)
system('sudo service mongod start')
user_name = "mongo"
password = "password"
host_name = "YOUR IP ABOVE6" # ^^ whatever your ip is up there

url  <-
  paste0("mongodb://", 
         user_name, ":", 
         password,  "@", 
         host_name, ":27017")

m <- 
  mongo(db         = "mymongodb", 
        collection = 'mtcars',
        url        = url)

m$insert(mtcars)

mtcars_mongo <-  m$find()

m$drop()

m$find()

system('sudo service mongod stop')
