%BME3053C Final Project MATLAB
%Author: Adeeb Rashid
%Group Members: Beauregard Brickson, Rilee Robbins
%Course: BME3053C Computer Applications for BME
%Term: Spring 2021
%J. Crayton Pruitt Family Department of Biomedical Engineering
%University of Florida
%Email: adeeb.rashid@ufl.edu
%April 14, 2021

%Applies confusionmatstats method to calculate confusion matrix statistics 
%Audrey Cheong (2021). confusionmatStats(group,grouphat) (https://www.mathworks.com/matlabcentral/fileexchange/46035-confusionmatstats-group-grouphat), MATLAB Central File Exchange. Retrieved April 21, 2021.

%Applies unfold method to print members of a struct
%Carlos Gerardo Treviño (2021). unfold.m (https://www.mathworks.com/matlabcentral/fileexchange/55485-unfold-m), MATLAB Central File Exchange. Retrieved April 21, 2021.

classdef HepCPredictor < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        HepatitisCPredictorModelCreationLabel  matlab.ui.control.Label
        LoadDataExplanationLabel     matlab.ui.control.Label
        LoadDatasetEditFieldLabel    matlab.ui.control.Label
        LoadDatasetEditField         matlab.ui.control.EditField
        LoadButton                   matlab.ui.control.Button
        NumberofTreesEditFieldLabel  matlab.ui.control.Label
        NumberofTreesEditField       matlab.ui.control.NumericEditField
        CreateModelButton            matlab.ui.control.Button
        DecisionTreeCreationLabel    matlab.ui.control.Label
        SelectSeedEditFieldLabel     matlab.ui.control.Label
        SelectSeedEditField          matlab.ui.control.NumericEditField
        SelectSeedButton             matlab.ui.control.Button
        RandomForestCreationLabel    matlab.ui.control.Label
        CreateModelButton_2          matlab.ui.control.Button
        EditFieldLabel               matlab.ui.control.Label
        EditField                    matlab.ui.control.NumericEditField
    end
    
    %Properties for model variables
    properties (Access = public)
        path;
        data;
        labels;
        dataTrain;
        dataTest;
        dataTrainX;
        dataTrainY;
        dataTestX;
        dataTestY;
        seedVal;
        Cat;
        numTrees;
        
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: LoadDatasetEditField
        function getDataset(app, event)
            %Read in path to dataset
            value = app.LoadDatasetEditField.Value;
            app.path = value;
           
        end

        % Button pushed function: LoadButton
        function loadData(app, event)
            %Read app.dataSet
            app.data = readtable(app.path);
            if app.Cat == 1
                disp('Creating two class dataset split...');
                %Extract Column Names from Table
                AllLabels = app.data.Properties.VariableNames;
                app.labels = AllLabels(3:14);

                %Replace Categorical Sex app.data with double values
                app.data.Sex(strcmp(app.data.Sex,'f')) = {0};
                app.data.Sex(strcmp(app.data.Sex,'m')) = {1};
                app.data.Sex = cell2mat(app.data.Sex);

                %Replace Categorical Diagnosis app.data with double values
                app.data.Category(strcmp(app.data.Category,'0=Blood Donor')) = {0};
                app.data.Category(strcmp(app.data.Category,'1=Hepatitis')) = {1};
                app.data.Category(strcmpi(app.data.Category,'2=Fibrosis')) = {1};
                app.data.Category(strcmpi(app.data.Category,'3=Cirrhosis')) = {1};
                app.data.Category(strcmpi(app.data.Category,'0s=suspect Blood Donor')) = {0};
                app.data.Category = cell2mat(app.data.Category);

                %Create Matrix of app.data
                app.data = table2array(app.data);

                %Replace NaN Values with column averages
                [r,c] = size(app.data);
                for i = 1:1:r
                    for j = 1:1:c
                        if isnan(app.data(i,j)) 
                            if (j<541)
                                app.data(i,j) = mean(app.data([1:540],j), 'omitnan');
                            elseif (j<565)
                                app.data(i,j) = mean(app.data([541:564],j), 'omitnan');
                            elseif (j< 586)
                                app.data(i,j) = mean(app.data([565:585],j), 'omitnan');
                            else
                                app.data(i,j) = mean(app.data([586:end],j), 'omitnan');
                            end
                        end
                    end
                end

                %Remove NaN Values
                app.data(any(isnan(app.data), 2), :) = [];

                %Split into groups of 20
                
                r0 = randsample(540,80);
                r1 = randsample(24,20) + 540;
                r2 = randsample(21,20) + 564;
                r3 = randsample(30,20) + 585;
                r = [r0' r1' r2' r3'];
                r = sort(r);

                evenData = app.data(r,:);

                %Split into training and testing app.data
                cv = cvpartition(size(evenData,1),'HoldOut', 0.2);
                idx = cv.test;
                app.dataTrain = evenData(~idx,:);
                app.dataTest = evenData(idx,:);

                %Split training app.data into X and Y variables
                app.dataTrainX = app.dataTrain(:,3:14);
                app.dataTrainY = app.dataTrain(:,2);

                %Split testing app.data into X and Y variables
                app.dataTestX = app.dataTest(:,3:14);
                app.dataTestY = app.dataTest(:,2);

                app.dataTestX = normalize(app.dataTestX,'range');
                app.dataTrainX = normalize(app.dataTrainX, 'range');
 
                disp('table read!')

            elseif app.Cat == 2
                disp('Creating four class dataset split...');
                %Extract Column Names from Table
                AllLabels = app.data.Properties.VariableNames;
                app.labels = AllLabels(3:14);

                %Replace Categorical Sex app.data with double values
                app.data.Sex(strcmp(app.data.Sex,'f')) = {0};
                app.data.Sex(strcmp(app.data.Sex,'m')) = {1};
                app.data.Sex = cell2mat(app.data.Sex);

                %Replace Categorical Diagnosis app.data with double values
                app.data.Category(strcmp(app.data.Category,'0=Blood Donor')) = {0};
                app.data.Category(strcmp(app.data.Category,'1=Hepatitis')) = {1};
                app.data.Category(strcmpi(app.data.Category,'2=Fibrosis')) = {2};
                app.data.Category(strcmpi(app.data.Category,'3=Cirrhosis')) = {3};
                app.data.Category(strcmpi(app.data.Category,'0s=suspect Blood Donor')) = {0};
                app.data.Category = cell2mat(app.data.Category);

                %Create Matrix of app.data
                app.data = table2array(app.data);

                %Replace NaN Values with column averages
                [r,c] = size(app.data);
                for i = 1:1:r
                    for j = 1:1:c
                        if isnan(app.data(i,j)) 
                            if (j<541)
                                app.data(i,j) = mean(app.data([1:540],j), 'omitnan');
                            elseif (j<565)
                                app.data(i,j) = mean(app.data([541:564],j), 'omitnan');
                            elseif (j< 586)
                                app.data(i,j) = mean(app.data([565:585],j), 'omitnan');
                            else
                                app.data(i,j) = mean(app.data([586:end],j), 'omitnan');
                            end
                        end
                    end
                end

                %Remove NaN Values
                app.data(any(isnan(app.data), 2), :) = [];

                %Split into groups of 20

                r0 = randsample(540,20);
                r1 = randsample(24,20) + 540;
                r2 = randsample(21,20) + 564;
                r3 = randsample(30,20) + 585;
                r = [r0' r1' r2' r3'];
                r = sort(r);

                evenData = app.data(r,:);

                %Split into training and testing app.data
                cv = cvpartition(size(evenData,1),'HoldOut', 0.2);
                idx = cv.test;
                app.dataTrain = evenData(~idx,:);
                app.dataTest = evenData(idx,:);


                %Split training app.data into X and Y variables
                app.dataTrainX = app.dataTrain(:,3:14);
                app.dataTrainY = app.dataTrain(:,2);

                %Split testing app.data into X and Y variables
                app.dataTestX = app.dataTest(:,3:14);
                app.dataTestY = app.dataTest(:,2);

                app.dataTestX = normalize(app.dataTestX,'range');
                app.dataTrainX = normalize(app.dataTrainX, 'range');
                disp('table read!')
            end
    
        end

        % Value changed function: SelectSeedEditField
        function getSeed(app, event)
            %Obtain requested seed to get reproducable results
            value = app.SelectSeedEditField.Value;
            app.seedVal = value;
        end

        % Button pushed function: SelectSeedButton
        function SelectSeed(app, event)
            %Activate seed set
            rng(app.seedVal)
        end

        % Button pushed function: CreateModelButton_2
        function CreateTree(app, event)
            
            disp("Creating TreeBagger Model");

            %Create basic decision tree
            dt = fitctree(app.dataTrainX,app.dataTrainY);
            dtClass = resubPredict(dt);
            dtResubErr = resubLoss(dt);
            %Plot resubstitution confusion matrix
            figure('Name','Resubstitution Prediction Confusion Matrix');
            C = confusionchart(app.dataTrainY,dtClass);
            %Plot testing set confusion matrix
            figure('Name', 'Testing Data Prediction Confusion Matrix');
            dtClass2 = predict(dt,app.dataTestX);
            C2 = confusionchart(app.dataTestY,dtClass2)
            %Plot created tree
            view(dt, 'Mode', 'graph');
            %Display confusion chart stats in command window
            stats = confusionmatStats(app.dataTestY,dtClass2);
            unfold(stats, true);

        end

        % Value changed function: NumberofTreesEditField
        function GetTreeNum(app, event)
            %Obtain number of trees requested
            value = app.NumberofTreesEditField.Value;
            app.numTrees = value;
            
            %Default 25 trees
            if value == 0
                app.numTrees = 25;
            end
            
        end

        % Button pushed function: CreateModelButton
        function CreateForest(app, event)
            
            disp("Creating TreeBagger Model");
            
            %ModelCreation
            modelUser = TreeBagger(app.numTrees, app.dataTrainX, app.dataTrainY, 'Method', 'Classification', 'oobvarimp','on', 'minleaf',1)
           
            disp("Displaying Original Model")
            
            %Plotting out of bag error
            figure('Name', 'Original Model');
            subplot(2,2,1)
            oobErr = oobError(modelUser);
            plot(oobErr)
            title('OOB Error for Original Forest')
            xlabel('Number of Grown Trees')
            ylabel('Out of Bag Error')
            
            %Finding tree with lowest out of bag error
            idealTree = find(min(oobErr) == oobErr);
            idealTree = idealTree(1)

            %Displaying feature importance
            subplot(2,2,2)
            barh(modelUser.OOBPermutedPredictorDeltaError);
            title('Predictor Importance')
            ylabel('Feature');
            xlabel('out-of-bag feature importance');
            set(gca, 'YTickLabel', app.labels);
            idxvar = find(modelUser.OOBPermutedPredictorDeltaError>0.50);

            %Plotting confusion matrix for testing data
            subplot(2,2,3);
            dataPredYUser = modelUser.predict(app.dataTestX);
            dataPredYUser = str2double(dataPredYUser);
            CUser = confusionchart(app.dataTestY,dataPredYUser);

            %Plotting confusion matrix for training data
            subplot(2,2,4);
            dataPredTrainYUser = modelUser.predict(app.dataTrainX);
            dataPredTrainYUser = str2double(dataPredTrainYUser);
            CUserTrain = confusionchart(app.dataTrainY,dataPredTrainYUser);

            disp("Displaying updated model with selected important features")
            
            %Creating updated model with important features only
            Model2 = TreeBagger(app.numTrees,app.dataTrainX(:,idxvar),app.dataTrainY,'OOBPredictorImportance','on','OOBPrediction','on')
            
            figure('Name', 'Model with Selected Important Features');

            %Plotting out of bag error
            subplot(2,2,1)
            title('OOB Error for New Forest');
            oobErr2 = oobError(Model2);
            plot(oobErr2)
            xlabel('Number of Grown Trees');
            ylabel('Out of Bag Error');

            %Plotting feature importance
            subplot(2,2,2)
            title('Predictor Importance for New Forest');
            barh(Model2.OOBPermutedVarDeltaError);
            ylabel('Feature');
            xlabel('out-of-bag feature importance');
            set(gca, 'YTickLabel', app.labels(idxvar));
            
            %Plotting confusion matrix for testing data
            subplot(2,2,3);
            dataPredY = Model2.predict(app.dataTestX(:,idxvar));
            dataPredY = str2double(dataPredY);
            CUser = confusionchart(app.dataTestY,dataPredY);

            %Visualizing statistics in the command window
            stats = confusionmatStats(app.dataTestY,dataPredY); 
            unfold(stats,true);
            
            %Plotting confusion matrix for training data
            subplot(2,2,4);
            dataPredTrainYUser = Model2.predict(app.dataTrainX(:,idxvar));
            dataPredTrainYUser = str2double(dataPredTrainYUser);
            CUserTrain = confusionchart(app.dataTrainY,dataPredTrainYUser);

        end

        % Value changed function: EditField
        function getCategory(app, event)
            %Recieve number of categories 
            value = app.EditField.Value;
            app.Cat = value;
            
            %Default 4 class split
            if value == 0
                app.Cat = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create HepatitisCPredictorModelCreationLabel
            app.HepatitisCPredictorModelCreationLabel = uilabel(app.UIFigure);
            app.HepatitisCPredictorModelCreationLabel.HorizontalAlignment = 'center';
            app.HepatitisCPredictorModelCreationLabel.Position = [220 444 201 22];
            app.HepatitisCPredictorModelCreationLabel.Text = 'Hepatitis C Predictor Model Creation';
            
            % Create LoadDataExplanationLabel
            app.LoadDataExplanationLabel = uilabel(app.UIFigure);
            app.LoadDataExplanationLabel.HorizontalAlignment = 'center';
            app.LoadDataExplanationLabel.Position = [80 418 501 22];
            app.LoadDataExplanationLabel.Text = 'Please load a dataset (hepatit-c-data.csv), press load, then choose model to create';

            % Create LoadDatasetEditFieldLabel
            app.LoadDatasetEditFieldLabel = uilabel(app.UIFigure);
            app.LoadDatasetEditFieldLabel.HorizontalAlignment = 'right';
            app.LoadDatasetEditFieldLabel.Position = [21 391 77 22];
            app.LoadDatasetEditFieldLabel.Text = 'Load Dataset';

            % Create LoadDatasetEditField
            app.LoadDatasetEditField = uieditfield(app.UIFigure, 'text');
            app.LoadDatasetEditField.ValueChangedFcn = createCallbackFcn(app, @getDataset, true);
            app.LoadDatasetEditField.Position = [131 391 477 22];

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @loadData, true);
            app.LoadButton.Position = [271 312 100 22];
            app.LoadButton.Text = 'Load';

            % Create NumberofTreesEditFieldLabel
            app.NumberofTreesEditFieldLabel = uilabel(app.UIFigure);
            app.NumberofTreesEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofTreesEditFieldLabel.Position = [333 129 106 22];
            app.NumberofTreesEditFieldLabel.Text = 'Number of Trees';

            % Create NumberofTreesEditField
            app.NumberofTreesEditField = uieditfield(app.UIFigure, 'numeric');
            app.NumberofTreesEditField.ValueChangedFcn = createCallbackFcn(app, @GetTreeNum, true);
            app.NumberofTreesEditField.Position = [454 129 120 22];

            % Create CreateModelButton
            app.CreateModelButton = uibutton(app.UIFigure, 'push');
            app.CreateModelButton.ButtonPushedFcn = createCallbackFcn(app, @CreateForest, true);
            app.CreateModelButton.Position = [420 92 100 22];
            app.CreateModelButton.Text = 'Create Model';

            % Create DecisionTreeCreationLabel
            app.DecisionTreeCreationLabel = uilabel(app.UIFigure);
            app.DecisionTreeCreationLabel.Position = [82 162 128 22];
            app.DecisionTreeCreationLabel.Text = 'Decision Tree Creation';

            % Create SelectSeedEditFieldLabel
            app.SelectSeedEditFieldLabel = uilabel(app.UIFigure);
            app.SelectSeedEditFieldLabel.HorizontalAlignment = 'right';
            app.SelectSeedEditFieldLabel.Position = [7 248 91 22];
            app.SelectSeedEditFieldLabel.Text = 'Select Seed';

            % Create SelectSeedEditField
            app.SelectSeedEditField = uieditfield(app.UIFigure, 'numeric');
            app.SelectSeedEditField.ValueChangedFcn = createCallbackFcn(app, @getSeed, true);
            app.SelectSeedEditField.Position = [131 248 360 22];

            % Create SelectSeedButton
            app.SelectSeedButton = uibutton(app.UIFigure, 'push');
            app.SelectSeedButton.ButtonPushedFcn = createCallbackFcn(app, @SelectSeed, true);
            app.SelectSeedButton.Position = [519 248 100 22];
            app.SelectSeedButton.Text = 'Select Seed';

            % Create RandomForestCreationLabel
            app.RandomForestCreationLabel = uilabel(app.UIFigure);
            app.RandomForestCreationLabel.Position = [399 162 137 22];
            app.RandomForestCreationLabel.Text = 'Random Forest Creation';

            % Create CreateModelButton_2
            app.CreateModelButton_2 = uibutton(app.UIFigure, 'push');
            app.CreateModelButton_2.ButtonPushedFcn = createCallbackFcn(app, @CreateTree, true);
            app.CreateModelButton_2.Position = [96 129 100 22];
            app.CreateModelButton_2.Text = 'Create Model';

            % Create EditFieldLabel
            app.EditFieldLabel = uilabel(app.UIFigure);
            app.EditFieldLabel.HorizontalAlignment = 'right';
            app.EditFieldLabel.Position = [21 352 452 22];
            app.EditFieldLabel.Text = 'Category Split (1:Healthy vs Diseased, 2: Healthy vs HepC vs Fibrosis vs Cirrhosis';

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'numeric');
            app.EditField.ValueChangedFcn = createCallbackFcn(app, @getCategory, true);
            app.EditField.Position = [488 352 120 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HepCPredictor

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
    
end