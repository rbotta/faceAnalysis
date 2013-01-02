function faceBoxes = faceDetect( I, plot_opt )
%faceDetect: face detection
%
%	Usage:
%
%	Description:
%
%	Example:
%		faceBoxes = faceDetect(imread('./demoDataset/communitypeople.jpg'), 1);
%
%	See also faceTune

%	Category: faceAnalysis
%	Mymy, 20121205, 20130102

if nargin < 1, selfdemo; return; end
if nargin < 2, plot_opt = 0; end

% reference from: http://www.mathworks.com/help/vision/ref/vision.cascadeobjectdetectorclass.html
% version should be 2012a at least
faceDetector = vision.CascadeObjectDetector;
faceBoxes = step(faceDetector, I);

if (plot_opt)
    figure, imshow(I), title('Detected faces');  
    hold on
    for i=1:size(faceBoxes, 1)
        rectangle('Position', faceBoxes(i, :));
    end
    hold off
end

function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);

