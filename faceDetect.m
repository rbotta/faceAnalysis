function [ bboxes ] = faceDetect( I, plot_opt )
%CV_FACEDETECT Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 1), selfdemo; return; end
if (nargin < 2), plot_opt=0; end

% reference from: http://www.mathworks.com/help/vision/ref/vision.cascadeobjectdetectorclass.html
% version should be 2012a at least
faceDetector = vision.CascadeObjectDetector;
bboxes = step(faceDetector, I);

if (plot_opt)
    figure, imshow(I), title('Detected faces');  
    hold on
    for i=1:size(bboxes, 1)
        rectangle('Position', bboxes(i, :));
    end
    hold off
end

function selfdemo
faceDetect(imread('./demoDataset/communitypeople.jpg'), 1);

