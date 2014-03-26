FileNameBase = 'test'; 

BlockSize = 41; %odd number because meshgrid creates odd-numbered length blocks
BigMatSize = BlockSize*20;


White = 255;
Black = 0;
Gray = (White+Black)/2;
Inc = (White-Gray);


Orient = pi/4; %0 = horizontal; pi/2 = vertical
Phase = .25; %.5 = 180 degrees off???
f = 2; %frequency; cycles per std., which is implicity 1

BigMat = ones(BigMatSize); 

for BlockRow = 1:BigMatSize/BlockSize
    for BlockCol = 1:BigMatSize/BlockSize
        
        BlockM = GaborBlock((BlockSize-1)/2,Orient,Phase,f);
        
        Block = Gray+Inc*BlockM;
        
        BigMat(...
            1 + BlockSize*(BlockRow-1):BlockSize*(BlockRow), ...
            1 + BlockSize*(BlockCol-1):BlockSize*(BlockCol) ...
            ) = ...
            Block;
        
    end
end

imwrite(uint8(BigMat),[FileNameBase '.png'],'png')