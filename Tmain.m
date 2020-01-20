clc
clear all;

% configure the options to read from the CSV file 
opts = detectImportOptions('InputData.csv');
opts.SelectedVariableNames = {'date','time','temperature','load'};
opts= setvaropts(opts,'date','InputFormat','MM/dd/yy');
opts = setvartype(opts,'time','datetime');
opts= setvaropts(opts,'time','InputFormat','HH:mm');
%read data as table
dataTable = readtable('InputData.csv',opts);
dataTable = dataTable(1:size(dataTable)-1,:);
% table for data from 2009
tb09 = dataTable(1:end,:); % whole two year
%create groups and add to table data
loadWithGroups=dataFuzzification(tb09,10);
%add the returned groups to tabledata
tb09=addvars(tb09,loadWithGroups(:,2),'After','load');
% phase 1 - data processing:
% t refers to the current state of time for time series of load, temprature
% and indices of FTS sets
% The following method recive the dataset as table, the current time t and
% the size of the images that we create (NxN) and its output will be 3
% matrices.(one for each RGB channel).
[loadCH,tempratureCH,fuzzySetsCH]=generateMatrices(tb09,size(tb09,1),32);
% phase 2 - creating image time series
% we create 4D array from the dataset
% each 3D layer will contain matrices size NxNx3
% each one of the channels in the 3rd dimantion 
% consist of load, fuzzy sets and tempratureCH
dataset4D=CompileDataSet(fuzzySetsCH, loadCH, tempratureCH, size(tempratureCH,3));
save STLFDataSet.mat dataTable dataset4D tb09
disp("file Save in: "+ pwd + "\STLFDataSet.mat");