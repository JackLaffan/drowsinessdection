clear all
clc
%Read the input image 
I = imread('me.jpg');
%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);
BB=step(MouthDetect,I);
figure,
imshow(I); hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig', 'MergeThreshold',16);
BB=step(EyeDetect,I);
hold on
for i = 1:size(BB,1)
rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');
end