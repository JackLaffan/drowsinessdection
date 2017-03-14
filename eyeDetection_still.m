clear all
clc
%Detect objects using Viola-Jones Algorithm

%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',16);

%Read the input Image
I = imread('closed.jpg');
figure,
imshow(I);
I = rgb2gray(I);

BB=step(EyeDetect,I);

%figure,
%imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
title('Eyes Detection');
Eyes=imcrop(I,BB);

figure,
imshow(Eyes);

eyesClosed(Eyes)

%BW = imbinarize(Eyes);

%BW1 = edge(Eyes,'Canny');

BW2 = edge(Eyes,'Canny');

figure,
imshow(BW2); 
%se = strel('disk',2);
BW1 = imfill(BW2,'holes');
%BW3 = imclose(BW1,se);
%imshowpair(Eyes,BW2,'montage')

figure, imshow(BW1);

%[centers, radii] = imfindcircles(BW1, [1, 4], 'ObjectPolarity','bright');
[rows, columns, numberOfColorChannels]  = size(BW1);
%viscircles(centers, radii, 'color', 'red');
%splits the image in two
middle = int32(columns/2)
leftHalf = BW1(:, 1:middle, :);
rightHalf=BW1(:, middle+1:end, :);
%middle = imsize(2)/2;

figure
imshow(rightHalf);
[rightCenters, radii] = imfindcircles(rightHalf, [1, 2]);
viscircles(rightCenters, radii);
figure
imshow(leftHalf);
[leftCenters, radii] = imfindcircles(leftHalf, [1, 4]);

%centers
%circleCount = [0,0]

viscircles(leftCenters, radii);

if ~isempty(rightCenters) && ~isempty(leftCenters)
    
    openEyes = 'Eyes are open';
    disp(openEyes)
    header1 = 'Eye State';
    fid=fopen('EyeState.txt','w');
    fprintf(fid, [ header1 '\n']);
    fprintf(fid, '%f %f \n', [~isempty(rightCenters)]');
    fclose(fid);
    
else
    closedEyes = 'Eyes are closed';
    disp(closedEyes)
    
end