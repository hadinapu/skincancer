function [ ColorFeature_Vector ] = Color_Features( Image)

if ndims(Image) > 2
    Red_Image = Image(:,:,1);
    Green_Image = Image(:,:,2);
    Blue_Image = Image(:,:,3);
    [Red_features] = Statastics_Mean_stdv_Var ( Red_Image );
    [Green_features ] = Statastics_Mean_stdv_Var ( Green_Image );
    [Blue_features] = Statastics_Mean_stdv_Var ( Blue_Image );
    
    ColorFeature_Vector = [Red_features, Green_features,Blue_features];
else
    White_Image = Image(:,:,1);
    Black_Image = Image(:,:,2);
    [White_Features ] = Statastics_Mean_stdv_Var ( White_Image );
    [Black_Features] = Statastics_Mean_stdv_Var ( Black_Image );
    ColorFeature_Vector = [White_Features, Black_Features];
end

% hsv = rgb2hsv(Image);
% M1=mean(mean(hsv(:,:,1)));
% M2=mean(mean(hsv(:,:,2)));
% M3=mean(mean(hsv(:,:,3)));
% STD1=std(std(hsv(:,:,1)));
% STD2=std(std(hsv(:,:,2)));
% STD3=std(std(hsv(:,:,3)));
% SK1=skewness(skewness(hsv(:,:,1)));
% SK2=skewness(skewness(hsv(:,:,2)));
% SK3=skewness(skewness(hsv(:,:,3)));
%  ColorFeature_Vector=[M1,M2,M3,STD1,STD2,STD3,SK1,SK2,SK3];
end

