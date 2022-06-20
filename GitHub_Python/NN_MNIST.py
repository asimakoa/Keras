
from keras import models
from keras import layers
from keras.datasets import mnist
import matplotlib.pyplot as plt
 

#network.model
#network.compile
#network.fit

#from datasets import mnist
(train_images,train_labels), (test_images, test_labels)=mnist.load_data()
print(train_images.ndim)
print(train_images.shape)

 #Build ur network
network=models.Sequential()
network.add(layers.Dense(512, activation='relu',input_shape=(28*28,)))
network.add(layers.Dropout(0.40))
network.add(layers.Dense(10,activation='softmax'))

 #compile your network ie specify optimizer & loss function
network.compile(optimizer='rmsprop', 
                loss='categorical_crossentropy',
                metrics=['accuracy'])

 #prepare your input data
train_images =train_images.reshape((60000,28*28))
print(train_images.shape)
train_images=train_images.astype('float32')/255
test_images =test_images.reshape((10000,28*28))
test_images=test_images.astype('float32')/255

 #prepare the labels
from keras.utils import to_categorical
train_labels=to_categorical(train_labels)
test_labels=to_categorical(test_labels)

 #train ur model
Nevroniko=network.fit(train_images,train_labels,epochs=20,batch_size=20000, verbose=1)

print(network.summary())

 #Use ur model
test_loss, test_acc=network.evaluate(test_images,test_labels)
print('test_acc:',test_acc)

 #print a digit from data set
#digit=train_images[5]
#plt.imshow(digit, cmap=plt.cm.binary)
#plt.show()

#print metrics
print(Nevroniko.history.keys())
plt.plot(Nevroniko.history['accuracy'])
plt.plot(Nevroniko.history['loss'])

plt.xlabel('epochs')
plt.ylabel("accuracy")
plt.title("pos ta pigame?")
plt.legend(['Acc', 'loss'], loc='upper left')


plt.show



