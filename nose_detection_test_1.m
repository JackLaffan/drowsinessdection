clear all
clc
%Detect objects using Viola-Jones Algorithm

%To detect Nose
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',16);

%Read the input image
I = imread('male_face.jpg');

BB=step(NoseDetect,I);


figure,
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
title('Nose Detection');
hold off;