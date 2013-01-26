%% Knowing information of the face dataset
% The Face Analysis Toolbox provides several functions to read dataset and
% plot dataset information
%
% The following demonstrates how to read dataset, and then use "faceInfoPlot" to plot the information:
dataSet = '../demoDataset/PAL';
faceInfoList = faceDatasetRead(dataSet, 'bmp');
faceInfoPlot(faceInfoList);
%%
% Copyright 2012-2013 <http://mirlab.org/jang Jyh-Shing Roger Jang>.
