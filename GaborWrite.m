FileNameBase = 'test'; 

ImageMat = ones(800);

BlockSize = 41; %odd number because meshgrid makes odd-number sized grids

White = 255;
Black = 0;
Gray = (White+Black)/2;
Amp = (White-Gray);


Orient = pi/4; %0 = horizontal; pi/2 = vertical
Phase = .25; %.5 = 180 degrees off???
f = 2; %frequency; cycles per std., which is implicity 1
ParamMat = [ ...
    40  40  pi/2  0 2;
    40  80     0  0 1;
    40  120    0 .5 1;  
    40  160    0  0 1; 
    40  200    0 .5 1; 
    40  240    0  0 1; 
    80  40 pi/2 .5 1;
    120  80     0  0 1;
    120  120    0 .5 1;  
    120  160    0  0 1; 
    120  200    0 .5 1; 
    120  240    0  0 1; 
    200  80     0  0 1;
    200  120    0  0 1;  
    200  160    0  0 1; 
    200  200    0  0 1; 
    200  240    0  0 1;   
    240  80     -pi/8  0 1;
    240  120    -pi/8  0 1;  
    240  160    -pi/8  0 1; 
    240  200    -pi/8  0 1; 
    240  240    -pi/8  0 1; 
    240  280    -pi/8  0 1;
    240  320    -pi/8  0 1;  
    240  360    -pi/8  0 1; 
    240  400    -pi/8  0 1; 
    240  440    -pi/8  0 1;    
    320  80     pi/8  0 1;
    320  120    pi/8  0 1;  
    320  160    pi/8  0 1; 
    320  200    pi/8  0 1; 
    320  240    pi/8  0 1; 
    320  280    pi/8  0 1;
    320  320    pi/8  0 1;  
    320  360    pi/8  0 1; 
    320  400    pi/8  0 1; 
    320  440    pi/8  0 1;    
    400  80     pi/8  0 1;
    400  120    pi/8 .5 1;  
    400  160    pi/8  0 1; 
    400  200    pi/8 .5 1; 
    400  240    pi/8  0 1;     
    400  280    pi/8  0 1;
    400  320    pi/8 .5 1;  
    400  360    pi/8  0 1; 
    400  400    pi/8 .5 1; 
    400  440    pi/8  0 1; 
    480  80     -pi/8  0 1;
    480  120    -pi/8 .5 1;  
    480  160    -pi/8  0 1; 
    480  200    -pi/8 .5 1; 
    480  240    -pi/8  0 1;     
    480  280    -pi/8  0 1;
    480  320    -pi/8 .5 1;  
    480  360    -pi/8  0 1; 
    480  400    -pi/8 .5 1; 
    480  440    -pi/8  0 1; 
    ];
    
    
ImageMat = ImageMat*Gray;


for Inc = 1:size(ParamMat,1)
    BlockM = GaborBlock(...
        (BlockSize-1)/2,...
        ParamMat(Inc,3),...
        ParamMat(Inc,4),...
        ParamMat(Inc,5) ...
        );
    Block = Gray+Amp*BlockM;
    ImageMat(...
        ParamMat(Inc,1) - (BlockSize-1)/2:ParamMat(Inc,1) + (BlockSize-1)/2, ...
        ParamMat(Inc,2) - (BlockSize-1)/2:ParamMat(Inc,2) + (BlockSize-1)/2 ...
        ) = ...
        Block;
end

figure, imagesc(ImageMat); colormap gray; axis equal tight off;

%imwrite(uint8(ImageMat),[FileNameBase '.png'],'png')