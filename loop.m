n = 0.1:0.1:1;
x = 0.1:0.1:3;
for ni = n
    a = 1 / 3^ni;
    y = a * x.^ni;
    plot (x, y)
    hold on
end