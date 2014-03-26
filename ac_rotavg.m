function RotAvgVec = ac_rotavg(MatIn)
% rotavg.m - function to compute rotational average of (square) array
% 
% function f = rotavg(array)
%
% array can be of dimensions N x N x M, in which case f is of 
% dimension NxM.  N should be even.
%


[N N M]=size(MatIn);

%[X Y]=meshgrid(-N/2:N/2-1,-N/2:N/2-1); %orig line
[X Y]=meshgrid(linspace(-N/2,N/2,min(size(MatIn))),...
                        linspace(-N/2,N/2,min(size(MatIn))));

[theta rho]=cart2pol(X,Y);

%fprintf('initializing indices\n');

rho=round(rho);
i=cell(floor(N/2),1); %note that center (if odd-sized) is NOT
                      %included now
for r=1:floor(N/2)
  i{r}=find(rho==r);
end

%fprintf('doing rotational average\n');

f=zeros(floor(N/2),M);

for m=1:M

  a=MatIn(:,:,m);
  a = abs(a); %adc added 1.4.2012 for FFT purposes
  for r=1:floor(N/2)
    f(r,m)=mean(a(i{r})); %orig line
  end
  
end

RotAvgVec = f;