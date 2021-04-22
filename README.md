# HepC-decision-tree
Contributors: Adeeb Rashid, Rilee Robbins, Beauregard Brickson

# Aims
There are two aims for this project: 
1) To earlier diagnose patients with Hepatitis C, without them requesting a Hepatitis C-specific blood test or prior to severe liver damage, in order to allow them to earlier treat the disease. 
2) To diagnose Hepatitis C patients early to precent the further spread of the disease to others.

# Significance and Scope
Hepatitis C is viral infection that attacks the liver and can lead to liver cancer and/or cirrhosis. A large number of HepC positive people do not have any symptoms of the virus, which is a large motivation for this study. This model could be used to predict whether a patient undergoing a routine blood test has hepatitis C without directly testing for the virus. Early diagnosis of this virus is paramount to prevent long term complications and the passing of the virus to another person. 
The scope of our project applies to anybody undergoing routine blood testing, as the model could be run after each blood test to improve early detection and eliminate the need to get a specific Hepatitis C test.

# Data Set
The dataset is presented in a *.csv file and was found on Kaggle. It provides blood data for 614 patients, containing the following features: Age, Sex, Albumin(ALB), Alkaline Phosphatase(ALP), Alanine Transaminase(ALT), Aspartate Aminotransferase(AST), Bilirubin (BIL), Cholinesterase (CHE), Cholesterol (CHOL), Creatinine (CREA), Gama-Glutamyl Transferase (GGT), and Protein (PROT). The dataset was donated in July 2020 to UCI Machine Learning Repository. The dataset is reported to fairly represent males and females, slightly learning towards males. The distribution of ages is also reported to follow a bell-shaped curve, ranging from young adults to senior. As a result of the information being taken from a representative sample of the population, the date is significant and can be used to draw conclusions. The dataset is also reported to have missing values, which we must deal with before running our machine learning algorithm. We will be performing a replacement on missing data values with averages.

Link: https://www.kaggle.com/busekseolu/hepatitis-c-patients-data-set

This dataset will be compressed by our code in order to create evenly sized classes, as the current dataset tuples have around 80% healthy patients and less than 10% for the remaining classifications. This will bring the dataset from a size of ~600 to 80-120. 

# Running the Code
HepCPredictor.m, confusionmatStats.m, unfold.m, and hepatit-c-data.csv must all be in the same directory. Open the HepCPredictor script and run the file. This will open up a GUI that will allow you to load data, as well as create models. Type in "hepatit-c-data.csv" (or any other csv dataset in the same format) in the dataset section. Then select whether you want the dataset to be read and split into four categories (Healthy, Hepatitis-C, Cirrhosis, or Fibrosis) or in two categories (Healthy, Diseased). Then press load. This will display a prompt in the command window and process/ clean the data. You may then select a single decision tree classifier model, or a random forest model, where you may select a number of trees desired. The random forest model will display confusion matrices for training and testing data, as well as a visualization of teh decision tree. The random forest model will display feauter importance, out of bag error, training confusion matrices, and testing confusion matrices. It will then select important features and create a new refined model and display the same graphs. Both model creations will display confusion matrix statistics in the command window, including accuracy, prescision, speificity, sensitivity, recall and F-score. If you would like to produce reproducible results, you may use the seed setting feature to input a seed nnumber and select that seed for all random number generation.

# Our Results
Our team found the single decision tree classifier more effective for a two class split and the random forest classifier more effective with a four class split. However, both had a lack in prediction accuracy due to the small size of the refined dataset

# Citations
Audrey Cheong (2021). confusionmatStats(group,grouphat) (https://www.mathworks.com/matlabcentral/fileexchange/46035-confusionmatstats-group-grouphat), MATLAB Central File Exchange. Retrieved April 22, 2021.
Carlos Gerardo Treviño (2021). unfold.m (https://www.mathworks.com/matlabcentral/fileexchange/55485-unfold-m), MATLAB Central File Exchange. Retrieved April 22, 2021.
