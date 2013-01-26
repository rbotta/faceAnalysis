function faceInfoList = faceDatasetRead(dirName, extName, plotOpt, saveOpt, saveName)
%faceDatasetRead: get all face information into a cell array
%
%	Usage:
%
%	Description:
%
%	Example:
%		faceInfoList = faceDatasetRead('./demoDataset/Custom', 'jpg', 1, 1, 'faceInfoList.mat');
%
%	See also faceDetect, faceTune

%	Category: faceAnalysis
%	Mymy, 20121205, 20130102

if nargin < 1, selfdemo; return; end
if nargin < 2, extName = 'bmp'; end
if nargin < 3, plotOpt = 0; end
if nargin < 4, saveOpt = 0; end
if nargin < 5, saveName = 'faceInfoList.mat'; end

fileList = recursiveFileList(dirName, extName);

if isempty(fileList), fprintf('Can''t find any file!\n'); return; end

% ====== Check if the answer mat file exists
if exist([dirName '.mat'],'file'), load([dirName '.mat']);
else ansList = faceDatasetAnsCreate(dirName, 1);
end
    
faceInfoList = struct([]);
display('Start to get all face Info. ...');
for i = 1:length(fileList)
    tmpI = imread(fileList(i).path);
    faceRect = faceDetect(tmpI, plotOpt);
    
    if isempty(faceRect), 
		[h, w] = size(tmpI);
		faceRect = [1 1 w h];
		fprintf('progress==>%d / %d, Can''t find face!\n', i, length(fileList));  		
	end
    if size(faceRect, 1) > 1, [~, idx] = max(faceRect(:,3)); faceRect = faceRect(idx,:); end
    
    [~, PTS, faceRectWithTuning] = faceTune(tmpI, faceRect, [57 76], plotOpt);
    faceInfoList(i,1).filename = fileList(i).path;
    faceInfoList(i,1).faceRect = faceRect;
    faceInfoList(i,1).faceRectWithTuning = faceRectWithTuning;
    faceInfoList(i,1).PTS = PTS;
	
	if isfield(ansList,'gender'), faceInfoList(i,1).gender = ansList(i).gender; end
	if isfield(ansList,'age'), faceInfoList(i,1).age = ansList(i).age; end
	if isfield(ansList,'expression'), faceInfoList(i,1).expression = ansList(i).expression; end
	if isfield(ansList,'ID'), faceInfoList(i,1).ID = ansList(i).ID; end
	
    fprintf('progress==>%d / %d\n', i, length(fileList));
    if plotOpt, close all; end
end   

if saveOpt, save(saveName, 'faceInfoList'); end

display('Done.');

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);