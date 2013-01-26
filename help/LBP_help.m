%% LBP
% Local Binary Pattern 
%% Syntax
%% Description
%
% <html>
% </html>
%% Example
%%
%
im=imread('./demoDataset/sample.jpg');
[patchHist, lbpIm]=LBP(im, 8, 1);
