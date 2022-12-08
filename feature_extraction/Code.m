clc
clear all
close all
JJ=0;

%% Image Acqusition
for i=1:1:437
  if i<10
 I=num2str(i);
 N=['IMD','00',I,'.bmp'];
  elseif i>=10 & i<100
 I=num2str(i);
 N=['IMD','0',I,'.bmp'];
  elseif i>=100
 I=num2str(i);
 N=['IMD',I,'.bmp'];
  end
 C=exist(N);
 if C==0
     
 else
 Image = imread(N);
 Image_resize1 = imresize(Image,[256 256]); % Image Resize
 %% Image Enhancement by Histogram Equlisation Method
[ contrast_adj_image1 ] = Image_enhancement( Image_resize1,0);

%% Segmentation by Threshold method
[ Segmented_Lession1] = Threshold_segmentation( contrast_adj_image1, Image_resize1 , 0);

 %% Feature Extraction
%% 1)Texture Feature Extraction
Gray_Covar_Matrix = graycomatrix(Segmented_Lession1,'Offset',[2 0]);
Texture_Features = Texture_Feature_GLCM(Gray_Covar_Matrix)';

%% 2)Shape Feature Extraction
 [Shape_Features] = Shape_F( Segmented_Lession1);
%% 3)Color Feature Extraction
Extracted_Color_Features = Color_Features( Image );

JJ=JJ+1;

%    Features(JJ,:)=[Texture_Features,Extracted_Color_Features,Shape_Features];
  Features(JJ,:)=[Texture_Features,Extracted_Color_Features];
  end
 end
load('Label2.mat')
for i=1:1:198
tag(i)=find(Label(i,:)==1);
end
tag=tag';
save('Feature','Features','tag')
