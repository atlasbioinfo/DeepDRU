# DeepRSS: A deep learning model was used to predict mRNA structural stability in *S. cerevisiae* 

DeepRSS predicts the stability of in vivo mRNA structures during translation through a series of in vivo RNA structural features. The model was originally modeled in S. cerevisiae by fitting 130000 mRNA structures with their 6  features: RD,MFE,INI,RPKM,GC,POS. DeepRSS is a end-to-end binary classification model that can be divided mRNA structure *in vivo* into two types: stable or unstable.Stable *in vivo* means that although ribosome unwinded mRNA structure during translation, the structure itself could still fold-back and formed structure. Unstabile *in vivo* means that it was difficult to form a structure again by ribosomes unwinding during translation. DeepRSS can promote the field of mRNA structural design *in vivo* and the elaboration of mRNA structural functions. In the future, more species and more structural features will be added as the version is updated.

## DeepRSS Versions

* Version 1.0-First version released on 
* Version 1.1-Support tensorflow 1.9

## DeepRSS installation

DeepRSS was modeled by Tensorflow and Keras. You need to install Tensorflow and Keras before use DeepRSS. 

1, [Tensorflow](https://www.tensorflow.org/)
2. [Keras](https://github.com/keras-team/keras/)


>This floder contains:
>1.	vivoMRNAStructurePredictModel.tf	:	Well-trained DNN model
>2.	loadModelAndPredict.py	:	Python script to load models and predict data
>3.	TestSample.tsv	:	Randomly acquired 5,000 unstable mRNA structures and 5,000 stable mRNA structures.
>4.	predictResult	:	TestSample's predict results
>5. acc.pl		:		Perl script to compute accuracy of predictResult
	
More details:

## 1.	"vivoMRNAStructurePredictModel.tf"

	It's a deep learning model built with Tensorflow and Keras. 
	The model enters 6 features and outputs 1 classification value after prediction.
	The 6 features of mRNA are:
		RD	MFE	INI	RPKM GC	POS
	For detailed calculation methods of these parameters, please see our article:
	"Deciphering the rules which mRN A structures differs from vivo and vitro in saccharomyces cerevisiae by deep learning" (Submitted)
	
	You can use it using the Keras command "load_model()"or our provided Python script.
	
## 2. loadModelAndPredict.py
	
	You need to install Python 3.X and some Python packages below:
	Tensorflow,Keras and numpy
	Specific installation methods are detailed in our article.
	
	Command line:
		python loadModelAndPredict.py TestSample vivoMRNAStructurePredictModel.tf >predictResult
		
## 3. TestSample.tsv

	Randomly acquired 1,000 unstable mRNA structures and 1,000 stable mRNA structures with location,label and 6 features.
	The data of tsv format is as follows:
	
	YDR376W	993	1090	1	-0.868242130762128	0.577981563653556	-1.34552595068809	-0.200431557615837	0.316326530612245	0.703241053342336
	
>	Each column is:
>	1. Gene Name;
>	2. mRNA structure begin position(nt);
>	3. mRNA strucuture end position(nt);
>	4. mRNA structure Label(0 means stable trend, 1 means unstable trend)
>	5. Normalized ln(RD) of five studies;
>	6. Normalized MFE;
>	7. Normalized ln(INI) of five studies;
>	8. Normalized ln(RPKM) of BY and RM samples (Albert et al., 2014);
>	9. GC contents of structure sequence;
>	10. Relative positon of mRNA structure;
	
## 4. predictResult

	The predict results of TestSample.tsv.
	
	Data format (splice by space):
	
	YDR376W 993 1090 1 0.99978
	
>	Each column is:
>	1. Gene Name;
>	2. mRNA structure begin position(nt);
>	3. mRNA strucuture end position(nt);
>	4. mRNA structure Label
>	5. Model predict value and our threshold of classification is 0.5.

## 5. acc.pl

	A perl script to compute accuracy of predict results.
	You need install 'perl'.
	
	Command line:
	perl acc.pl predictResult
	
	Echo:
	1999 		   	2000    0.9995
	TruePositive	All		Accuracy
    
--------
My Email is : atlasbioin4@gmail.com
--------
	


