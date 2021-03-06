% Detects eyes using Viola-Jones Algorithm, eyes are cropped and a Canny
% Edge Detector is applied to find the edge intensities. The holes are
% filled and the Hough Transform is applied to find the pupils.

% To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',16);

% Reads the input image and displays it
I = imread('still_images\open.jpg'); %Can be used for open or closed eye images
figure; imshow(I); title('Original Image')

I = rgb2gray(I); % Convert image to grayscale

% Returns Bounding Box values based on number of objects
BB=step(EyeDetect,I);

% Draws a bounding box on the image and displays
figure; imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
end
title('Eyes Detection');

% Crops bounding box around eyes
Eyes=imcrop(I,BB);

figure; imshow(Eyes); title('Cropped Eye Region');

% eyesClosed(Eyes) %unused function

% Canny Edge Detector applied
edgeDetect = edge(Eyes,'Canny');
figure; imshow(edgeDetect); title('Edge Detector')

% Circles filled
circFill = imfill(edgeDetect,'holes');
figure; imshow(circFill); title('Circle Fill')


[rows, columns, numberOfColorChannels]  = size(circFill);
% splits the image in two
middle = int32(columns/2)
leftHalf = circFill(:, 1:middle, :);
rightHalf=circFill(:, middle+1:end, :);

% Displays right eye, applies Hough Transform and draws circles on pupils
figure; imshow(rightHalf); title('Right Eye')
[rightCenters, radii] = imfindcircles(rightHalf, [1, 2]);
viscircles(rightCenters, radii);

% Displays left eye, applies Hough Transform and draws circles on pupils
figure; imshow(leftHalf); title('Left Eye')
[leftCenters, radii] = imfindcircles(leftHalf, [1, 4]);
viscircles(leftCenters, radii);

% Eyes are open if there is a circle in both the left and right eye 
% else eyes are closed
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