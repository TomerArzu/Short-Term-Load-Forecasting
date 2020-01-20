currentFolder = pwd; 
imagesTry = imread([currentFolder '\imageFromDataSet\image' '1' '.png']);
for i=1:size(dataset,4)
   DatasetAsMatImages(:,:,:,i) = imread([currentFolder '\imageFromDataSet\image' num2str(i,'%d') '.png']);
end

save Images4D.mat DatasetAsMatImages
disp("Saved and done to create 4D-Array from images");
