dataLoader=importdata("STLFDataSet.mat");
dataset4D=dataLoader.dataset4D;
mkdir('imageFromDataSet');
currentFolder = pwd; 
for i=1:size(dataset4D,4)
   filenameT = [currentFolder '\imageFromDataSet\image' num2str(i,'%d') '.png'];
   imwrite(dataset4D(:,:,:,i),filenameT,'jpg');
end

disp(size(dataset4D,4)+" Images Created!\n at "+filenameT);
