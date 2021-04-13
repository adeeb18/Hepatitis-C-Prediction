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
