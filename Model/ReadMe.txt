This floder contains:

1.	vivoMRNAStructurePredictModel.tf	:	Well-trained DNN model
2.	loadModelAndPredict.py	:	Python script to load models and predict data
3.	TestSample.tsv	:	Randomly acquired 5,000 unstable mRNA structures and 5,000 stable mRNA structures.
4.	predictResult	:	TestSample's predict results
5. 	acc.pl		:		Perl script to compute accuracy of predictResult
	
More details:

1.	"vivoMRNAStructurePredictModel.tf"

	It's a deep learning model built with Tensorflow and Keras. 
	The model enters 6 features and outputs 1 classification value after prediction.
	The 6 features of mRNA are:
		RD	MFE	INI	RPKM	GC	POS
	For detailed calculation methods of these parameters, please see our article:
	"Deciphering the rules which mRNA structures differs from vivo and vitro in saccharomyces cerevisiae by deep learning" (Submitted)
	
	You can use it using the Keras command "load_model()"or our provided Python script.
	
2. loadModelAndPredict.py
	
	You need to install Python 3.X and some Python packages below:
	Tensorflow,Keras and numpy
	Specific installation methods are detailed in our article.
	
	Command line:
		python loadModelAndPredict.py TestSample vivoMRNAStructurePredictModel.tf >predictResult
		
3. TestSample.tsv

	Randomly acquired 1,000 unstable mRNA structures and 1,000 stable mRNA structures with location,label and 6 features.
	The data of tsv format is as follows:
	
	YDR376W	993	1090	1	-0.868242130762128	0.577981563653556	-1.34552595068809	-0.200431557615837	0.316326530612245	0.703241053342336
	
	Each column is:
	1. Gene Name;
	2. mRNA structure begin position(nt);
	3. mRNA strucuture end position(nt);
	4. mRNA structure Label(0 means stable trend, 1 means unstable trend)
	4. Normalized ln(RD) of five studies;
	5. Normalized MFE;
	6. Normalized ln(INI) of five studies;
	7. Normalized ln(RPKM) of BY and RM samples (Albert et al., 2014);
	8. GC contents of structure sequence;
	9. Relative positon of mRNA structure;
	
4. predictResult

	The predict results of TestSample.tsv.
	
	Data format (splice by space):
	
	YDR376W 993 1090 1 0.99978
	
	Each column is:
	1. Gene Name;
	2. mRNA structure begin position(nt);
	3. mRNA strucuture end position(nt);
	4. mRNA structure Label
	5. Model predict value and our threshold of classification is 0.5.
	
5. acc.pl

	A perl script to compute accuracy of predict results.
	You need install 'perl'.
	
	Command line:
	perl acc.pl predictResult
	
	Echo:
	1999 		   	2000    0.9995
	TruePositive	All		Accuracy
	
	
	
	
	
	
	
	
	
	
	
	