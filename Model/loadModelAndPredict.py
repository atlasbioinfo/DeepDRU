import numpy as np
from keras.models import load_model
import fileinput
import sys

model=load_model(sys.argv[2])
x=[]
y=[]
data=[]
count=0
for line in fileinput.input(sys.argv[1]):
    tmp=line.strip().split("\t")
    data.append(tmp[0:3])
    x.append(tmp[4:])
    y.append(tmp[3])

re=model.predict(x)
for i in range(0,len(re)):
    print(" ".join(data[i]),y[i],re[i][0])

