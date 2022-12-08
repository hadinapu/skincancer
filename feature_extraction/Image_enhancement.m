function [ Contrast_adj_Image ] =Image_enhancement( scratched_image,ShowResult )
%   Adjust image intensity values or colormap.
Intensity_Adj_Img = imadjust((scratched_image), stretchlim((scratched_image)), [0 1]);
%   convert to grayscale
if ndims(Intensity_Adj_Img) > 2
    img_gray = rgb2gray(Intensity_Adj_Img);
else
    img_gray=Intensity_Adj_Img;
end
%   Create morphological structuring element
Structuring_Element = strel('disk',12);
%   Top-hat filtering.
Th_filtered_Image = imtophat(img_gray,Structuring_Element);

%   Adjust image intensity values or colormap.
Contrast_Adjusted_Image = imadjust(Th_filtered_Image);

%   2-D median filtering
Med_filt_Image = medfilt2(img_gray);

%   Contrast-limited Adaptive Histogram Equalization
Contrast_adj_Image = adapthisteq(Med_filt_Image);

if ~isempty(ShowResult)
    if ShowResult~=0
        figure('name',sprintf('Image Enhancement %d'),'NumberTitle','off');
        subplot(2,2,1); imshow(Th_filtered_Image); title('1. Top-hat Filtered Image');
        subplot(2,2,2);  imshow(Contrast_Adjusted_Image);title('2.Intensity Adjustment');
        subplot(2,2,3);  imshow(Med_filt_Image);title('3. Median Filtered Image');
        subplot(2,2,4);  imshow(Contrast_adj_Image);title('4. Histogram Equialsation')
    else
       return 
    end
end

end

