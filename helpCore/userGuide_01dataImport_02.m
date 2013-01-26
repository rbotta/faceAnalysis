%% Knowing the basic example of gender classification
% The Face Analysis Toolbox provides several functions to read dataset and
% plot dataset information
%
% The following demonstrates how to create DS, and then use "knncLoo" to
% see the recognition rate. 
faceInfoList = faceDatasetRead('../demoDataset/Custom', 'jpg');
DS = faceDsCreate(faceInfoList, 'gender', 'LBP', 1);
knncPrm.k = 1;
[recogRate, computed, nearestIndex] = knncLoo(DS, knncPrm);
fprintf('Recog. rate = %.2f%%\n', 100*recogRate);

%%
% Copyright 2012-2013 <http://mirlab.org/jang Jyh-Shing Roger Jang>.
