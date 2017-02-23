function [ closed ] = eyesClosed(Eyes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
closed = true;
BW2 = edge(Eyes,'Canny');

BW1 = imfill(BW2,'holes');

[centers, radii] = imfindcircles(BW1, [1, 4]);
imsize  = size(BW1);
middle = imsize(2)/2;
 
circleCount = [0,0];
    

viscircles(centers, radii);
if ~isempty(centers)
    %size(centers(:,1));
    %centers;

   if size(centers(:,1)) > 1
       closed = false;
      
   end
end
end

