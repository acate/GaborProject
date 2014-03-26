[x,y] = meshgrid(-100:100, -100:100);
m = exp(-((x/50).^2)-((y/50).^2)) .* sin(0.03*2*pi*x);
White = 255;
Black = 0;
Gray = (White+Black)/2;
Inc = White-Gray;
im = Gray+Inc*m;
figure, imagesc(im);
colormap(gray);
axis equal tight off