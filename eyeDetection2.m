clear all
clc
%Detect objects using Viola-Jones Algorithm

%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',16);

%Read the input Image
I = imread('open1.jpg');
%figure,
%imshow(I);
I = rgb2gray(I);

BB=step(EyeDetect,I);

%figure,
%imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
title('Eyes Detection');
Eyes=imcrop(I,BB);

%figure,
%imshow(Eyes);

eyesClosed(Eyes)

%BW = imbinarize(Eyes);

%BW1 = edge(Eyes,'Canny');

BW2 = edge(Eyes,'Canny');

figure,
imshow(BW2); 

BW1 = imfill(BW2,'holes');
%imshowpair(Eyes,BW2,'montage')

figure, imshow(BW1);

[rows, columns, numberOfColorChannels]  = size(BW1);

%splits the image in two
middle = int32(columns/2)
leftHalf = BW1(:, 1:middle, :);
rightHalf=BW1(:, middle+1:end, :);
%middle = imsize(2)/2;

figure
imshow(rightHalf);

figure
imshow(leftHalf);

%circleCount = [0,0]

[centers, radii] = imfindcircles(leftHalf, [1, 4]);
[centers, radii] = imfindcircles(rightHalf, [1, 4]);
viscircles(centers, radii);

if ~isempty(centers)
    openEyes = 'Eyes are open';
    disp(openEyes)
else
    closedEyes = 'Eyes are closed';
    disp(closedEyes)
end
    
    %size(centers(:,1));
    %centers;

%size(centers(:,1))
%centers