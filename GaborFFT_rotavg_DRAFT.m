FileNameBase = 'ac_rotavg_DRAFT'; 

% BinIm = rgb2gray(imread('A.png')); BinIm = 1 - BinIm;
InputImMat = rgb2gray(imread('2817a_healed_crop_sm.jpg'));
%Crop it
%InputImMat = InputImMat(1:600,101:end-100);
InputImMat = rgb2gray(imread('A.png'));
%use with binary input images:
InputImMat(InputImMat == 0) = 1;

InputImMat = double(InputImMat);

ImageMatSize = size(InputImMat);
ImageMat = ones(ImageMatSize);

BlockSize = 61; %odd number because meshgrid makes odd-number sized grids
GapSize = 4;

White = 255;
Black = 0;
Gray = (White+Black)/2;
AmpBase = (White-Gray);
    
ImageMat = ImageMat*Gray;

% Orient = pi/4; %0 = horizontal; pi/2 = vertical
% Phase = .25; %.5 = 180 degrees off???
% Freq = 2; %frequency; cycles per std., which is implicity 1

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
JitterBase = GapSize; %must be <= GapSize
PosMat = round(PosMat + (rand(size(PosMat))-.5)*JitterBase);


%for use repeatedly in loop below
GaussWin = GaussianBlock((BlockSize-1)/2);

RotAvgMat = [];

for Inc = 1:size(PosMat,1)

    ImBlock = InputImMat(...
        PosMat(Inc,1) - (BlockSize-1)/2:PosMat(Inc,1) + (BlockSize-1)/2, ...
        PosMat(Inc,2) - (BlockSize-1)/2:PosMat(Inc,2) + (BlockSize-1)/2 ...
        );
    OutStruct = MaxAmpfft2_rotavg(ImBlock.*GaussWin);
    RotAvgMat(1:length(OutStruct.RotAvgVec),Inc) = ...
              OutStruct.RotAvgVec;
    
end

AvgRotAvg = mean(RotAvgMat,2)*1;

AmpVec = zeros(1,size(PosMat,1));

for Inc = 1:size(PosMat,1)
              
    ImBlock = InputImMat(...
        PosMat(Inc,1) - (BlockSize-1)/2:PosMat(Inc,1) + (BlockSize-1)/2, ...
        PosMat(Inc,2) - (BlockSize-1)/2:PosMat(Inc,2) + (BlockSize-1)/2 ...
        );
    OutStruct = FFT2_apply_rotavg(ImBlock.*GaussWin,AvgRotAvg);    
    ImBlockFilt = OutStruct.MatOut;
    AmpVec(Inc) = OutStruct.Amp; 
    
    ImBlockFilt = ImBlockFilt/max(max(ImBlockFilt)); %normalize to 0-1
    Block = ImBlockFilt.*GaussWin;
    ImageMat(...
        PosMat(Inc,1) - (BlockSize-1)/2:PosMat(Inc,1) + (BlockSize-1)/2, ...
        PosMat(Inc,2) - (BlockSize-1)/2:PosMat(Inc,2) + (BlockSize-1)/2 ...
        ) = ...
        Block;
end

AmpVec = norminv(AmpVec,mean(AmpVec),std(AmpVec));
AmpVec = AmpVec-min(AmpVec);
AmpVec = AmpVec/max(AmpVec);
% $$$ AmpVec = normcdf(AmpVec,mean(AmpVec),std(AmpVec));
% $$$ AmpVec = AmpVec/mean(AmpVec);
% $$$ AmpVec = AmpVec/std(AmpVec);
% $$$ AmpVec = AmpVec/max(AmpVec);







for Inc = 1:size(PosMat,1)
    ImBlock = ImageMat(...
        PosMat(Inc,1) - (BlockSize-1)/2:PosMat(Inc,1) + (BlockSize-1)/2, ...
        PosMat(Inc,2) - (BlockSize-1)/2:PosMat(Inc,2) + (BlockSize-1)/2 ...
        );    
    Block = Gray+(AmpBase*AmpVec(Inc))*(ImBlock);
    ImageMat(...
        PosMat(Inc,1) - (BlockSize-1)/2:PosMat(Inc,1) + (BlockSize-1)/2, ...
        PosMat(Inc,2) - (BlockSize-1)/2:PosMat(Inc,2) + (BlockSize-1)/2 ...
        ) = ...
        Block;    
end
    
figure, imagesc(abs(ImageMat)); colormap gray; axis equal tight off;

imwrite(uint8(abs(ImageMat)),[FileNameBase '.png'],'png')