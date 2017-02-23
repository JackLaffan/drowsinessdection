clear all
clc
%Detect objects using Viola-Jones Algorithm

%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',16);

%Read the input Image
I = imread('me.jpg');
I = rgb2gray(I);

BB=step(EyeDetect,I);



figure,
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
title('Eyes Detection');
Eyes=imcrop(I,BB);
figure,imshow(Eyes);