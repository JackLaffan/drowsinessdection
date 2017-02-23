im = imread('male_face_2.jpg');


imshow(im);
[centers, radii] = imfindcircles(im, [10, 20], 'Sensitivity', .99);
viscircles(centers, radii);
