I = imread('coins.png');
e = edge(I, 'Canny');
%imshow(e);

radii = 15:1:40;
h = circle_hough(e, radii, 'same', 'normalise');

peaks = circle_houghpeaks(h, radii, 'nhoodxy', 15, 'nhoodr', 21, 'npeaks', 10);

imshow(im);
hold on;
for peak = peaks
    [x, y] = circlepoints(peak(3));
    plot(x+peak(1), y+peak(2), 'g-');
end
hold off