function resp=CreateResponses2(Data)
for i=1:size(Data,1)-32
    resp(:,:,i)=Data(i:i+31);
end
end