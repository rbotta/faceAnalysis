%% LDP
% Local Directional Pattern 
%% Syntax
%% Description
%
% <html>
% </html>
%% Example
%%
%
im=imread('./demoDataset/sample.jpg');
[patchHist, lbpIm]=LDP(im, 8, 2, 1);
