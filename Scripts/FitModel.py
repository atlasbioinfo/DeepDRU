'''
usage: python FitModel.py TrainSet DevSet TrainingProcessOutput ModelSave
eg:	   python FitModel.py Train0 Dev0 modelOutLayer5Group0 Layer5Group0.tf
	   
TrainSet: Training set, Train0-9
DevSet: Development set, Dev0-9
TrainingProcessOutput: The accuracy and loss of each epoch during the model training 
						process will be output to this file.
ModelSave: 	Save final model file.
'''

# Notice!!! The version of Tensorflow should be >=1.00 !!!

import fileinput
import numpy as np
import sys
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense,Activation,BatchNormalization
from tensorflow.keras.callbacks import EarlyStopping,Callback
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.utils import to_categorical

class GetACCHistory(Callback):
    def on_train_begin(self, logs=None):
        self.loss=[]
        self.acc=[]
        self.val_acc=[]
        self.val_loss=[]

    def on_epoch_end(self, epoch, logs=None):
        self.acc.append(logs.get("acc"))
        self.loss.append(logs.get("loss"))
        self.val_acc.append(logs.get("val_acc"))
        self.val_loss.append(logs.get("val_loss"))

x=[]
y=[]
xtest=[]
ytest=[]
for line in fileinput.input(sys.argv[1]):
    tmp=line.strip().split("\t")
    y.append(tmp[3])
    x.append(tmp[4:])

for line in fileinput.input(sys.argv[2]):
    tmp=line.strip().split("\t")
    ytest.append(tmp[3])
    xtest.append(tmp[4:])

x=np.array(x)
y=np.array(y)
xtest=np.array(xtest)
ytest=np.array(ytest)

model=Sequential()
model.add(Dense(6,input_dim=6,activation=tf.nn.relu))

for i in range(1,6):
    model.add(Dense(256,activation=tf.nn.relu))
    model.add(BatchNormalization())

model.add(Dense(1,activation=tf.nn.sigmoid))

adam=Adam(lr=0.005)

# 

earlyStop=EarlyStopping(monitor='acc',patience=100,mode='max')
history=GetACCHistory()

model.compile(optimizer=adam,loss='binary_crossentropy',metrics=['accuracy'])

# If you use CPU, you can decrease the batch size to improve efficiency. 
# Recommended batch for GPU >= 1024, CPU <=512

model.fit(x,y,batch_size=2048,epochs=100000,callbacks=[history,earlyStop],verbose=1,validation_data=(xtest,ytest))

f=open(sys.argv[3],"w")
for j in range(len(history.acc)):
    print(history.acc[j],history.loss[j],history.val_acc[j],history.val_loss[j],file=f,sep="\t")
f.close()

model.save(sys.argv[4])