function GaborTestMovie(Size,Orient,Phase,f,PhaseMov,Frames,Dur);
%function GaborTestMovie(Size,Orient,Phase,f,Frames,Dur);

% Size = 100; %Size for "meshgrid" size of meshgrid square in pixels
% Orient = pi/3; %0 = horizontal; pi/2 = vertical
% Phase = .25; %.5 = 180 degrees off
% f  = 4; %frequency; cycles per std., which is implicity 1



im = GaborSub(Size,Orient,Phase,f);

figure, imagesc(im);
colormap(gray);
axis equal tight off

for FrameNo = 2:Frames
    im = GaborSub(Size,Orient,Phase + PhaseMov*FrameNo,f);
    imagesc(im);
    axis equal tight off
    pause(Dur)
end






function im = GaborSub(Size,Orient,Phase,f);
    
White = 255;
Black = 0;
Gray = (White+Black)/2;
Inc = White-Gray;


[x,y] = meshgrid(-Size:Size, -Size:Size);

m = exp(-((x/(Size/2)).^2)-((y/(Size/2)).^2)) .* ...
    sin(...
        (f/Size)*2*pi*(...
                     sin(Orient)*(x + (Size/f)*Phase) + cos(Orient)*(y + (Size/f)*Phase) ...
                     )...
        );
    
    
im = Gray+Inc*m;

   
return

