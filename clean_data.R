library(data.table)

train_data <- fread('~/Desktop/adulting/data/raw/adult.data.csv')
test_data <- fread('~/Desktop/adulting/data/raw/adult.test.csv', skip = 1)

# convert to data frame b/c I'm noob and don't know much about data table
train_data <- data.frame(train_data)
test_data <- data.frame(test_data)

# add column names
column_names <- c('age', 'workclass', 'fnlwgt', 'education', 'educationNum', 
                  'maritalStatus', 'occupation', 'relationship', 'race', 'sex', 
                  'capitalGain', 'captialLoss', 'hoursPerWeek', 'nativeCountry',
                  'response')
colnames(train_data) <- column_names
colnames(test_data) <- column_names

# convert categorical columns to factor
factor_columns <- c('workclass', 'maritalStatus', 'occupation', 'relationship',
                    'race', 'sex', 'nativeCountry', 'response')
for(var in factor_columns) {
  train_data[, var] <- factor(train_data[, var])
  test_data[, var] <- factor(test_data[, var])
}

# remove education b/c we already have educationNum
# remove fnlwgt b/c we don't care about sampling weight for now
train_data <- train_data[, !colnames(train_data) %in% c('education', 'fnlwgt')]
test_data <- test_data[, !colnames(test_data) %in% c('education', 'fnlwgt')]

# clean workclass
train_data$workclass <- as.character(train_data$workclass)
train_data$workclass[train_data$workclass == '?'] <- NA
train_data$workclass[train_data$workclass %in% 
                       c('Never-worked', 'Without-pay')] <- 'Other'
train_data$workclass <- factor(train_data$workclass)
test_data$workclass <- as.character(test_data$workclass)
test_data$workclass[test_data$workclass == '?'] <- NA
test_data$workclass[test_data$workclass %in% 
                       c('Never-worked', 'Without-pay')] <- 'Other'
test_data$workclass <- factor(test_data$workclass)

# clean occupation
train_data$occupation[train_data$occupation == '?'] <- NA
train_data$occupation[train_data$occupation == 'Armed-Forces'] <- 'Other-service'
train_data$occupation <- factor(train_data$occupation)
test_data$occupation[test_data$occupation == '?'] <- NA
test_data$occupation[test_data$occupation == 'Armed-Forces'] <- 'Other-service'
test_data$occupation <- factor(test_data$occupation)

# clean nativeCountry
train_data$nativeCountry <- as.character(train_data$nativeCountry)
train_data$nativeCountry[train_data$nativeCountry == '?'] <- NA
train_data$nativeCountry[train_data$nativeCountry %in% 
                           c('Cambodia', 'Laos', 'Outlying-US(Guam-USVI-etc)',
                             'Thailand')] <- 'Asia Other'
train_data$nativeCountry[train_data$nativeCountry %in% 
                           c('Ecuador', 'Peru')] <- 'South America Other'
train_data$nativeCountry[train_data$nativeCountry %in% 
                           c('France', 'Greece', 'Holand-Netherlands', 
                             'Hungary', 'Ireland', 'Portugal', 'Scotland', 
                             'Yugoslavia')] <- 'Europe Other'
train_data$nativeCountry[train_data$nativeCountry %in% 
                           c('Haiti', 'Honduras', 'Nicaragua', 
                             'Trinadad&Tobago')] <- 'Central America Other'
train_data$nativeCountry[train_data$nativeCountry %in% 
                           c('Hong')] <- 'China'
train_data$nativeCountry <- factor(train_data$nativeCountry)

test_data$nativeCountry <- as.character(test_data$nativeCountry)
test_data$nativeCountry[test_data$nativeCountry == '?'] <- NA
test_data$nativeCountry[test_data$nativeCountry %in% 
                          c('Cambodia', 'Laos', 'Outlying-US(Guam-USVI-etc)',
                            'Thailand')] <- 'Asia Other'
test_data$nativeCountry[test_data$nativeCountry %in% 
                          c('Ecuador', 'Peru')] <- 'South America Other'
test_data$nativeCountry[test_data$nativeCountry %in% 
                          c('France', 'Greece', 'Holand-Netherlands', 
                            'Hungary', 'Ireland', 'Portugal', 'Scotland', 
                            'Yugoslavia')] <- 'Europe Other'
test_data$nativeCountry[test_data$nativeCountry %in% 
                          c('Haiti', 'Honduras', 'Nicaragua', 
                            'Trinadad&Tobago')] <- 'Central America Other'
test_data$nativeCountry[test_data$nativeCountry %in% 
                          c('Hong')] <- 'China'
test_data$nativeCountry <- factor(test_data$nativeCountry)

# convert response from categorical to numeric
train_data$response <- as.numeric(train_data$response) - 1
test_data$response <- as.numeric(test_data$response) - 1

summary(train_data)
summary(test_data)

# convert train and test data to matrix and extract response vector
options('na.action' = na.omit)
train_x <- model.matrix(response ~ ., train_data)[, -1] # exclude intercept
train_response <- train_data$response[rownames(train_x)]
test_x <- model.matrix(response ~ ., test_data)[, -1]
test_response <- test_data$response[rownames(test_x)]

write.csv(train_x, file = '~/Desktop/adulting/data/cleaned/train_x.csv', 
          row.names = FALSE)
write.csv(train_response, 
          file = '~/Desktop/adulting/data/cleaned/train_response.csv', 
          row.names = FALSE)
write.csv(test_x, file = '~/Desktop/adulting/data/cleaned/test_x.csv', 
          row.names = FALSE)
write.csv(test_response, 
          file = '~/Desktop/adulting/data/cleaned/test_response.csv', 
          row.names = FALSE)