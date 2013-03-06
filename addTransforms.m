clc
clear all
close all

% read in the matrices
matrixFile{4} = '/home/seth/Documents/Research/Projects/Open Projects/12-010 Concatenate Images/Transforms/23TO22.DAT';
matrixFile{3} = '/home/seth/Documents/Research/Projects/Open Projects/12-010 Concatenate Images/Transforms/21TO22.DAT';
matrixFile{2} = '/home/seth/Documents/Research/Projects/Open Projects/12-010 Concatenate Images/Transforms/20TO21.DAT';
matrixFile{1} = '/home/seth/Documents/Research/Projects/Open Projects/12-010 Concatenate Images/Transforms/19TO20.DAT';

mFID = zeros(1,4);
for i = 1:4
    mFID = fopen(matrixFile{i},'r');
    firstLine = fgetl(mFID);
    splitLine = regexp(firstLine,'[ ]+','split');
    % the file stores the data starting in field 6
    for j = 1:4
        for k = 1:4
            position = 5 + (j-1)*4 + k;
            matrix0{i}(j,k) = str2double(splitLine{position});
        end
    end
    fclose(mFID);
end

% make transforms that will make all be refed to file 1
matrix{1} = matrix0{1}(1:3,1:3);
matrix{2} = matrix0{1}(1:3,1:3) * matrix0{2}(1:3,1:3);
matrix{3} = matrix0{1}(1:3,1:3) * matrix0{2}(1:3,1:3) * matrix0{3}(1:3,1:3);
matrix{4} = matrix0{1}(1:3,1:3) * matrix0{2}(1:3,1:3) * matrix0{3}(1:3,1:3) * matrix0{4}(1:3,1:3);

displacement{1} = matrix0{1}(1:3,4);
displacement{2} = matrix0{1}(1:3,4) + matrix0{2}(1:3,4);
displacement{3} = matrix0{1}(1:3,4) + matrix0{2}(1:3,4) + matrix0{3}(1:3,4);
displacement{4} = matrix0{1}(1:3,4) + matrix0{2}(1:3,4) + matrix0{3}(1:3,4) + matrix0{4}(1:3,4);

for i = 1:4
    matrix1{i}(1:3,1:3) = matrix{i};
    matrix1{i}(4,1:4) = [0 0 0 1];
    matrix1{i}(1:3,4) = displacement{i};
end

% output the new matricies
matrix1File{1} = '/home/seth/Documents/Research/Projects/Open Projects/12-010 Concatenate Images/Transforms/Unified/19TO20.DAT';
matrix1File{2} = '/home/seth/Documents/Research/Projects/Open Projects/12-010 Concatenate Images/Transforms/Unified/19TO21.DAT';
matrix1File{3} = '/home/seth/Documents/Research/Projects/Open Projects/12-010 Concatenate Images/Transforms/Unified/19TO22.DAT';
matrix1File{4} = '/home/seth/Documents/Research/Projects/Open Projects/12-010 Concatenate Images/Transforms/Unified/19TO23.DAT';

for i = 1:4
    oFID = fopen(matrix1File{i},'w');
    fprintf(oFID,'SCANCO TRANSFORMATION DATA VERSION:   10R4_MAT:  ');
    fprintf(oFID,'%12.7E  %12.7E  %12.7E  %12.7E  ',matrix1{i}(1,:));
    fprintf(oFID,'%12.7E  %12.7E  %12.7E  %12.7E  ',matrix1{i}(2,:));
    fprintf(oFID,'%12.7E  %12.7E  %12.7E  %12.7E  ',matrix1{i}(3,:));
    fprintf(oFID,'%12.7E  %12.7E  %12.7E  %12.7E  ',matrix1{i}(4,:));
    fclose(oFID);
end