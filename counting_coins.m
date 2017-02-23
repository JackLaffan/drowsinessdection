I = imread('open1.jpg');
I = rgb2gray(I);
%I = imbinarize(I);
imshow(I)

BW1 = edge(I,'Canny');

BW2 = edge(I,'Prewitt');

imshowpair(I,BW2,'montage')

