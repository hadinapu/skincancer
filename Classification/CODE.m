clc
close all
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Data

load('Feature1.mat');
Train_Feature_Vector=Features(1:182,:);
Train_label=tag(1:182,:);
Test_Feature_Vector=Features(183:198,:);
Test_label=tag(183:198,:);
%% Artificial Neural Network

[NN_stats,Neural_Network_table,NN_ACC_Mean] = Neural_Network(Train_Feature_Vector,Train_label,...
Test_Feature_Vector,Test_label);

% 
% %% SVM
[SVM_stats,SVM_table,SVM_ACC_Mean] =SVM_Clasiification_Performance(Train_Feature_Vector,Train_label,...
Test_Feature_Vector,Test_label);
% 
% %% KNN
[KNN_stats,KNN_table,KNN_ACC_Mean] = KNN(Train_Feature_Vector,Train_label,...
 Test_Feature_Vector,Test_label);
% % 
% %% Choose Best Classifier
% 
[ Accuracy,Note ] = Voting_Classifier(NN_ACC_Mean,SVM_ACC_Mean,KNN_ACC_Mean);

