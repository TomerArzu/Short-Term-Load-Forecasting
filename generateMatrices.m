function [loadMats,tempratureMats,fsMats]=generateMatrices(dataTable,t,n)
% create a matrix of multi-variate time series
% mvtsMat(:,1)=loads values
% mvtsMat(:,2)=temprature values
% mvtsMat(:,3)=fuzzy sets indeces
mvtsMat(:,1)=table2array(dataTable(:,4));
mvtsMat(:,2)=table2array(dataTable(:,3));
mvtsMat(:,3)=table2array(dataTable(:,5));

% start to build the matrices for each data (load,...)
for j=1:3
    currentData=mvtsMat(:,j);
    i=0;
    while t-i-(n-1)>0
        list=currentData(t-i-(n-1):t-i,1);
        sortedlist=sort(list,'ascend');
        tempMat=zeros(n,n);
        for k=1:size(list)
            kelem= list(k,1);
            kindex=find(sortedlist==kelem);
            tempMat(kindex,k)=1;
        end
        if j==1
            loadMats(:,:,i+1)=tempMat;
        elseif j==2
            tempratureMats(:,:,i+1)=tempMat;
        else
            fsMats(:,:,i+1)=tempMat;
        end
        i=i+1;
    end %while
end %for
disp("generateMatrices Done !");

end %function