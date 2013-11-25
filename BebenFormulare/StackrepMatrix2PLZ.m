function [PLZ,PLZstack,PLzDist,StackrepMatrix] = StackrepMatrix2PLZ(OneEQReports)
% stack the data from the matrix to plz regions
% out= PLZ | PLZstack | distance | StackrepMatrix

dist = OneEQReports.distkmlist(:);
plz = str2double(OneEQReports.zip_input(:));
%Mx21 O.repMatrix..{'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','dam','dg'};
%                     1   2  3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19   20   21
%Mx10 O.matrixadd..[stockwerk0-3,stk3-6,stk6-10,stk11-20,stk20+,knall,grollen,ruck,schwanken,zittern]
%                      22          23      24     25     26     27     28       29     30      31
matrix = [OneEQReports.repMatrix OneEQReports.matrix_add] ;

%stack the plz data
plzunique = unique(plz);
StackrepMatrix = zeros(size(plzunique,1),size(matrix,2));
PLZ = zeros(size(plzunique,1),1); PLzDist = zeros(size(plzunique,1),1); PLZstack = zeros(size(plzunique,1),1);
HistPLzDist = zeros(numel(plzunique),3);
p = 0;
for k=1:numel(plzunique)
    ind = [];
    currplz = plzunique(k); 
    if ~isnan(currplz)
      p = p + 1;
      ind = find(plz==currplz);
      PLZ(p) = currplz;
      PLZstack(p) = numel(ind);
      PLzDist(p) = dist(ind(1));
      currMatrix = matrix(ind,:);
      StackrepMatrix(p,:) = sum(currMatrix,1); 
      tmpK = find(currMatrix(:,4)>0);
      StackrepMatrix(p,4) = numel(tmpK);      %K value can be 1,2,3,4,5
      tmpI = find(currMatrix(:,2)>0);
      StackrepMatrix(p,2) = numel(tmpI);      %I value can be 1,2
      tmpM = find(currMatrix(:,6)>0);
      StackrepMatrix(p,6) = numel(tmpM);      %M value can be 1,2
      tmpO = find(currMatrix(:,8)>0);
      StackrepMatrix(p,8) = numel(tmpO);      %O value can be 1,2 
      tmpW = find(currMatrix(:,16)>0);
      StackrepMatrix(p,16) = numel(tmpW);      %W value can be 1,2      
      tmpZ = find(currMatrix(:,19)>0);
      StackrepMatrix(p,19) = numel(tmpZ);      %Z value can be 1,2      
      clear tmpI tmpK tmpM tmpO tmpW tmpZ; 
    end
end   
PLZ = PLZ(1:p,:);
PLZstack = PLZstack(1:p,:);
PLzDist = PLzDist(1:p,:);
StackrepMatrix = StackrepMatrix(1:p,:);

%sortiere nach Epizentraldistanz
A = sortrows([PLZ PLzDist PLZstack StackrepMatrix],2);
PLZ = A(:,1); PLzDist = A(:,2); PLZstack = A(:,3); 
StackrepMatrix = A(:,4:size(A,2));

fprintf('StackrepMatrix2PLZ: %g Meldungen(numel(plz), %g Unique PLZ, %g StackrepMatrix(size,1))\n',numel(plz),numel(unique(plz)),size(StackrepMatrix,1));

