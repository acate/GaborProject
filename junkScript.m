ImageMatSize = [800,800];
ImageMat = ones(ImageMatSize);

BlockSize = 61; %odd number because meshgrid makes odd-number sized grids
GapSize = 0;

White = 255;
Black = 0;
Gray = (White+Black)/2;
AmpBase = (White-Gray);   

BlockM = GaborBlock(...
        (BlockSize-1)/2,...
        0,...
        0,...
        3, ...
        1, ...
        1, ...
        1, ...
         .5 ...
        );
    
    
    Block = Gray+AmpBase*BlockM;
    
    figure, imagesc(Block), colormap gray, axis equal tight off