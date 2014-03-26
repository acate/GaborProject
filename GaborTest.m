function GaborTest(Size,Orient,Phase,f);
%function GaborTest(Size,Orient,Phase,f);

% Size = 100; %Size for "meshgrid" size of meshgrid square in pixels
% Orient = pi/3; %0 = horizontal; pi/2 = vertical
% Phase = .25; %.5 = 180 degrees off
% f  = 4; %frequency; cycles per std., which is implicity 1

[x,y] = meshgrid(-Size:Size, -Size:Size);

m = exp(-((x/(Size/2)).^2)-((y/(Size/2)).^2)) .* ...
    sin(...
        (f/Size)*2*pi*(...
                     sin(Orient)*(x + (Size/f)*Phase) + cos(Orient)*(y + (Size/f)*Phase) ...
                     )...
        );


White = 255;
Black = 0;
Gray = (White+Black)/2;
Inc = White-Gray;

im = Gray+Inc*m;
figure, imagesc(im);
colormap(gray);
axis equal tight off