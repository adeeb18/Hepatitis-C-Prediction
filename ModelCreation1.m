%BME3053C Final Project MATLAB
%Author: Adeeb Rashid
%Group Members: Beauregard Brickson, Rilee Robbins
%Course: BME3053C Computer Applications for BME
%Term: Spring 2021
%J. Crayton Pruitt Family Department of Biomedical Engineering
%University of Florida
%Email: adeeb.rashid@ufl.edu
%April 10, 2021

clear; clc;

%Read DataSet
data = readtable('hepatit-c-data.csv');

%Extract Column Names from Table
AllLabels = data.Properties.VariableNames;
labels = AllLabels(3:14);
    
%Replace Categorical Sex data with double values
data.Sex(strcmp(data.Sex,'f')) = {0};
data.Sex(strcmp(data.Sex,'m')) = {1};
data.Sex = cell2mat(data.Sex);

%Replace Categorical Diagnosis data with double values
data.Category(strcmp(data.Category,'0=Blood Donor')) = {0};
data.Category(strcmp(data.Category,'1=Hepatitis')) = {1};
data.Category(strcmpi(data.Category,'2=Fibrosis')) = {2};
data.Category(strcmpi(data.Category,'3=Cirrhosis')) = {3};
data.Category(strcmpi(data.Category,'0s=suspect Blood Donor')) = {3};
data.Category = cell2mat(data.Category);

%Create Matrix of data
data = table2array(data);

%Remove NaN Values
data(any(isnan(data), 2), :) = [];

%Split into training and testing data
cv = cvpartition(size(data,1),'HoldOut', 0.1);
idx = cv.test;
dataTrain = data(~idx,:);
dataTest = data(idx,:);

%Split training data into X and Y variables
dataTrainX = dataTrain(:,3:14);
dataTrainY = dataTrain(:,2);

%Split testing data into X and Y variables
dataTestX = dataTest(:,3:14);
dataTestY = dataTest(:,2);

%Making Models for 4 different numbers of trees
nTrees = [10,30,50,100];

%10
model10 = TreeBagger(nTrees(1), dataTrainX, dataTrainY, 'Method', 'Classification', 'oobvarimp','on','minleaf',30);
figure(1);
subplot(2,2,1)
barh(model10.OOBPermutedVarDeltaError);
ylabel('Feature');
xlabel('out-of-bag feature importance');
set(gca, 'YTickLabel', labels);

%30
model30 = TreeBagger(nTrees(2), dataTrainX, dataTrainY, 'Method', 'Classification', 'oobvarimp','on','minleaf',30);
subplot(2,2,2);
barh(model30.OOBPermutedVarDeltaError);
ylabel('Feature');
xlabel('out-of-bag feature importance');
set(gca, 'YTickLabel', labels);

%50
model50 = TreeBagger(nTrees(3), dataTrainX, dataTrainY, 'Method', 'Classification', 'oobvarimp','on','minleaf',30);
subplot(2,2,3);
barh(model50.OOBPermutedVarDeltaError);
ylabel('Feature');
xlabel('out-of-bag feature importance');
set(gca, 'YTickLabel', labels);

%100
model100 = TreeBagger(nTrees(4), dataTrainX, dataTrainY, 'Method', 'Classification', 'oobvarimp','on','minleaf',30);
subplot(2,2,4);
barh(model100.OOBPermutedVarDeltaError);
ylabel('Feature');
xlabel('out-of-bag feature importance');
set(gca, 'YTickLabel', labels);

%View one tree
%iew(model10.Trees{1}, 'Mode', 'graph')    

%Use Model to predict testing data
%10
figure(2);
subplot(2,2,1);
dataPredY10 = model10.predict(dataTestX);
dataPredY10 = str2double(dataPredY10);
C10 = confusionchart(dataTestY,dataPredY10)
err10 = error(model10,dataTestX,dataTestY)

%30
subplot(2,2,2);
dataPredY30= model30.predict(dataTestX);
dataPredY30 = str2double(dataPredY30);
C30 = confusionchart(dataTestY,dataPredY30)
err30 = error(model30,dataTestX,dataTestY)

%50
subplot(2,2,3);
dataPredY50 = model50.predict(dataTestX);
dataPredY50 = str2double(dataPredY50);
C50 = confusionchart(dataTestY,dataPredY50)
err50 = error(model50,dataTestX,dataTestY)

%100
subplot(2,2,4);
dataPredY100= model100.predict(dataTestX);
dataPredY100 = str2double(dataPredY100);
C100 = confusionchart(dataTestY,dataPredY100)
err100 = error(model100,dataTestX,dataTestY)
