function [ Accuracy,Note ] = Voting_Classifier(NN_ACC_Mean,SVM_ACC_Mean,KNN_ACC_Mean)

Accuracy=max([NN_ACC_Mean,SVM_ACC_Mean,KNN_ACC_Mean]);
if Accuracy==NN_ACC_Mean
    Note={'..............Neural Network is the best classifier..............'};
    disp(Note);
    disp('Mean Accuracy= ');
    disp(Accuracy);
elseif Accuracy==SVM_ACC_Mean
    Note={'..............SVM is the best classifier..............'};
    disp(Note);
    disp('Mean Accuracy= ');
    disp(Accuracy);
elseif Accuracy==KNN_ACC_Mean
     Note={'..............KNN is the best classifier..............'};
    disp(Note);
    disp('Mean Accuracy= ');
    disp(Accuracy);
end
end