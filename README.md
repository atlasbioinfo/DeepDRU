# DeepRSS: A deep learning model was used to predict mRNA structural stability in *S. cerevisiae* 

![Schematic overview of DeepRSS](https://github.com/atlasbioinfo/DeepRSS/blob/master/DeepRSSModel/fig1.png)


DeepRSS predicts the stability of in vivo mRNA structures during translation through a series of in vivo RNA structural features. The model was originally modeled in S. cerevisiae by fitting 130000 mRNA structures with their 6  features: RD,MFE,INI,RPKM,GC,POS. DeepRSS is a end-to-end binary classification model that can be divided mRNA structure *in vivo* into two types: stable or unstable.Stable *in vivo* means that although ribosome unwinded mRNA structure during translation, the structure itself could still fold-back and formed structure. Unstabile *in vivo* means that it was difficult to form a structure again by ribosomes unwinding during translation. DeepRSS can promote the field of mRNA structural design *in vivo* and the elaboration of mRNA structural functions. In the future, more species and more structural features will be added as the version is updated.

## DeepRSS Versions

* Version 1.0-First version released on 20180922 
* Version 1.1-will release on 20190101

## DeepRSS model usage

DeepRSS was modeled by Tensorflow. You need to install Python and Tensorflow before use DeepRSS. 

**[Tensorflow version>1.0](https://www.tensorflow.org/)**
**[Python3](https://www.python.org/)**

In the Sample folder we provide all the files for the exercise DeepRSS to predict. Just simply run the following code to complete the prediction of the in vivo structure of the mRNA in Test0 and output the structure to preTest0.

```bash
    python LoadAndPreDictModel.py DeepRSS.tf Test0 >preTest0
```

## DeepRSS design

DeepRSS is the first attempt to apply a deep learning framework to predicting the structure of mRNA in vivo, and the model structure is very simple.The input layer of the 6 units is followed by a 6-layer fully connected layer, each unit being 256.The activation function of the fully connected layer is ReLU, the activation function of the output is Sigmoid, and the optimization algorithm is Adam.In the future update of DeepRSS, we will adopt more structural data and are trying to use CNN or RNN to predict the structure of the body.

## Folder composition
.
>10FoldCrossValidation : 10-fold cross-validation of 60 models.
>DeepRSSModel : DeepRSS model and its schematic overview.
>Sample : An example of how to use DeepRSS for mRNA structure state prediction.
>Scripts : Important Perl and Python scripts used.

### 10FoldCrossValidation

10-fold cross-validation is a more effective means of judging a model's prediction effect. We tested the predictions of 60 deep learning models with a 10-fold cross-validation test in the project. This folder contains files and scripts that perform 10-fold cross-validation of multiple models.To select the most suitable model, we performed a 10CV on models with multiple dense layers (1 to 10 layers) and multiple unit per layers (16, 32, 64, 128, 256 and 512 units) (Figure S2-5). Binary number of units was used because it can empirically accelerate the training process.  Each model was subsequently trained on a training set for 500 epochs and validated on the development set. 

The following is an overview of the files included in each folder.

#### ./RawData/ 

The "./Data/" folder contains 10 training sets (Train0-9) and development sets (Dev0-9) for training. These data were generated as follows:

All mRNA structural data (from 135844 mRNA structures) were first randomly shuffled three times

```bash
    cat mRNAstructure | shuf | shuf | shuf >shuffledStructrues
```
and then randomly divided into 10 groups.

```bash
    cat shuffledStructrues | split -l 13585 
```

Each with 9 groups as the training set (Train) and 1 group as the development set (Dev). The training data or development data of tsv format is as follows:

```
	YDR376W	993	1090	1	-0.868242130762128	0.577981563653556	-1.34552595068809	-0.200431557615837	0.316326530612245	0.703241053342336

	Each column is:
	>1. Gene Name;
	>2. mRNA structure begin position(nt);
	>3. mRNA strucuture end position(nt);
	>4. mRNA structure Label(0 means stable trend, 1 means unstable trend)
	>4. Normalized ln(RD) of five studies;
	>5. Normalized MFE;
	>6. Normalized ln(INI) of five studies;
	>7. Normalized ln(RPKM) of BY and RM samples (Albert et al., 2014);
	>8. GC contents of structure sequence;
	>9. Relative positon of mRNA structure;
```

#### ./Models/

All the models used in the project and the training process.

It's a deep learning model built with Tensorflow. The model enters 6 features and outputs 1 classification value after prediction. The 6 features of mRNA are:

RD	MFE	INI	RPKM GC	POS

For detailed calculation methods of these parameters, please see our article:

**"Deciphering the rules which mRNA structures differs from vivo and vitro in saccharomyces cerevisiae by deep learning" (Submitted)**
    

```bash
Deep learning model:  *.tf
Training process:     modelOut*
```

### DeepRSSModel

The folder contains the DeepRSS model and the schematic overview of DeepRSS modeling.

![Schematic overview of DeepRSS](https://github.com/atlasbioinfo/DeepRSS/blob/master/DeepRSSModel/fig7.png)

By performing a 10-fold cross-validation on a variety of hyperparameters, the final end-to-end DNN model has 9 fully connected layers with 256 cells per layer; the activation functions adopted were ReLU and Sigmoid; the Adam optimization function was adopted to accelerate the training process; and optimization techniques, batch normalization and early stopping was added to prevent overfitting of the model. The precision of the DeepRSS model reached 99.71% and area under ROC curve (AUC) reached 0.998001.

### Scripts

The Script folder contains scripts for model training, forecasting, and related data processing.

#### FitModel.py

Python script for building and training DNN models.

usage: 
```bash
    python FitModel.py TrainSet DevSet LayerNumber TrainingProcessOutput ModelSave
```

eg:	   

```bash
    python FitModel.py Train0 Dev0 5 modelOutLayer5Group0 Layer5Group0.tf
```

>* TrainSet : Training set, Train0-9
>* DevSet : Development set, Dev0-9
>* LayerNumber : 1 to 10 in this project.How many layers of fully connected layers are being designed in the model?
>* TrainingProcessOutput : The accuracy and loss of each epoch during the model training process will be output to this file.
>* ModelSave : Save final model file.

The code has also been detailed in the comments, you can also modify the parameters in the script according to your needs. What needs to be said is that we use GPU for training, so the batch_size set in the script is 2048.

#### LoadAndPreDictModel.py

You need to install Python 3.X and some Python packages below:

Tensorflow 1.0+ and numpy

Specific installation methods are detailed in our article.
	
	Command line:
    ```bash
        python LoadAndPreDictModel.py DeepRSS.tf Test0 >preTest0
    ```
    
The predict results is in TSV format.
	
	Data format (splice by space):
	
	YDR376W 993 1090 1 0.99978
	
>	Each column is:
>	1. Gene Name;
>	2. mRNA structure begin position(nt);
>	3. mRNA strucuture end position(nt);
>	4. mRNA structure Label
>	5. Model predict value and our threshold of classification is 0.5.

#### calculateAUC.pl

The Perl script for the area under its ROC curve is obtained from the model's predicted data.

usage:
    ```bash
        perl calculateAUC.pl modelPredictData > output
    ```
#### generateTurningMap.pl

This perl script is used to convert predicted data into turning map data.

Usage: 
```bash
    perl generateTurningMap.pl predictedFile > output
```


#### acc.pl

	A perl script to compute accuracy of predict results.
	You need install 'perl'.
	
	Command line:
	perl acc.pl predictResult
	
	Echo:
	1999 		   	2000    0.9995
	TruePositive	All		Accuracy
    
    
--------
I am a beginner of deep learning, because I found that deep learning can solve the problems in my research perfectly, so I started to understand. If there is a BUG in the project, I hope that you will improve it if you propose it. If you have suggestions for the project or would like to discuss with me, you can send me an email.

My Email is : atlasbioin4@gmail.com
--------
	


