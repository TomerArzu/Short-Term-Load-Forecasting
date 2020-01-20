clc
%load image data
dataloc = cd;
dataloc = fullfile(dataloc, '..');
dataloc=[dataloc '\STLFDataSet.mat'];
dataLoader=importdata(dataloc);
dataset=dataLoader.dataset4D;
datatable=dataLoader.dataTable;
Responses = table2array(datatable(32:8759,4));

Images4D=importdata("ResizedImgs.mat");

%%%%%%%%%%%%%%%%%% SMALL DATA FOR TRAIL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Images4D=Images4D(:,:,:,1:1000);
Responses=Responses(1:1000,:);

%%%%%%%%%%%%%%%%%% SMALL DATA FOR TRAIL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data preparation:
% the data in each set isn't overlapped
% Creating traning set 70% (0-70%)
X_traning = Images4D(:,:,:,1:floor(size(Images4D,4)*0.7));
Y_traning = Responses(1:floor(size(Images4D,4)*0.7),1);

% Creating validation set 10% (70%-80%)
X_validation = Images4D(:,:,:,size(X_traning,4)+1:floor(size(Images4D,4)*0.8));
Y_validation = Responses(size(X_traning,4)+1:floor(size(Images4D,4)*0.8),1);

% Creating test set 20% (80%-100%)
X_test = Images4D(:,:,:,floor(size(Images4D,4)*0.8)+1:end);
Y_test = Responses(floor(size(Images4D,4)*0.8)+1:end,1);

options = trainingOptions('sgdm',...
'MiniBatchSize',100,...
'InitialLearnRate',1e-5, ...
'MaxEpochs',7,...
'Shuffle','never', ...
'ValidationData',{X_validation,Y_validation}, ...
'Plots','training-progress', ...
'Verbose', true);

net=vgg16;
layersTransfer = net.Layers(1:end-3);
layers = [layersTransfer
          fullyConnectedLayer(1)
          regressionLayer];

net = trainNetwork(X_traning,Y_traning,layers,options);

YPredicted = predict(net,X_test);
predictionError = Y_test - YPredicted;
thr = 10;
numCorrect = sum(abs(predictionError) < thr);
numValidationImages = numel(Y_test);

accuracy = numCorrect/numValidationImages
squares = predictionError.^2;
rmse = sqrt(mean(squares))

