function dataset=dataFuzzification(dataTable,numOfGroups)
%Universe of Discourse Partitioning - the number of intervals
dataset = table2array(dataTable(:,4));
maxLoad=max(dataset);
minLoad=min(dataset);
gdif=(maxLoad-minLoad);         
gdif=gdif./numOfGroups;         
gdif=round(gdif);               %calculate the diff between rach group and round it up

%matrix to save values of each group
%col 1 = min value for the group
%col 2 = max value for the group 
%each row denote a group
gvalues=zeros(numOfGroups,2);   
value=minLoad-1;                 
step=gdif;                   
for i=1:numOfGroups
    gvalues(i,1)=value+1;       
    value=value+step;
    gvalues(i,2)=value;
end

for i=1:size(dataset,1)
    for j=1:size(gvalues,1)
        if dataset(i)>gvalues(j,1) && dataset(i)<gvalues(j,2)
            dataset(i,2)=j;
            break;
        end
    end
end
disp("dataFuzzification Done !");
end