function [patchHist, lbpIm] = my_LBP(im, patchSideNum, plotOpt)

if nargin < 1, selfdemo; return; end
if nargin < 2, patchSideNum = 8; end
if nargin < 3, plotOpt = 0; end

[w, h, dim] = size(im);
if dim>=3, im=rgb2gray(im); end
% === zero padding
I2 = zeros(w+2, h+2);
I2(2:w+1,2:h+1) = im(:,:);

weight=[2^0 2^1 2^2;2^7 0 2^3;2^6 2^5 2^4];
patchHist = [];
blk = cell(3,3);
tmpSum = zeros(w,h,9);
for i = 1 : 3
    for j = 1 : 3
        blk{i,j} = (im - I2(i:w+i-1, j:h+j-1) )>0;
    end
end
for i = 1 : 9
    tmpSum(:,:,i) = blk{i}*weight(i);
end
lbpIm = sum(tmpSum,3);
lbpPatch = im2col(lbpIm, [floor(w/patchSideNum), floor(h/patchSideNum)], 'distinct');
for i = 1:patchSideNum * patchSideNum
    tmp = histc(lbpPatch(:,i),0:255);
    tmp = tmp / max(tmp);
    patchHist = [patchHist tmp'];
end

if plotOpt
	subplot(1,2,1); imshow(im);
	subplot(1,2,2); imshow(lbpIm, []);
	figure;
	for i=1:patchSideNum
		for j=1:patchSideNum
			k=(j-1)*patchSideNum+i;
			subplot(patchSideNum, patchSideNum, k);
			histc(lbpPatch(:,i),0:255);
		end
	end
end
% ==== Self demo                
function selfdemo
im = imread('sample.jpg');
[patchHist, lbpIm]=LBP(im, 8, 1);
