% rotavg.m - function to compute rotational average of (square) array
% 
% function f = rotavg(array)
%
% array can be of dimensions N x N x M, in which case f is of 
% dimension NxM.  N should be even.
%


[N N M]=size(array);

[X Y]=meshgrid(-N/2:N/2-1,-N/2:N/2-1);

[theta rho]=cart2pol(X,Y);

%fprintf('initializing indices\n');

rho=round(rho);
i=cell(N/2+1,1);
for r=0:N/2
  i{r+1}=find(rho==r);
end

%fprintf('doing rotational average\n');

f=zeros(N/2+1,M);

for m=1:M

  a=array(:,:,m);
  a = abs(a); %adc added 1.4.2012 for FFT purposes
  for r=0:N/2
    f(r+1,m)=mean(a(i{r+1})); %orig line
  end
  
end
