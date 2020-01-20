clc
dataloc = cd;
dataloc = fullfile(dataloc, '..');
dataloc=[dataloc '\STLFDataSet.mat'];
dataLoader=importdata(dataloc);
dataset=dataLoader.dataset4D;
datatable=dataLoader.tb09;
% Responses is a vector for the Y variant in our regression network
% The format of Y depends on the type of task.
% Responses must not contain NaNs
%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR NETWORK TRANING %%%%%%%%%%%%%%%%%%%%%%%%%

dataset=dataLoader.dataset4D;
% create vector of responses that consist of 1x3xN where N is number of the
% data:
% 1 - Load responses
% 2 - FTS responses
% 3 - Temprature responses
Responses = CreateResponses(datatable(32:end,:));
Responses=permute(Responses,[3 2 1]);
% Just load Responses
% Responses= table2array(datatable(32:end,4));
% dataset=dataset(:,:,:,1:200);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR NETWORK CHECKING %%%%%%%%%%%%%%%%%%%%%%%%%

% dataset=dataset(:,:,:,1:1000);
% Responses = Responses(1:1000,:);

% data preparation:
% the data in each set isn't overlapped
% Creating traning set 70% (0-70%)
X_traning = dataset(:,:,:,1:floor(size(dataset,4)*0.7));
% Without CreateResponses() func
% Y_traning = Responses(1:floor(size(dataset,4)*0.7),1);
% with CreateResponses() func
Y_traning = Responses(1:floor(size(dataset,4)*0.7),:);

% Creating validation set 10% (70%-80%)
X_validation = dataset(:,:,:,size(X_traning,4)+1:floor(size(dataset,4)*0.8));
% Without CreateResponses() func
% Y_validation = Responses(size(X_traning,4)+1:floor(size(dataset,4)*0.8),1);
% with CreateResponses() func
Y_validation = Responses(size(X_traning,4)+1:floor(size(dataset,4)*0.8),:);

% Creating test set 20% (80%-100%)
X_test = dataset(:,:,:,floor(size(dataset,4)*0.8)+1:end);
% Without CreateResponses() func
% Y_test = Responses(floor(size(dataset,4)*0.8)+1:end,1);
% with CreateResponses() func
Y_test = Responses(floor(size(dataset,4)*0.8)+1:end,:);


%for check the index of each set row1-traning row2-validation row3-test
indexesCheck = [1,floor(size(dataset,4)*0.7);size(X_traning,4)+1,floor(size(dataset,4)*0.8);floor(size(dataset,4)*0.8)+1,size(dataset,4)]
% set options for our network
miniBatchSize  = 100;
validationFrequency = floor(numel(Y_traning)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',20, ...
    'InitialLearnRate',1e-10, ...
    'Shuffle','once', ...
    'ValidationData',{X_validation,Y_validation}, ...
    'ValidationFrequency',validationFrequency, ...
    'Plots','training-progress', ...
    'VerboseFrequency',2, ...
    'Verbose',true);
% CNN Layers:
layers = [
    imageInputLayer([32 32 3],"Name","imageinput")
    convolution2dLayer([3 3],20,"Name","conv_1","Padding",[0 0 0 0])
    reluLayer("Name","relu_1")
    convolution2dLayer([5 5],30,"Name","conv_2","Padding",[0 0 0 0])
%     batchNormalizationLayer
    reluLayer("Name","relu_2")
    maxPooling2dLayer([2 2],"Name","maxpool_2")
%     fullyConnectedLayer(4096,"Name","fc1")
    fullyConnectedLayer(1024,"Name","fc2")
    % dropoutLayer(0.4,"Name","dropout")
    fullyConnectedLayer(50,"Name","fc3")
    %fullyConnectedLayer(40,"Name","fc4")
    fullyConnectedLayer(5,"Name","fc5")
    fullyConnectedLayer(3,"Name","fc6")
    regressionLayer("Name","regressionoutput")];

net = trainNetwork(X_traning,Y_traning,layers,options);

YPredicted = predict(net,X_test);
predictionError = Y_test - YPredicted;
thr = 10;
numCorrect = sum(abs(predictionError) < thr);
numValidationImages = numel(Y_test);

accuracy = numCorrect/numValidationImages
squares = predictionError.^2;
rmse = sqrt(mean(squares))

