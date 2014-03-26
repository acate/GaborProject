function OutStruct = MaxAmpfft2_rotavg(MatIn);

F = fft2(MatIn);

DC = F(1,1);
FBack = F;
F(1,1) = 0;
FS = fftshift(F);

RotAvgVec = ac_rotavg(FS);

F = ifftshift(FS);

IF = ifft2(F);
MatOut = IF;

OutStruct.MatOut = MatOut;
OutStruct.RotAvgVec = RotAvgVec;

