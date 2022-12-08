clc
clear all
close all
Image = imgetfile;     [filepath,name,ext] = fileparts(Image);
Image = imread(Image);
Image = imresize(Image,[256 256]); % Image Resize
% imshow(Image);
% h = imfreehand; %draw something 
% M = ~h.createMask();
% Image(M) = 0;
% imshow(Image);


 %% Image Enhancement by Histogram Equlisation Method
[ contrast_adj_image ] = Image_enhancement( Image,1);

%% Segmentation by Threshold method
[ Segmented_Lession] = Threshold_segmentation( contrast_adj_image, Image , 1 );
bb = regionprops( Segmented_Lession,'all');
centroids = cat(1, bb.Centroid);
boundingboxes = cat(1, bb.BoundingBox);
hold on
plot(centroids(:,1), centroids(:,2), 'r+')
for k = 1:size(boundingboxes,1)
    rectangle('position',boundingboxes(k,:),'Edgecolor','g')
end
for k = 1:size(boundingboxes,1)
L(k)=sqrt((128-centroids(k,1))^2+(128-centroids(k,2))^2);
end
f=min(L);
ss=find(L==f);
rectangle('position',boundingboxes(ss,:),'Edgecolor','r')
hold off