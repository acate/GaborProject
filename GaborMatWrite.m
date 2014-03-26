FileNameBase = 'test'; 

ImageMatSize = [800,800];
ImageMat = ones(ImageMatSize);

BlockSize = 31; %odd number because meshgrid makes odd-number sized grids
GapSize = 30;

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

OrientVec = rand(size(PosMat,1),1)*pi;
PhaseVec = rand(size(PosMat,1),1)*.5;
FreqVec = rand(size(PosMat,1),1)*2 + 1;

AmpVec = rand(size(PosMat,1),1)*.9 + .1;
%AmpVec = ones(size(PosMat,1),1);



for Inc = 1:size(PosMat,1)
    BlockM = GaborBlock(...
        (BlockSize-1)/2,...
        OrientVec(Inc),...
        PhaseVec(Inc),...
        FreqVec(Inc) ...
        );
    Block = Gray+(AmpBase*AmpVec(Inc))*BlockM;
    ImageMat(...
        PosMat(Inc,1) - (BlockSize-1)/2:PosMat(Inc,1) + (BlockSize-1)/2, ...
        PosMat(Inc,2) - (BlockSize-1)/2:PosMat(Inc,2) + (BlockSize-1)/2 ...
        ) = ...
        Block;
end

figure, imagesc(ImageMat); colormap gray; axis equal tight off;

imwrite(uint8(ImageMat),[FileNameBase '.png'],'png')