function [ newI, oriPTS, oriFaceRect ] = faceTune( I, rect, resolution, plot_opt )
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
%	Mymy, 20121205, 20130102

if nargin < 1, selfdemo; return; end
[h, w, dim]=size(I);
if dim >= 3, I = rgb2gray(I); end
if nargin < 2, rect = [1 1 w h]; end 
if nargin < 3, resolution = [57 76]; end
if nargin < 4, plot_opt = 1; end

% disp('---Tuning Face---');

% toolbox path setting
%addpath(genpath('../toolbox/FaceTuning'));
%addpath(genpath('./CoordinationRotate'));
I = imcrop(I, rect);
try 
	[~, PTS] = faceDetection(I);
catch
	fprintf('Warning, you should add the FaceTuning toolbox first!\n');
	return;
end
oriPTS = PTS;
oriPTS(1,:) = oriPTS(1,:) + rect(1);
oriPTS(2,:) = oriPTS(2,:) + rect(2);

if (isempty(PTS))
    newI = [];
    return;
end
% ===== Face Model =====
% ===rotation
% get eye region
% eyeShift = (PTS(1, 2) - PTS(1, 1) + PTS(1, 4) - PTS(1, 3)) / 2 * 0.4;
% rEyeRect = uint16([PTS(1, 1)-eyeShift PTS(2, 1)-eyeShift PTS(1, 2)-PTS(1, 1)+eyeShift*2 PTS(2, 2)-PTS(2, 1)+eyeShift*2]);
% lEyeRect = uint16([PTS(1, 3)-eyeShift PTS(2, 3)-eyeShift PTS(1, 4)-PTS(1, 3)+eyeShift*2 PTS(2, 4)-PTS(2, 3)+eyeShift*2]);
% rEyeData = I(rEyeRect(2):(rEyeRect(2)+rEyeRect(4)), rEyeRect(1):(rEyeRect(1)+rEyeRect(3)), :);
% lEyeData = I(lEyeRect(2):(lEyeRect(2)+lEyeRect(4)), lEyeRect(1):(lEyeRect(1)+lEyeRect(3)), :);
% % get eye center by getEigenEye
% rOut = getEigenEye(rEyeData);
% lOut = getEigenEye(lEyeData);

% eyeX1 = rOut.ci(2)+rEyeRect(1);
% eyeY1 = rOut.ci(1)+rEyeRect(2);
% eyeX2 = lOut.ci(2)+lEyeRect(1);
% eyeY2 = lOut.ci(1)+lEyeRect(2);
eyeX1 = PTS(1, 1) + (PTS(1, 2) - PTS(1, 1)) / 2;
eyeX2 = PTS(1, 3) + (PTS(1, 4) - PTS(1, 3)) / 2;
eyeY1 = (PTS(2, 1) + PTS(2, 2)) / 2;
eyeY2 = (PTS(2, 3) + PTS(2, 4)) / 2;
p1 = [eyeX1 eyeY1];
p2 = [eyeX2 eyeY2];
dx = p2(1) - p1(1);
dy = p2(2) - p1(2);
theta = atan2(double(dy), double(dx))*180/pi;
% disp('-Before rotate-');
% fprintf('theta: '); theta
% fprintf('PTS: '); PTS
if (real(theta) ~= 0)
     I = imrotate(I, theta, 'bicubic', 'crop');
%     [~, PTS] = faceDetect(I);   % get face and feature points again
%     [newI, PTS] = getTuningFace(I, resolution, plot_opt);
    
    PTS = rotation(PTS', [size(I, 2)/2 size(I, 1)/2], theta*(-1), 'radian')';
%     PTS = tmp(:, 1:end-1);
%     fprintf('Angle: %d\n', real(theta));
%     return;
end

% get fixed point
eyeCenter1 = PTS(1, 1) + (PTS(1, 2) - PTS(1, 1)) / 2;   % left eye center by x-coordination
eyeCenter2 = PTS(1, 3) + (PTS(1, 4) - PTS(1, 3)) / 2;   % right eye center by x-coordination
d = eyeCenter2 - eyeCenter1;
fixedXY = [eyeCenter1+d/2 PTS(2, 1)];
% the size of face rectangle = 1.8d * 2.2d
[height width] = size(I);
faceRect = uint16([fixedXY(1)-0.9*d fixedXY(2)-0.6*d 1.8 * d 2.2 * d]);   % [x1 y1 width height];
oriFaceRect = faceRect;
oriFaceRect(1) = oriFaceRect(1) + rect(1);
oriFaceRect(2) = oriFaceRect(2) + rect(2);
% Scaling the image to fixed size of 96*128
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
    figure; subplot(1, 2, 1); imshow(I); xlabel('Face with Facial Points after Tuning.')
   
    hold on
    rectangle('Position', faceRect);
    for i=1:size(PTS, 2)
        plot(PTS(1, i), PTS(2, i), 'r.');
    end
    hold off
    
    subplot(1, 2, 2); imshow(histeq(newI)); xlabel('Face after Resizing.')
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
