rgbImage=imread('eqtest.jpg');
subplot(2, 2, 1);
imshow(rgbImage);
% Get sizes of the images.
[rows, columns, numberOfColorChannels] = size(rgbImage);
middleColumn = int32(columns/2)
title('Right Half', 'FontSize', 25);
% Split them up.
leftHalf = rgbImage(:, 1:middleColumn, :);
rightHalf=rgbImage(:, middleColumn+1:end, :);
% Display them.
subplot(2, 2, 3);
imshow(leftHalf);
title('Left Half', 'FontSize', 25);
subplot(2, 2, 4);
imshow(rightHalf);
title('Right Half', 'FontSize', 25);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 