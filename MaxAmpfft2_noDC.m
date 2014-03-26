function MatOut = MaxAmpfft2_noDC(MatIn,PadSize);
%function MatOut = MaxAmpfft2(MatIn,[PadSize]);
%PadSize is [nRows, nCols] for total image after padding

% if diff(size(MatIn)) || ndims(MatIn) ~= 2 %i.e. not square matrix
%     error('2d input matrix must be square');
% end

if nargin < 2
    PadSize = size(MatIn);
end

F = fft2(MatIn,PadSize(1),PadSize(2));

DC = F(1,1);
F(1,1) = 0;
FMax = find(abs(F) == max(max(abs(F))));
F(abs(F) < abs(F(FMax(1)))) = 0;
%F(1,1) = DC; %replace DC component

IF = ifft2(F);
MatOut = imresize(IF,size(MatIn));



