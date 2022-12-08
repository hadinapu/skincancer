clear all
clc
close all
%%%%%%%%%%%%%%%%%%%%%%%%%
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
%% KNN
for ii=1:1:20
Predicted_Label = knnclassify(Test,Train,Train_Labels,ii,'euclidean','nearest');
stats = confusionmatStats(Test_labels,Predicted_Label);
name_class = {'Common Nevus';'ATypical Neveus';'Melanoma'};
% figure('name','KNN: Confusion Matrix');
% draw_cm(stats.confusionMat,name_class,max(unique(Train_label)));
cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0]/255;
Accuracy=stats.accuracy;
Sensitivity=stats.sensitivity;
Specificity=stats.specificity;
Precision=stats.precision;
Recall=stats.recall;
% SVM_results = table(Accuracy,Sensitivity,Specificity,Precision,Recall,'RowNames',name_class)
ACC_Mean(ii)=mean(Accuracy);
end