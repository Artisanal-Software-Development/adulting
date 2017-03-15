from keras.models import Sequential
from keras.layers import Dense, Activation
import numpy

# fix random seed for reproducibility
seed = 8
numpy.random.seed(seed)

# load pima indians dataset
train_x = numpy.loadtxt('data/cleaned/train_x.csv', delimiter=",", skiprows=1)
train_response = numpy.loadtxt('data/cleaned/train_response.csv', delimiter=",", skiprows=1)
test_x = numpy.loadtxt('data/cleaned/test_x.csv', delimiter=",", skiprows=1)
test_response = numpy.loadtxt('data/cleaned/test_response.csv', delimiter=",", skiprows=1)

# create model
model = Sequential()
model.add(Dense(12, input_dim=8, init='uniform', activation='relu'))
model.add(Dense(8, init='uniform', activation='relu'))
model.add(Dense(1, init='uniform', activation='sigmoid'))

# Compile model
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])              

# Fit the model
model.fit(train_x, train_response, nb_epoch=150, batch_size=10)

# evaluate the model
scores = model.evaluate(train_x, train_response)
print("%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))

# calculate predictions
predictions = model.predict(test_x)

# round predictions
rounded = [round(x[0]) for x in predictions]
print(rounded)

if __name__ == "__main__":
  print(prediction)


