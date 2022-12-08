function [stats,Neural_Network_results,ACC_Mean] = Neural_Network(Train_Feature_Vector,Train_label,Test_Feature_Vector,Test_label)
% Create a Pattern Recognition Network
hiddenLayerSize =50;
net = patternnet(hiddenLayerSize);

%Settings
net.layers{end}.transferFcn = 'purelin';
net.trainParam.max_fail = 400;

% In Neural Network, train & test data should be seprated by indexes so
% (net.divideFcn) was set up with divideind.
% remember indexes 1 to 182 for train & Validatin set and 183 to 198 for test set.
x=[Train_Feature_Vector;Test_Feature_Vector];
t=[Train_label;Test_label];

% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'divideind';  
net.divideMode = 'sample';  
testInd=[34,41,42,46,61,63,117,118,175,181];
TR=1:1:198;
TR( testInd)=[];
trainInd=TR(1,1:184);
valInd=TR(1,185:188);

% remember indexes 1 to 182 for train & Validatin set and 183 to 198 for test set.
[net.divideParam.trainInd,net.divideParam.valInd,net.divideParam.testInd] = divideind(198,trainInd,valInd,testInd);

% Choose Input and Output Pre/Post-Processing Functions
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Choose a Performance Function
 net.performFcn = 'mse';
 net.trainFcn = 'trainlm'; 

% Choose Plot Functions
net.plotFcns = {'plotperform'};

% Train the Network
t_v=zeros(198,3);
for i=1:1:198
 t_v(i,t(i))=1;
end
[net,tr] = train(net,x',t_v');

% Test the Network
x_test=x([tr.valInd,tr.testInd],:);
t_test=t([tr.valInd,tr.testInd],:);
y_test=net(x_test');
Predicted_Label = vec2ind(y_test)';
stats = confusionmatStats(t_test,Predicted_Label);


name_class = {'Common Nevus';'ATypical Neveus';'Melanoma'};
figure('name','Neural Network:  Confusion Matrix');
draw_cm(stats.confusionMat,name_class,3);
cols = [198 45 43; 37 64 180; 0 176 80; 0 0 0]/255;
Accuracy=stats.accuracy;
Sensitivity=stats.sensitivity;
Specificity=stats.specificity;
Precision=stats.precision;
Recall=stats.recall;
Neural_Network_results = table(Accuracy,Sensitivity,Specificity,Precision,Recall,'RowNames',name_class)
ACC_Mean=mean(Accuracy);
end




