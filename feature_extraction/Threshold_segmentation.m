function [ Segmented_Lession ] = Threshold_segmentation( Input_Image, Original_Image, ShowResult )
%k parameter can be changed to adjust intensity of image
ei = 25;
st = 35;
%k=10
k = ei*st;
%h=filter matrx
h = ones(ei,st) / k;
Input_Image_filtered = imfilter(Input_Image,h,'symmetric');

if ndims(Input_Image_filtered) > 2
    Image_Gray = rgb2gray(Input_Image_filtered);
else
    Image_Gray = Input_Image_filtered;
end

%Converting to BW
Intensity_adjusted_Image = imadjust(Image_Gray,stretchlim(Image_Gray),[]);
level = graythresh(Intensity_adjusted_Image);
Binary_Image = im2bw(Intensity_adjusted_Image,level);
Dimention = size(Binary_Image);
INVERT_Dim = ones(Dimention(1),Dimention(2)); 
Segmented_Lession = xor(Binary_Image,INVERT_Dim);  %inverting

load('M.mat');
Segmented_Lession(M) = 0;


% Finding of initial point
row = round(Dimention(1)/2);
col = min(find(Segmented_Lession(row,:)));
%Tracing
Boundary = bwtraceboundary(Segmented_Lession,[row, col],'W');

if ShowResult ~= 0
    figure('name',sprintf('Segmentation %d'),'NumberTitle','off');
    subplot(2,2,1),  imshow(Original_Image),        title('Original image');
    subplot(2,2,2),  imshow(Input_Image_filtered),  title('Preprocessed Image');
    subplot(2,2,3),  imshow(Segmented_Lession),     title('Segmented Lession');
    subplot(2,2,4),  imshow(Original_Image),        title('Actual segmentation with original image');
    hold on;
    %Display traced boundary
    plot(Boundary(:,2),Boundary(:,1),'g','LineWidth',2);
    hold off;
else
    return
end
%  figure,
%  plot(Boundary(:,2),Boundary(:,1),'black','LineWidth',2);

Area = bwarea(Segmented_Lession);
Stats =  regionprops(Segmented_Lession, 'Centroid',...
    'MajorAxisLength','MinorAxisLength');
end

