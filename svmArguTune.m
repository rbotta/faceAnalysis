function allRecog = svmArguTune(DsName, isPCA, isLDA, pcaNum, ldaNum)
%svmArguTune: find the best arguments for the max recog. rate
%
%	Usage:
%
%	Description:
%
%	Example:
%
%	See also toolboxInfo

%	Category: Utility
%	Mymy, 20121205, 20130102

addpath(genpath('./libsvm-3.11'));
load(DsName);

if nargin < 2, isPCA = 0; end
if nargin < 3, isLDA = 0; end
if nargin < 4, pcaNum = 100; end
if nargin < 5, ldaNum = 20; end


if isPCA
    meanVec = mean(DS.input, 2);
    DS.input = DS.input-meanVec*ones(1, pcaNum); 
end
if isLDA, DS = lda(DS, ldaNum); end

display('Start to tune argument....');
allG = [0.0125 0.025 0.05];% 0.1 0.2 0.5 0.8 1 2]; % better not smaller than 0.05
allC = [1 2 4];% 8 20 40 80 100];
allRecog = zeros(length(allG), length(allC));
for i=1:length(allG)
    for j=1:length(allC)
        allRecog(i, j) = svmtrain(DS.output', DS.input', sprintf('-q -t 2 -g %f -c %d -v 5', allG(i), allC(j)));  % 2: kernel functoin, 5: 5-fold
    end
end
display('Done!')
maxRecog = max(allRecog(:));
fprintf('The max recog. rate is %d\n', maxRecog);
[row col] = find(abs(allRecog - maxRecog) < 0.005);
fprintf('The best arguments are G:%d, C:%d\n', allG(row(1)), allC(col(1)));
% svmArguTune: find the best arguments for the max recog. rate
% === Input === 
% DsName: name od the DS
% isPCA: Apply PCA or not
% isLDA: Apply LDA or not
% pcaNum: No. of selected eigenvectors
% ldaNum: No. of discriminant vectors 
% === Output ===
% DS: an all recog. rate matrix
% === Example ===
% DS = goTuneSVMArgu('AgeDS_LBP', 1, 1);
% DS = goTuneSVMArgu('GenderDS_myLBP');
