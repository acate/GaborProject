function OutStruct = FFT2_apply_rotavg(MatIn,RotAvgVec);
%function OutStruct = FFT2_apply_rotavg(MatIn,RotAvgVec);

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
i=cell(floor(N/2),1); %note that center (if odd-sized) is NOT
                      %included now
for r=1:max(max(rho))
  i{r}=find(rho==r);
end


f=zeros(floor(N/2),M);

for m=1:M

  for r=1:floor(N/2)
    if r > floor(N/2)/2 %freq's greater than Nyquist (w.r.t max radius)
      FS(i{r}) = 0;
    else
      FS(i{r}) = FS(i{r})/RotAvgVec(r);
    end
  end
  
end

%Remove all high frequencies that lie beyond sweep of largest Radius
FS(find(rho > floor(N/2))) = 0;
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




