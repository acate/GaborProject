function OutStruct = MaxAmpfft2_noDC_chose_Amp(MatIn,LoCutOff,PadSize);
%function MatOut = MaxAmpfft2_noDC_chose(MatIn,LoCutOff,[PadSize]);
%PadSize is [nRows, nCols] for total image after padding
%LoCutOff is in units of matrix elements: to remove 1 cycle/image,
%LoCutOff=1;
%OutStruct.MatOut and OutStruct.Amp (abs of max amp)

% if diff(size(MatIn)) || ndims(MatIn) ~= 2 %i.e. not square matrix
%     error('2d input matrix must be square');
% end

if nargin < 3
    PadSize = size(MatIn);
end

F = fft2(MatIn,PadSize(1),PadSize(2));

DC = F(1,1);
FBack = F;
F(1,1) = 0;
FS = fftshift(F);

%find pixels in the binary image that fall within a radius of a gabor's
%center
Radius = LoCutOff;
FSCenter = round(PadSize/2);
%find PosMat indices that are within a radius of a marked pixel in the
%binary image
[I,J] = ind2sub(PadSize,1:prod(PadSize));
%rangesearch returns a cell array, with one row vector per target
idx = rangesearch([I' J'],FSCenter,Radius);
%any index of PosMat included in any row of idx corresponds to a "target" gabor
LoCutInds = cat(2,idx{:}); %reads out all entries (vectors) of idx, 
                            %and concatenates them into one long vector
FSBack = FS;                            
FS(LoCutInds) = 0;                            
F = ifftshift(FS);
Amp = max(max(abs(F)));
AmpOut = Amp/sum(sum(abs(FSBack)));
%experiments:
%AmpOut = 1 - (DC-Amp)/DC;
%AmpOut = Amp;
%AmpOut = Amp * DC/sum(sum(abs(FSBack)));
FMax = find(abs(F) == Amp);
F(abs(F) < abs(F(FMax(1)))) = 0;
%F(1,1) = DC; %replace DC component

IF = ifft2(F);
MatOut = imresize(IF,size(MatIn));

OutStruct.MatOut = MatOut;
OutStruct.Amp = AmpOut;



