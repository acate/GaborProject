function OutStruct = FFT2_choose_rotavg(MatIn,Band);
%function OutStruct = FFT2_apply_rotavg(MatIn,Band);
%Band argin is an integer from 1 to max radius of rotavg (actually,
%up to half that, if don't want freq. greater than Nyquist); this
%picks the radius of the band that will be used

F = fft2(MatIn);
FBack = F;

%remove DC component
DC = F(1,1);
F(1,1) = 0;

FS = fftshift(F);
FSBack = FS;

%-----------------------------------------------

%legacy stuff
M = 1;
N = min(size(FS));


[X Y]=meshgrid(linspace(-N/2,N/2,min(size(FS))),...
                        linspace(-N/2,N/2,min(size(FS))));

[theta rho]=cart2pol(X,Y);

%fprintf('initializing indices\n');

rho=round(rho);

FS(find(rho ~= Band)) = 0;
%-----------------------------------------------

F = ifftshift(FS);
Amp = max(max(abs(F)));
%AmpInd = find(abs(F) == max(max(abs(F))));
AmpOut = Amp/sum(sum(abs(F)));
%AmpOut = Amp/sum(sum(abs(FSBack)));
%experiments:
%AmpOut = 1 - (DC-Amp)/DC;
AmpOut = Amp/(2*DC); 
%AmpOut = Amp;
%AmpOut = Amp * DC/sum(sum(abs(FSBack)));
FMax = find(abs(F) == Amp);
F(abs(F) < abs(F(FMax(1)))) = 0;
%F(1,1) = DC; %replace DC component


IF = ifft2(F);
MatOut = IF;
OutStruct.MatOut = MatOut;
OutStruct.Amp = AmpOut;




