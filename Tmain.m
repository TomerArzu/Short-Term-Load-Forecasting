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
%create groups and add to table data
loadWithGroups=dataFuzzification(dataTable,10);
%add the returned groups to tabledata
dataTable=addvars(dataTable,loadWithGroups(:,2),'After','load');
%phase 1 - data processing:
% t refers to the current state of time for time series of load, temprature
% and indices of FTS sets
% The following method recive the dataset as table, the current time t and
% the size of the images that we create (NxN) and its output will be 3
% matrices.(one for each RGB channel).
[loadCH,tempratureCH,fuzzySetsCH]=generateMatrices(dataTable,size(dataTable,1),32);
x=tempratureCH(:,:,8728);