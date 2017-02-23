I = imread('male_face_2.jpg');
I = rgb2gray(I);

BW = imbinarize(I);

figure
imshowpair(I,BW,'montage')
