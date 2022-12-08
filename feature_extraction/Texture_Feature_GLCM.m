function [ Texture_Features ] = Texture_Feature_GLCM( Gray_Covar_Matrix )
% Function Calculates Texture Features 

GLCM_Size1 = size(Gray_Covar_Matrix,1);
GLCM_Size2 = size(Gray_Covar_Matrix,2);
GLCM_Size3 = size(Gray_Covar_Matrix,3);

Contrast = zeros(1,GLCM_Size3); % Contrast
Dissimilarity = zeros(1,GLCM_Size3); % Dissimilarity
Energy = zeros(1,GLCM_Size3); % Energy:
Entropy = zeros(1,GLCM_Size3); % Entropy:
Homogeneity = zeros(1,GLCM_Size3); % Homogeneity
Sum_of_sqaures_Variance  = zeros(1,GLCM_Size3); % Sum of sqaures: Variance
Inverse_Diff_norm = zeros(1,GLCM_Size3); % Inverse difference normalized (INN)
Inverse_Diff_Moment_norm = zeros(1,GLCM_Size3); % Inverse difference moment normalized

% checked p_x p_y p_xplusy p_xminusy
p_x = zeros(GLCM_Size1,GLCM_Size3); 
p_y = zeros(GLCM_Size2,GLCM_Size3); 
p_xplusy = zeros((GLCM_Size1*2 - 1),GLCM_Size3); 
p_xminusy = zeros((GLCM_Size1),GLCM_Size3); 


Sum_variance = zeros(1,GLCM_Size3); % Sum variance 
Sum_entropy = zeros(1,GLCM_Size3); % Sum entropy
Difference_variance = zeros(1,GLCM_Size3); % Difference variance 
Difference_entropy = zeros(1,GLCM_Size3); % Difference entropy 
Sum_average = zeros(1,GLCM_Size3); % Sum average

glcm_sum  = zeros(GLCM_Size3,1);
GLCM_mean = zeros(GLCM_Size3,1);
GLCM_var  = zeros(GLCM_Size3,1);



for k = 1:GLCM_Size3 % number glcms
    
    glcm_sum(k) = sum(sum(Gray_Covar_Matrix(:,:,k)));
    Gray_Covar_Matrix(:,:,k) = Gray_Covar_Matrix(:,:,k)./glcm_sum(k); % Normalize each glcm
    GLCM_mean(k) = mean2(Gray_Covar_Matrix(:,:,k)); % compute mean after norm
    GLCM_var(k)  = (std2(Gray_Covar_Matrix(:,:,k)))^2;
    
    for i = 1:GLCM_Size1
        
        for j = 1:GLCM_Size2
            %Contrast
            Contrast(k) = Contrast(k) + (abs(i - j))^2.*Gray_Covar_Matrix(i,j,k);
            %Dissimilarity
            Dissimilarity(k) = Dissimilarity(k) + (abs(i - j)*Gray_Covar_Matrix(i,j,k));
            %Energy
            Energy(k) = Energy(k) + (Gray_Covar_Matrix(i,j,k).^2);
            %Entropy
            Entropy(k) = Entropy(k) - (Gray_Covar_Matrix(i,j,k)*log(Gray_Covar_Matrix(i,j,k) + eps));
            %Homogeneity
            Homogeneity(k) = Homogeneity(k) + (Gray_Covar_Matrix(i,j,k)/( 1 + (i - j)^2));
            %Sum_of_sqaures_Variance
            % use the mean of the entire normalized glcm
            Sum_of_sqaures_Variance(k) = Sum_of_sqaures_Variance(k) + Gray_Covar_Matrix(i,j,k)*((i - GLCM_mean(k))^2);
            %Inverse difference normalized
            Inverse_Diff_norm(k) = Inverse_Diff_norm(k) + (Gray_Covar_Matrix(i,j,k)/( 1 + (abs(i-j)/GLCM_Size1) ));
            %Inverse difference moment normalized
            Inverse_Diff_Moment_norm(k) = Inverse_Diff_Moment_norm(k) + (Gray_Covar_Matrix(i,j,k)/( 1 + ((i - j)/GLCM_Size1)^2));
            %
        end
    end
end


for k = 1:GLCM_Size3
    
    for i = 1:GLCM_Size1
        
        for j = 1:GLCM_Size2
            p_x(i,k) = p_x(i,k) + Gray_Covar_Matrix(i,j,k);
            p_y(i,k) = p_y(i,k) + Gray_Covar_Matrix(j,i,k); % taking i for j and j for i
            if (ismember((i + j),[2:2*GLCM_Size1]))
                p_xplusy((i+j)-1,k) = p_xplusy((i+j)-1,k) + Gray_Covar_Matrix(i,j,k);
            end
            if (ismember(abs(i-j),[0:(GLCM_Size1-1)]))
                p_xminusy((abs(i-j))+1,k) = p_xminusy((abs(i-j))+1,k) +...
                    Gray_Covar_Matrix(i,j,k);
            end
        end
    end
    
end

% marginal probabilities are now available [1]
% p_xminusy has +1 in index for matlab (no 0 index)
% computing sum average, sum variance and sum entropy:
for k = 1:(GLCM_Size3)
    
    for i = 1:(2*(GLCM_Size1)-1)
        Sum_average(k) = Sum_average(k) + (i+1)*p_xplusy(i,k);
        % the summation for savgh is for i from 2 to 2*Ng hence (i+1)
        Sum_entropy(k) = Sum_entropy(k) - (p_xplusy(i,k)*log(p_xplusy(i,k) + eps));
    end
    
end
% compute sum variance with the help of sum entropy
for k = 1:(GLCM_Size3)
    
    for i = 1:(2*(GLCM_Size1)-1)
        Sum_variance(k) = Sum_variance(k) + (((i+1) - Sum_entropy(k))^2)*p_xplusy(i,k);
        % the summation for savgh is for i from 2 to 2*Ng hence (i+1)
    end
    
end
% compute difference variance, difference entropy,
for k = 1:GLCM_Size3
    % out.dvarh2(k) = var(p_xminusy(:,k));
    for i = 0:(GLCM_Size1-1)
        Difference_entropy(k) = Difference_entropy(k) - (p_xminusy(i+1,k)*log(p_xminusy(i+1,k) + eps));
        Difference_variance(k) = Difference_variance(k) + (i^2)*p_xminusy(i+1,k);
    end
end

Texture_Features = [Contrast; Dissimilarity; Energy; Homogeneity; Sum_of_sqaures_Variance; Inverse_Diff_norm; Inverse_Diff_Moment_norm; Sum_average; Sum_entropy; Sum_variance; Difference_entropy;Difference_variance];

Feature_Names = {'Contrast'; 'Dissimilarity' ; 'Energy'; 'Homogeneity' ; 'Sum_of_sqaures_Variance'; 'Inverse_Diff_norm'; 'Inverse_Diff_Moment_norm'; 'Sum_average'; 'Sum_entropy'; 'Sum_variance'; 'Difference_entropy'; 'Difference_variance'};

% xlswrite('Extracted_Texture_Features.xlsx',Feature_Names,1 ,'A');
% xlswrite('Extracted_Texture_Features.xlsx',Texture_Features,1 ,'B:C');
end
