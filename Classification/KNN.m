function [stats,KNN_results,ACC_Mean] = KNN(Train_Feature_Vector,Train_label,Test_Feature_Vector,Test_label)
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

Predicted_Label = knnclassify(Test_Feature_Vector,Train_Feature_Vector,Train_label,4);
stats = confusionmatStats(Test_label,Predicted_Label);
name_class = {'Common Nevus';'ATypical Neveus';'Melanoma'};
figure('name','KNN: Confusion Matrix');
draw_cm(stats.confusionMat,name_class,max(unique(Train_label)));
cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0]/255;
Accuracy=stats.accuracy;
Sensitivity=stats.sensitivity;
Specificity=stats.specificity;
Precision=stats.precision;
Recall=stats.recall;
KNN_results = table(Accuracy,Sensitivity,Specificity,Precision,Recall,'RowNames',name_class)
ACC_Mean=mean(Accuracy);
end

