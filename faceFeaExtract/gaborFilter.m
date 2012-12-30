function [ TTT ] = gaborFilter( I, ROIs )
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
patch = zeros(1, imgSize*3*4);
TTT = []; %for LGBP
for s = 1:3
    for j = 1:4
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
        %roi_min = min( roiPatch);
        %roiPatch = roiPatch./roi_max;%(roiPatch - roi_min) ./ (roi_max - roi_min);
        I=output;%imresize(histeq(cropFace),[80 80]);
        [w h]=size(I);    
        I2 = zeros(w+2, h+2);
        I2(2:w+1,2:h+1) = I(:,:);
        %ttt = my_LBP(1, w, h, double(I), double(I2));
        ttt = LBP(I,1)';
        TTT = [TTT ttt];
        %patch(((s*j-1)*imgSize+1):s*j*imgSize) = roiPatch;
    end
end

end

