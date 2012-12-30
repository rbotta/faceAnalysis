function [patchHist, lbpIm] = LBP(im, patchSideNum, plotOpt)

if nargin<1, selfdemo; return; end
if nargin<2, patchSideNum=8; end	% divide image into patchSideNum*patchSideNum sub-blocks
if nargin<3, plotOpt=0; end

[h, w, dim]=size(im);
if dim>=3, im=rgb2gray(im); end

weight=2.^[0, 7, 6, 1, -inf, 5, 2, 3, 4];

% === zero padding
I2=zeros(h+2, w+2);
I2(2:h+1,2:w+1)=im;

blk=im2col(I2, [3 3], 'sliding');		% 3*3block to one col
for i=1:size((blk),2)
	blk(:, i)=blk(:, i)-blk(5, i);	% 5: the center index of a 3x3 square
end
colSum=weight*double(blk>0);
lbpIm=double(reshape(colSum, h, w));

% === Collect each block with patchSideNum size to histogram
subH=floor(h/patchSideNum);
subW=floor(w/patchSideNum);
% === Trim the image to avoid the default zero-padding for 'distinct';
lbpIm=lbpIm(1:subH*patchSideNum, 1:subW*patchSideNum);
lbpPatch=im2col(lbpIm, [subH, subW], 'distinct');
patchHist=zeros(256, patchSideNum*patchSideNum);   % 256: count of histogram pins
for i=1:size(lbpPatch,2)
	tmp=histc(lbpPatch(:,i), 0:255);
    %M = mean(tmp);      % normalize
    MAX = max(tmp);
    %MIN = min(tmp);
    patchHist(:,i) = tmp./MAX;%(tmp-M)/(MAX-MIN);
end
patchHist=patchHist(:);

if plotOpt
	subplot(1,2,1); imshow(im);
    xlabel('Original Img');
	subplot(1,2,2); imshow(lbpIm, []);
    xlabel('LBP Img')
% 	figure;
% 	for i=1:patchSideNum
% 		for j=1:patchSideNum
% 			k=(j-1)*patchSideNum+i;
% 			subplot(patchSideNum, patchSideNum, k);
% 			histc(lbpPatch(:,i), 0:255);
% 		end
% 	end
end

% ====== Self demo
function selfdemo
im=imread('sample.jpg');
[patchHist, lbpIm]=LBP(im, 8, 1);