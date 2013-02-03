function [ newI, oriPTS ] = faceTune( I, DETS, resolution, plot_opt )
%faceTune: tune the angle of the face to the horizontal
%
%	Usage:
%
%	Description:
%
%	Example:
%		I = imread('./demoDataset/images.jpeg');
%		faceTune(I, faceDetect(I, 1), [57 76], 1);
%
%	See also faceDetect

%	Category: faceAnalysis
%	hothero, Mymy, 20121205, 20130102, 20130203

if nargin < 1, selfdemo; return; end
if (ischar(I)), I = imread(I); end
if size(I, 3) >= 3, I = rgb2gray(I); end
if nargin < 2, DETS = faceDetect(I); end 
if nargin < 3, resolution = [57 76]; end
if nargin < 4, plot_opt = 0; end

[~, PTS] = facialFeatDetect(I, [DETS(1)+DETS(3)/2 DETS(2)+DETS(4)/2 DETS(3) 1]);
oriPTS = PTS;
oriI = I;

if (isempty(PTS))
    newI = [];
    return;
end
% ===== Face Model =====
% ===rotation
eyeX1 = PTS(1, 1) + (PTS(1, 2) - PTS(1, 1)) / 2;
eyeX2 = PTS(1, 3) + (PTS(1, 4) - PTS(1, 3)) / 2;
eyeY1 = (PTS(2, 1) + PTS(2, 2)) / 2;
eyeY2 = (PTS(2, 3) + PTS(2, 4)) / 2;
p1 = [eyeX1 eyeY1];
p2 = [eyeX2 eyeY2];
dx = p2(1) - p1(1);
dy = p2(2) - p1(2);
theta = atan2(double(dy), double(dx))*180/pi;

if (real(theta) ~= 0)
    addpath(genpath('./utils'));
    I = imrotate(I, theta, 'bicubic', 'crop');
    PTS = rotation(PTS', [size(I, 2)/2 size(I, 1)/2], theta*(-1), 'radian')';
end

% get fixed point
eyeCenter1 = PTS(1, 1) + (PTS(1, 2) - PTS(1, 1)) / 2;   % left eye center by x-coordination
eyeCenter2 = PTS(1, 3) + (PTS(1, 4) - PTS(1, 3)) / 2;   % right eye center by x-coordination
d = eyeCenter2 - eyeCenter1;
fixedXY = [eyeCenter1+d/2 PTS(2, 1)];
% the size of face rectangle = 1.8d * 2.2d
[height width] = size(I);
faceRect = uint16([fixedXY(1)-0.9*d fixedXY(2)-0.6*d 1.8 * d 2.2 * d]);   % [x1 y1 width height];

y2 = faceRect(2)+faceRect(4);
x2 = faceRect(1)+faceRect(3);
faceRect(faceRect <= 0) = 1;
if (x2 > width)
    x2 = width;
end
if (y2 > height)
    y2 = height;
end

newI = I(faceRect(2):y2, faceRect(1):x2);
if (isempty(newI))
    newI = [];
    return;
end
newI = imresize(newI, fliplr(resolution), 'bicubic');
newI = histeq(uint8(newI));

if (plot_opt)
    figure; subplot(1, 2, 1); imshow(oriI); xlabel('Face with Facial Points.')
   
    hold on
    rectangle('Position', DETS);
    for i=1:size(oriPTS, 2)
        plot(oriPTS(1, i), oriPTS(2, i), 'r.');
    end
    hold off
    
    subplot(1, 2, 2); imshow(histeq(newI)); xlabel('Face after Tunning and Resizing.')
end

function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);

%GETTUNINGFACE Summary of this function goes here
%   Detailed explanation goes here
% === Input ===
% I: image data
% resolution: [width height]
% === output ===
% newI: m*n gray image
% faceRect: [x1 y1 width height]
