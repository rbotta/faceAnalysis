function DS = faceDsCreate(faceInfo, type, feaName, saveOpt, DsName)
%faceDsCreate: create face DS for classification
%
%	Usage:
%
%	Description:
%
%	Example:
%		DS=faceDsCreate(faceDatasetRead('./demoDataset/Custom', 'jpg'), 'gender', 'LBP', 1);
%
%	See also 

%	Category: faceAnalysis
%	Mymy, 20130114, 20130114

if nargin < 1, selfdemo; return; end
if nargin < 2, type = 'gender'; end
if nargin < 3, feaName = 'LBP'; end
if nargin < 4, saveOpt = 1; end
if nargin < 5, DsName = [type 'DS_' feaName '.mat']; end

DS.dataName = type;

display('Start to create DS....');

for i = 1:length(faceInfo)
    cropFace = imcrop(imread(faceInfo(i).filename),faceInfo(i).faceRectWithTuning);
    [~, ~, dim]=size(cropFace);
    if dim>=3, cropFace=rgb2gray(cropFace); end
    switch feaName
        case 'LBP'
            DS.input(:, i) = LBP(cropFace)';
        case 'LDP'
            DS.input(:, i) = LDP(cropFace)'; 
        case 'LTP'
            DS.input(:, i) = LTP(cropFace)'; 
        otherwise
            display('We have no this method!');
    end
    switch type
        case 'age'
            if (ageInfo.age <= 75)    
                DS.output(1, i) = ceil(ageInfo.age/15);    % 15: age intervsl
            else
                DS.output(1, i) = 5;
            end
        case 'gender'
			if strcmp(faceInfo(i).gender, 'male'), DS.output(1,i) = 1; end
			if strcmp(faceInfo(i).gender, 'female'), DS.output(1,i) = 2; end
		case 'expression'
        otherwise
            display('We have no this type!');
	end
	fprintf('progress==>%d / %d\n', i, length(faceInfo));
end

DS.inputName = cell(1,size(DS.input, 1));    % tmp to present feature
switch type
	case 'age'
		DS.outputName = {'1-15', '16-30', '31-45', '46-60', '61-'};
	case 'gender'
		DS.outputName = {'male', 'female'};
	case 'expression'
	otherwise
		display('We have no this type!');
end

if saveOpt, save(DsName, 'DS'); end
display('Done.');

function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);