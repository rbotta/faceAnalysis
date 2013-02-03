function [ DETS, PTS ] = facialFeatDetect( I, DETS, plot_opt )
%FACEDETECT Summary of this function goes here
%   Detailed explanation goes here

% DETS:   4 x n matrix of face detections.
%         Each column is [x y scale confidence]' for a face detection.
%         (x,y) is the center of the face (top-left is 1,1)
%         <scale> is the half-width of the bounding box.
%         <confidence> is the face detection confidence.
% 
% PTS:    2 x 9 x n matrix of facial feature points.
% (eye * 4 including left and right, nose * 3, mouth * 2)
% 
% DESC:   m x n matrix of face descriptors. Each column is a
%         descriptor for the corresponding face detection.

if (~exist('opts', 'var'))
    init;
end

if (nargin < 1)
    I = imread('047640.jpg');   % for selfdemo
end
[height, width, dim] = size(I);
if (nargin < 2), DETS = [1 1 min([height width]) 1]; end
if (nargin < 3)
    plot_opt = false;
end

if (dim == 3)
    I = rgb2gray(I);
end

[DETS,PTS,~]=extfacedescs(opts,I,plot_opt,DETS);

end

