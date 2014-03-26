function Block = GaussianBlock(Size)
%function Block = GaussianBlock(Size)

[x,y] = meshgrid(-Size:Size, -Size:Size);

Block = exp(-((x/(Size/2)).^2)-((y/(Size/2)).^2));


