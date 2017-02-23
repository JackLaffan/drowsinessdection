I = imread('male_face_2.jpg');
I = rgb2gray(I);
J = histeq(I);
%BW2 = imbinarize(I);
imshow(I)
%BW = imbinarize(J);
figure, imshow(J)

[centers, radii, metric] = imfindcircles(J,[10 1000]);

centersStrong5 = centers(1:5,:);
radiiStrong5 = radii(1:5);
metricStrong5 = metric(1:5);
