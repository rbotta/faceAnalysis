function [ patch ] = gaborFilter( I, ROIs )
%PERFECTGABORFILTER Summary of this function goes here
%   Detailed explanation goes here

% check if I is normalized??

if (size(I, 3) == 3)
    I = rgb2gray(I);
end

if (nargin < 2)
    ROIs = [[1 1 size(I, 2) size(I, 1)]];
end

G = getGaborBank;
% imgSize = size(I, 1) * size(I, 2);
imgSize = 0;
% the amount of all ROIs region
for i=1:size(ROIs, 1)
    imgSize = imgSize + (ROIs(i, 3) - ROIs(i, 1) + 1) * (ROIs(i, 4) - ROIs(i, 2) + 1);
end
patch = zeros(1, imgSize*5*8);

for s = 1:5
    for j = 1:8
        output = imfilter(I,G{s,9-j});
        output = sqrt(double(real(output).*real(output)...
            + imag(output).*imag(output))); 
        
        % collect all ROIs gabor
        tmp = 1;
        roiPatch = zeros(1, imgSize);
        for i=1:size(ROIs, 1)
            im = output(ROIs(i, 2):ROIs(i, 4), ROIs(i, 1):ROIs(i, 3));
            roiSize = size(im, 1) * size(im, 2);
            roiPatch(tmp:roiSize+tmp-1) = reshape(im, 1, roiSize);
            tmp = tmp + roiSize;
        end
        
        % normalization
        roi_max = max( roiPatch);
        roi_min = min( roiPatch);
        roiPatch = (roiPatch - roi_min) ./ (roi_max - roi_min);
        
        patch(((s*j-1)*imgSize+1):s*j*imgSize) = roiPatch;
    end
end

end

