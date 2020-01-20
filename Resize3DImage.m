images=importdata("Images4D.mat");
for i=1:size(images,4)
   res(:,:,:,i)=imresize(images(:,:,:,i),[224 224]);
end

save ResizedImgs.mat res
disp("Resize Done !");

