function [ Stat_Out ] = Statastics_Mean_stdv_Var ( Data )
Data = double(Data(:));

%Calculate Mean
sum1 = 0;
for i=  1:length(Data)
    sum1 = sum1+Data(i);
end
Mean = sum1/length(Data); %the mean

%Calculate Variance
sum2 = 0;
for i=  1:length(Data)
    sum2 = sum2 + (Data(i)- Mean).^2;
end
Variance = sum2/length(Data);

%Calculate Standard Deviation
sum3 = 0;
for i= 1:length(Data)
    sum3 = sum3 + ((Data(i) - Mean ).^2);
end
Standard_Deviation = sqrt(sum3/length(Data));

Stat_Out = [Mean,Variance,Standard_Deviation];

end

