function resp = CreateResponses(tb)
tbArr=table2array(tb(:,3:5));
for i=1:size(tb,1)
    resp(1,1,i)= tbArr(i,2);
    resp(1,2,i)= tbArr(i,3);
    resp(1,3,i)= tbArr(i,1);
end
end