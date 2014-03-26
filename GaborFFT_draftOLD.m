
%%%% NEEDS FIXED so that ImageBlockFilt values are in 0-1 range

FileNameBase = 'testFFT'; 

% BinIm = rgb2gray(imread('A.png')); BinIm = 1 - BinIm;
InputImMat = rgb2gray(imread('2817a_healed_crop_sm.jpg'));
% BinIm = InputImMat;
% BinIm(BinIm < mean(mean(InputImMat))) = 0;
% BinIm(find(BinIm)) = 1;
% BinIm = double(BinIm);
InputImMat = double(InputImMat);

ImageMatSize = size(InputImMat);
ImageMat = ones(ImageMatSize);

BlockSize = 21; %odd number because meshgrid makes odd-number sized grids
GapSize = 6;

White = 255;
Black = 0;
Gray = (White+Black)/2;
AmpBase = (White-Gray);
    
ImageMat = ImageMat*Gray;

Orient = pi/4; %0 = horizontal; pi/2 = vertical
Phase = .25; %.5 = 180 degrees off???
Freq = 2; %frequency; cycles per std., which is implicity 1

PosMat = [];
Inc = 0;
for BlockRow = 1:ImageMatSize(1)/(BlockSize-1 + GapSize)
    for BlockCol = 1:ImageMatSize(2)/(BlockSize-1 + GapSize)
         if GapSize*(BlockRow) + BlockSize*(BlockRow) > ImageMatSize(1)
             continue
         elseif GapSize*(BlockCol) + BlockSize*(BlockCol) > ImageMatSize(2)
             continue
         end
        Inc = Inc + 1;
        PosMat(Inc,1:2) = ...
            [GapSize*(BlockRow) + BlockSize*(BlockRow) - (BlockSize-1)/2, ...
             GapSize*(BlockCol) + BlockSize*(BlockCol) - (BlockSize-1)/2 ...
             ];
    end
end


%for position jitter
JitterBase = GapSize; %must be <= GapSizeze
PosMat = round(PosMat + (rand(size(PosMat))-.5)*JitterBase);

% OrientVec = rand(size(PosMat,1),1)*pi;
% OrientVec = ones(size(PosMat,1),1)*0;
% PhaseVec = rand(size(PosMat,1),1)*.5;
% %PhaseVec = ones(size(PosMat,1),1)*0;
% FreqVec = rand(size(PosMat,1),1)*Freq + 1;
% FreqVec = ones(size(PosMat,1),1)*Freq;
% 
% AmpVec = rand(size(PosMat,1),1)*.9 + .1;
% AmpVec = ones(size(PosMat,1),1);
% 
% 
% %find pixels in the binary image that fall within a radius of a gabor's
% %center
% Radius = (BlockSize-1)/2;


% %find PosMat indices that are within a radius of a marked pixel in the
% %binary image
% %[i,j] = ind2sub(ImageMatSize,1:prod(ImageMatSize));
% [I,J] = find(BinIm);
% %rangesearch returns a cell array, with one row vector per target
% idx = rangesearch(PosMat,[I J],Radius);
% %any index of PosMat included in any row of idx corresponds to a "target" gabor
% PosMatInds = unique(cat(2,idx{:})); %reads out all entries (vectors) of idx, 
%                             %and concatenates them into one long vector

% OrientVec(PosMatInds) = pi/3;
% %OrientVec(PosMatInds) = rand(size(PosMatInds,2),1)*pi;
% PhasVec(PosMatInds) = rand(size(PosMatInds,2),1)*.5;
% %PhaseVec(PosMatInds) = .5;

%for use repeatedly in loop below
GaussWin = GaussianBlock((BlockSize-1)/2);

for Inc = 1:size(PosMat,1)
%     BlockM = GaborBlock(...
%         (BlockSize-1)/2,...
%         OrientVec(Inc),...
%         PhaseVec(Inc),...
%         FreqVec(Inc) ...
%         );
    ImBlock = InputImMat(...
        PosMat(Inc,1) - (BlockSize-1)/2:PosMat(Inc,1) + (BlockSize-1)/2, ...
        PosMat(Inc,2) - (BlockSize-1)/2:PosMat(Inc,2) + (BlockSize-1)/2 ...
        );
    ImBlockFilt = MaxAmpfft2(ImBlock);
    Block = Gray+AmpBase*(ImBlockFilt.*GaussWin);
    ImageMat(...
        PosMat(Inc,1) - (BlockSize-1)/2:PosMat(Inc,1) + (BlockSize-1)/2, ...
        PosMat(Inc,2) - (BlockSize-1)/2:PosMat(Inc,2) + (BlockSize-1)/2 ...
        ) = ...
        Block;
end

figure, imagesc(ImageMat); colormap gray; axis equal tight off;

imwrite(uint8(ImageMat),[FileNameBase '.png'],'png')