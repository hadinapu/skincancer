function [Shape_Features] = Shape_F( Segmented_Lession)

cellsdata = regionprops( Segmented_Lession,'all');
 Area=cat(1,cellsdata.Area);
Centroid=cat(1,cellsdata.Centroid);
MajorAxisLength=cat(1,cellsdata.MajorAxisLength);
MinorAxisLength=cat(1,cellsdata.MinorAxisLength);
Eccentricity=cat(1,cellsdata.Eccentricity);
ConvexArea=cat(1,cellsdata.ConvexArea);
Extrema=cat(1,cellsdata.Extrema);
Solidity=cat(1,cellsdata.Solidity);
Perimeter=cat(1,cellsdata.Perimeter);
boundingboxes = cat(1,cellsdata.BoundingBox);

for k = 1:size(boundingboxes,1)
L(k)=sqrt((128-Centroid(k,1))^2+(128-Centroid(k,2))^2);
end
f=min(L);
ss=find(L==f);
A=Area(ss);
% P=Perimeter(ss);
% Irregularity=(4*pi*A)/(P^2);
Shape_Features=[A];




end

