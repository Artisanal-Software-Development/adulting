library(data.table)

train_data <- fread('~/Desktop/adulting/data/adult.data.csv')
test_data <- fread('~/Desktop/adulting/data/adult.test.csv', skip = 1)
summary(train_data)
summary(test_data)
