function RotAvgVec = ac_rotavg_rangesearch(MatIn)
%function RotAvgVec = ac_rotavg(MatIn)
%NOTE: abs(Matin) used for taking average, since MatIn assumed to
%be complex FFT

Center = round(size(MatIn)/2);
MaxRad = floor(min(size(MatIn))/2);

%find PosMat indices that are within a radius of a marked pixel in the
%binary image
[I,J] = ind2sub(size(MatIn),1:prod(size(MatIn)));

%initialize to hold average of each radius band
RotAvgVec = zeros(MaxRad,1);

%initialize to hold indices for each radius
RadCell = cell(MaxRad,1); 

%The entries in RadCell will be successive supersets.  That is,
%entry 2 will contain all indices in entry 1, plus some extra.
%To find the indices that correspond to a specific radius, need to
%find successive setdiffs.
IndCell = cell(MaxRad,1);

for Radius = 1:MaxRad
  %rangesearch returns a cell array, with one row vector per target
  idx = rangesearch([I' J'],Center,Radius);
  RadCell{Radius} = idx{:};
  if Radius > 1
      IndCell{Radius} = setdiff(RadCell{Radius},RadCell{Radius-1});
  else
      IndCell{Radius} = RadCell{Radius};
  end
  RotAvgVec(Radius) = mean(abs(MatIn(IndCell{Radius})));
end

