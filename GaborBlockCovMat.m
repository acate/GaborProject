function Block = GaborBlock(Size,Orient,Phase,f,Amp,StdX,StdY,CovXY)
%function GaborTest(Size,Orient,Phase,f,[Amp],[CovMat])

% Size = 100; %Size for "meshgrid" size of meshgrid square in pixels
% Orient = pi/3; %0 = horizontal; pi/2 = vertical
% Phase = .25; %.5 = 180 degrees off
% f  = 4; %frequency; cycles per std., which is implicity 1
% Amp = amplitude multiplier, multiplies times AmpBase
% CovMat = covariance matrix for the Gaussian contrast envelope

if nargin == 5
    StdX = 1; StdY = 1; CovXY = 0;
elseif nargin == 4
    StdX = 1; StdY = 1; CovXY = 0;
    Amp = 1;
elseif nargin > 5 && nargin ~= 8
    error('must include all three covariance matrix parameters, or none');
end

[x,y] = meshgrid(-Size:Size, -Size:Size);

Block = Amp*exp(...
            -((x/((Size/2)*StdX)).^2) ...
            -((CovXY*x/(Size/2)).*(CovXY*y/(Size/2))) ...
            -((y/((Size/2)*StdY)).^2) ...
            ).* ...
    sin(...
        (f/Size)*2*pi*(...
                     sin(Orient)*(x + (Size/f)*Phase) + cos(Orient)*(y + (Size/f)*Phase) ...
                     )...
        );

% White = 255;
% Black = 0;
% Gray = (White+Black)/2;
% Inc = White-Gray;
% 
% im = Gray+Inc*Block;
