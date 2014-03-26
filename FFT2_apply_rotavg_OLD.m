function OutStruct = FFT2_apply_rotavg_OLD(MatIn,RotAvgVec);
%function OutStruct = FFT2_apply_rotavg(MatIn,RotAvgVec);

F = fft2(MatIn);
FBack = F;

%remove DC component
DC = F(1,1);
F(1,1) = 0;

FS = fftshift(F);
FSBack = FS;

[N N M]=size(FS);

%[X Y]=meshgrid(-N/2:N/2-1,-N/2:N/2-1); %orig line
[X Y]=meshgrid(linspace(-N/2,N/2,min(size(array))),...
                        linspace(-N/2,N/2,min(size(array))));

[theta rho]=cart2pol(X,Y);

%fprintf('initializing indices\n');

rho=round(rho);
I=cell(N/2+1,1);
for r=0:N/2
  I{r+1}=find(rho==r);
end

%fprintf('doing rotational average\n');

for m=1:M

  for r=0:N/2 
    FS(I{r+1}) = FS(I{r+1})/RotAvgVec(r+1,m);
  end
  
end


F = ifftshift(FS);
Amp = max(max(abs(F)));
AmpOut = Amp/sum(sum(abs(F)));
%AmpOut = Amp/sum(sum(abs(FSBack)));
%experiments:
%AmpOut = 1 - (DC-Amp)/DC;
AmpOut = Amp;
%AmpOut = Amp * DC/sum(sum(abs(FSBack)));
FMax = find(abs(F) == Amp);
F(abs(F) < abs(F(FMax(1)))) = 0;
%F(1,1) = DC; %replace DC component


IF = ifft2(F);
MatOut = IF;
OutStruct.MatOut = MatOut;
OutStruct.Amp = AmpOut;




