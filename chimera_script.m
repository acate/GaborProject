%after running GaborFFT*.m:

x = ImageMat;
%run script again using diff. Gaussian window size
y = ImageMat;
imwrite(uint8((x + y + InputImMat)/3),'gabors_2_scales_chimera.png','png')