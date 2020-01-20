function dataset4D = CompileDataSet(fchnnel, lchnnel, tchnnel, dataSetSize)
% concate to tempMat channel from each layer of each data
% create 4D array and concate each NxNx3 image to each layer
% so at the end we will recive NxNx3xM
% where M is the size of the data set
% or number of NxNx3 images
% because we built the channel from the end to the start we want to build
% the whole 4D matrix from the start to the end
% so we start to take each channel from the end of each channel and concate
% it to the start of the 4D matrix (images)
for i = dataSetSize: -1: 1
    tempMat(:,:,1)=lchnnel(:,:,i);
    tempMat(:,:,2)=fchnnel(:,:,i);
    tempMat(:,:,3)=tchnnel(:,:,i);
    dataset4D(:,:,:,dataSetSize-i+1)=tempMat;
end
disp("CompileDataSet done");
end