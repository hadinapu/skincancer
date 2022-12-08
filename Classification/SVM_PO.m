clear all
clc
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Data
load('Feature1.mat');
Train_Feature_Vector=Features(1:182,:);
Train_label=tag(1:182,:);
Test_Feature_Vector=Features(183:198,:);
Test_label=tag(183:198,:);

x=[Train_Feature_Vector;Test_Feature_Vector];
t=[Train_label;Test_label];
testInd=[34,41,42,46,61,63,117,118,175,181];
TR=1:1:198;
TR( testInd)=[];
trainInd=TR(1,1:185);
valInd=TR(1,186:end);

Train = x(trainInd,:);
Train_Labels = t(trainInd,:);
Test = x([valInd,testInd],:);
Test_labels =  t([valInd,testInd],:);

%% SVM Parameter Optimization
C=2.^(-5:15);
Gama=2.^(-15:3);

% Grid Search
for ii=1:1:21
    for jj=1:1:19
        
u=unique(Train_Labels);
numClasses=length(u);

%build models
for k=1:numClasses
    %Vectorized statement that binarizes Group
    %where 1 is the current class and 0 is all other classes
    G1vAll=(Train_Labels==u(k));
    models(k) = svmtrain(Train,G1vAll,'kernel_function','rbf','rbf_sigma',Gama(jj),'boxconstraint',C(ii));
end

Predicted_label = zeros(length(Test(:,1)),1);
for j=1:size(Test,1)
    for k=1:numClasses
        if(svmclassify(models(k),Test(j,:)))
            Predicted_label(j) = k;  
        else
           Predicted_label(j) = 1;  
        end
        
    end
end


stats = confusionmatStats(Test_labels,Predicted_label);
name_class = {'Common Nevus';'ATypical Neveus';'Melanoma'};
% figure('name','SVM: Confusion Matrix');
% draw_cm(stats.confusionMat,name_class,max(unique(Train_label)));
cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0]/255;
Accuracy=stats.accuracy;
Sensitivity=stats.sensitivity;
Specificity=stats.specificity;
Precision=stats.precision;
Recall=stats.recall;
% SVM_results = table(Accuracy,Sensitivity,Specificity,Precision,Recall,'RowNames',name_class)
ACC_Mean(ii,jj)=mean(Accuracy);
    end
end