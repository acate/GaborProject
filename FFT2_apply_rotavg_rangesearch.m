function OutStruct = FFT2_apply_rotavg_rangesearch(MatIn,RotAvgVec);
%function OutStruct = FFT2_apply_rotavg(MatIn,RotAvgVec);

F = fft2(MatIn);
FBack = F;

%remove DC component
DC = F(1,1);
F(1,1) = 0;

FS = fftshift(F);
FSBack = FS;

%-----------------------------------------------
Center = round(size(FS)/2);
MaxRad = floor(min(size(FS))/2);

%find PosMat indices that are within a radius of a marked pixel in the
%binary image
[I,J] = ind2sub(size(FS),1:prod(size(FS)));

%initialize to hold indices for each radius
RadCell = cell(MaxRad,1); 

%The entries in RadCell will be successive supersets.  That is,
%entry 2 will contain all indices in entry 1, plus some extra.
%To find the indices that correspond to a specific radius, need to
%find successive setdiffs.
IndCell = cell(MaxRad,1);

for Radius = 1:MaxRad
  %rangesearch returns a cell array, with one row vector per target
  idx = rangesearch([I' J'],Center,Radius);
  RadCell{Radius} = idx{:};
  if Radius > 1
      IndCell{Radius} = setdiff(RadCell{Radius},RadCell{Radius-1});
  else
      IndCell{Radius} = RadCell{Radius};
  end
  if Radius > MaxRad/2 %freq's greater than Nyquist
      FS(IndCell{Radius}) = 0;
  else
      FS(IndCell{Radius}) = FS(IndCell{Radius})/RotAvgVec(Radius);
  end
end
%Remove all high frequencies that lie beyond sweep of largest Radius
CornerInds = setdiff(1:prod(size(FS)),RadCell{Radius});
FS(CornerInds) = 0;
%-----------------------------------------------

F = ifftshift(FS);
Amp = max(max(abs(F)));
AmpOut = Amp/sum(sum(abs(F)));
%AmpOut = Amp/sum(sum(abs(FSBack)));
%experiments:
AmpOut = 1 - (DC-Amp)/DC;
%AmpOut = Amp;
%AmpOut = Amp * DC/sum(sum(abs(FSBack)));
FMax = find(abs(F) == Amp);
F(abs(F) < abs(F(FMax(1)))) = 0;
%F(1,1) = DC; %replace DC component


IF = ifft2(F);
MatOut = IF;
OutStruct.MatOut = MatOut;
OutStruct.Amp = AmpOut;




