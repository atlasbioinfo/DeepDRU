# DeepDRU: A deep learning model was used to predict mRNA structural de-structured degree in *S. cerevisiae* 
## [Deciphering the rules of mRNA structure differentiation in Saccharomyces cerevisiae in vivo and in vitro with deep neural networks](https://www.tandfonline.com/doi/full/10.1080/15476286.2019.1612692)

![Schematic overview of DeepRSS](https://github.com/atlasbioinfo/DeepDRU/blob/master/Figures/fig1.png)

The structure of mRNA in vivo is unwound to some extent in response to multiple factors involved in the translation process, resulting in significant differences from the structure of the same mRNA in vitro. In this study, we have proposed a novel application of deep neural networks, named DeepDRU, to predict the degree of mRNA structure unwinding in vivo by fitting five quantifiable features that may affect mRNA folding: ribosome density (RD), minimum folding free energy (MFE), GC content, translation initiation ribosome density (INI), and mRNA structure position (POS). mRNA structures with adjustment of the simulated structural features were designed and then fed into the trained DeepDRU model. We found unique effect regions of these five features on mRNA structure in vivo. Strikingly, INI is the most critical factor affecting the structure of mRNA in vivo, and structural sequence features, including MFE and GC content, have relatively smaller effects. DeepDRU provides a new paradigm for predicting the unwinding capability of mRNA structure in vivo. This improved knowledge about the mechanisms of factors influencing the structural capability of mRNA to unwind will facilitate the design and functional analysis of mRNA structure in vivo.

## DeepDRU Versions

* Version 1.0-First version released on 20180922 
* Version 1.1-Revise release on 20190101, deleted feature RPKM.

## DeepDRU model usage

DeepDRU was modeled by Tensorflow. You need to install Python and Tensorflow before use DeepDRU. 

**[Tensorflow version>1.0](https://www.tensorflow.org/)**
**[Python3](https://www.python.org/)**

In the Sample folder, we provide all the files for the exercise DeepDRU to predict. Just simply run the following code to complete the prediction of the in vivo structure of the mRNA in Test0 and output the structure to preTest0.

```bash
    python LoadAndPreDictModel.py DeepDRU.tf Test0 >preTest0
```

## DeepDRU design

DeepDRU is the first attempt to apply a deep learning framework to predict the structure of mRNA in vivo, and the model structure is very simple. The input layer of the five units is followed by a 8-layer fully connected layer, each unit is 512. The activation function of the fully connected layer is ReLU, the activation function of the output is Sigmoid, and the optimization algorithm is Adam. In the future update of DeepDRU, we will adopt more structural data and are trying to use CNN or RNN to predict the structure of the body.

## Folder composition
.
>Raw data: raw mRNA structure data with five features and label.
> DeepDRUModel: DeepDRU model and its schematic overview.
> Sample: An example of how to use DeepDRU for mRNA structure state prediction.
> Scripts: Important Perl and Python scripts used.

### ./RawData/ 

The "./Data/" folder contains ten training sets (Train0-9) and development sets (Dev0-9) for training. These data were generated as follows:

All mRNA structural data (from 135844 mRNA structures) were first randomly shuffled three times

```bash
    cat mRNAstructure | shuf | shuf | shuf >shuffledStructrues
```
and then randomly divided into ten groups.

```bash
    cat shuffledStructrues | split -l 13585 
```

Each group of 9 serves as the training set and 1 as the development set (Dev). The training data or development data of TSV format is as follows:

```
	YDR376W	993	1090	1	-0.868242130762128	0.577981563653556	-1.34552595068809	0.316326530612245	0.703241053342336

	Each column is:
	>1. Gene Name;
	>2. mRNA structure begin position(nt);
	>3. mRNA strucuture end position(nt);
	>4. mRNA structure Label(0 means stable trend, 1 means unstable trend)
	>4. Normalized ln(RD) of five studies;
	>5. Normalized MFE;
	>6. Normalized ln(INI) of five studies;
	>7. GC contents of structure sequence;
	>8. Relative positon of mRNA structure;
```

### DeepDRUModel

The folder contains the DeepDRU model and the schematic overview of DeepDRU modeling.

![Schematic overview of DeepDRU](https://github.com/atlasbioinfo/DeepDRU/blob/master/Figures/fig7.png)

By performing a 10-fold cross-validation on a variety of hyperparameters, the final end-to-end DNN model has 9 fully connected layers with 256 cells per layer; the activation functions adopted were ReLU and Sigmoid; the Adam optimization function was adopted to accelerate the training process; and optimization techniques, batch normalization, and early stopping was added to prevent overfitting of the model. The precision of the DeepDRU model reached 99.53%.

### Scripts

The Script folder contains scripts for model training, forecasting, and related data processing.

#### FitModel.py

Python scripts are used to build and train DNN models.

usage: 
```bash
    python FitModel.py TrainSet DevSet LayerNumber TrainingProcessOutput ModelSave
```

eg:	   

```bash
    python FitModel.py Train0 Dev0 5 modelOutLayer5Group0 Layer5Group0.tf
```

>* TrainSet: a Training set, Train0-9
>* DevSet: Development set, Dev0-9
>* LayerNumber: 1 to 10 in this project. How many layers of fully connected layers are being designed in the model?
>* TrainingProcessOutput: The accuracy and loss of each epoch during the model training process will be output to this file.
>* ModelSave : Save final model file.

The code has also been detailed in the comments; you can also modify the parameters in the script according to your needs. What needs to be said is that we use GPU for training, so the batch_size set in the script is 2048.

#### LoadAndPreDictModel.py

You need to install Python 3.X and some Python packages below:

Tensorflow 1.0+ and numpy

Specific installation methods are detailed in our article.
	
	Command line:
    ```bash
        python LoadAndPreDictModel.py DeepDRU.tf Test0 >preTest0
    ```
    
The predict results are in TSV format.
	
	Data format (splice by space):
	
	YDR376W 993 1090 1 0.99978
	
>	Each column is:
>	1. Gene Name;
>	2. mRNA structure begin position(nt);
>	3. mRNA structure end position(nt);
>	4. mRNA structure Label
>	5. Model predict value and our threshold of classification is 0.5.

#### calculateAUC.pl

The Perl script for the area under its ROC curve is obtained from the model's predicted data.

usage:
    ```bash
        perl calculateAUC.pl modelPredictData > output
    ```
#### generateTurningMap.pl

This Perl script is used to convert predicted data into turning map data.

Usage: 
```bash
    perl generateTurningMap.pl predictedFile > output
```


#### acc.pl

	A Perl script to compute accuracy of predict results.
	You need to install 'Perl.'
	
	Command line:
	perl acc.pl predictResult
	
	Echo:
	1999 		   	2000    0.9995
	TruePositive	All		Accuracy
    
    
