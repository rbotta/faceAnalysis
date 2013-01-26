function [patchHist ldpIm] = LDP( im, patch_num, rankK, plotOpt)
%LDP: Local Directional Pattern 
%
%	Usage:
%
%	Description:
%
%	Example:
%		im=imread('./demoDataset/sample.jpg');
%		[patchHist, lbpIm]=LDP(im, 8, 2, 1);
%
%	See also LBP, LTP

%	Category: Feature Extraction
%	Roger Jang, Mymy, 20130109, 20130109

if nargin < 1, selfdemo; return; end
if nargin < 2, patch_num = 8; end
if nargin < 3, rankK = 1; end
if nargin < 4, plotOpt = 0; end
[w h dim] = size(im);
if dim >= 3, im=rgb2gray(im); end   

% === zero padding 
I2 = zeros(w+2, h+2);
I2(2:w+1,2:h+1) = im(:,:);     
patchHist = zeros(1,256*patch_num*patch_num);

M_filter = zeros(3,3,8);   %LDP mask
M_filter(:,:,1) = [-3 -3 5; -3 0 5; -3 -3 5];
M_filter(:,:,2) = [-3 5 5; -3 0 5; -3 -3 -3];
M_filter(:,:,3) = [5 5 5; -3 0 -3; -3 -3 -3];
M_filter(:,:,4) = [5 5 -3; 5 0 -3; -3 -3 -3];
M_filter(:,:,5) = [5 -3 -3; 5 0 -3; 5 -3 -3];
M_filter(:,:,6) = [-3 -3 -3; 5 0 -3; 5 5 -3];
M_filter(:,:,7) = [-3 -3 -3; -3 0 -3; 5 5 5];
M_filter(:,:,8) = [-3 -3 -3; -3 0 5; -3 5 5];

blk = im2col(I2, [3 3], 'sliding');  %3*3block to one col
tmp = [];
for i = 1 : 8
    tmp = [tmp; abs(sum(blk.*repmat(reshape(M_filter(:,:,i),9,1), 1, w*h)))]; %col * LDP mask
end
[~, idx] = sort(tmp, 'descend');
eight_bit = zeros(size(tmp));
idx = idx(1:rankK,:) + repmat(0:8:size(tmp,2)*8-1, rankK, 1);
eight_bit(idx) = 1;
ldpIm = double(reshape(compactbit(eight_bit'), w, h));
ldpPatch = im2col(ldpIm, [floor(w/patch_num), floor(h/patch_num)], 'distinct');
for i = 1 : patch_num*patch_num
    tmp=histc(ldpPatch(:,i),0:255);
    MAX = max(tmp);
    patchHist(1,(i-1)*256+1:i*256) = tmp./MAX;
end
if plotOpt
	subplot(1,2,1); imshow(im);
    xlabel('Original Img')
	subplot(1,2,2); imshow(ldpIm, []);
    xlabel('LDP Img')
end

function cb = compactbit(b)
% b = bits array
% cb = compacted string of bits (using words of 'word' bits)
% code provided by Rob Fergus

[nSamples nbits] = size(b);
nwords = ceil(nbits/8);
cb = zeros([nSamples nwords], 'uint8');

for j = 1:nbits
    w = ceil(j/8);
    cb(:,w) = bitset(cb(:,w), mod(j-1,8)+1, b(:,j));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);