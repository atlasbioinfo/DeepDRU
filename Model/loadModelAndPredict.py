import numpy as np
from keras.models import load_model
import fileinput
import sys

# load model
model=load_model(sys.argv[2])

x=[]
y=[]
data=[]
count=0

# argv[1] is structral data(TestSample.tsv)
for line in fileinput.input(sys.argv[1]):
    tmp=line.strip().split("\t")
    data.append(tmp[0:3])
#tmp[4:] are 6 structral features.
    x.append(tmp[4:])
#tmp[3] is 0 or 1
    y.append(tmp[3])

#model predict
re=model.predict(x)
#output
for i in range(0,len(re)):
    print(" ".join(data[i]),y[i],re[i][0])

