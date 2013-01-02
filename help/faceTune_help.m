%% faceTune
% tune the angle of the face to the horizontal
%% Syntax
%% Description
%
% <html>
% </html>
%% Example
%%
%
I = imread('./demoDataset/images.jpeg');
faceTune(I, faceDetect(I, 1), [57 76], 1);
