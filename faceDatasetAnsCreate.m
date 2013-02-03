function ansList = faceDatasetAnsCreate( dirName, saveOpt)
%faceDatasetAnsCreate: create all answer from dataset
%
%	Usage:
%
%	Description:
%
%	Example:
%		ansList = faceDatasetAnsCreate('./demoDataset/Custom');
%
%	See also faceDatasetRead

%	Category: faceAnalysis
%	Mymy, 20121205, 20130102

if nargin < 1, selfdemo; return; end
if nargin < 2, saveOpt = 1; end

existDataset = {'PAL', 'bmp'; 'Caltech', 'jpg'; 'Custom', 'jpg'; 'JAFFE', 'tiff'; 'ComputerScience', 'jpg'};
name = split(dirName, '/');
name = name{length(name)};
display('Start to create answer list....')
switch name
	case existDataset{1,1}    %PAL
		fprintf('Choose %s dataset.\n', existDataset{1,1});
		fileList = recursiveFileList(dirName, existDataset{1,2});
		for i = 1:length(fileList)
			ansList(i,1).name = fileList(i).name;
			if isempty(strfind(fileList(i).name, 'female')) ansList(i,1).gender = 'male';
			else ansList(i,1).gender = 'female';
			end
			tmp = strrep(fileList(i).name, 'male', '*');
			tmp = split(tmp, '*');
			ansList(i,1).age = str2double(tmp{2}(1:2));
			fprintf('progress==>%d / %d\n', i, length(fileList));
		end	
	case existDataset{2,1}    %Caltech
		fprintf('Choose %s dataset.\n', existDataset{2,1});
		fileList = recursiveFileList(dirName, existDataset{2,2});
		for i = 1:length(fileList)
			ansList(i,1).name = fileList(i).name;
			if strcmp(fileList(i).parentDir,'caltech_boy') ansList(i,1).gender = 'male';
			elseif strcmp(fileList(i).parentDir,'caltech_girl') ansList(i,1).gender = 'female';
			end
			fprintf('progress==>%d / %d\n', i, length(fileList));
		end
	case existDataset{3,1}    %Custom
		fprintf('Choose %s dataset.\n', existDataset{3,1});
		fileList = recursiveFileList(dirName, existDataset{3,2});
		for i = 1:length(fileList)
			ansList(i,1).name = fileList(i).name;
			if strcmp(fileList(i).parentDir,'boy') ansList(i,1).gender = 'male';
			elseif strcmp(fileList(i).parentDir,'girl') ansList(i,1).gender = 'female';
			end
			fprintf('progress==>%d / %d\n', i, length(fileList));
		end
	case existDataset{4,1}    %JAFFE
		fprintf('Choose %s dataset.\n', existDataset{4,1});
		fileList = recursiveFileList(dirName, existDataset{4,2});
		for i = 1:length(fileList)
			ansList(i,1).name = fileList(i).name;
			tmp = split(fileList(i).name, '.');
			ansList(i,1).expression = tmp{2}(1:2);
			fprintf('progress==>%d / %d\n', i, length(fileList));
		end
	case existDataset{5,1}    %ComputerScience
		fprintf('Choose %s dataset.\n', existDataset{5,1});
		fileList = recursiveFileList(dirName, existDataset{5,2});
		for i = 1:length(fileList)
			tmp = split(fileList(i).name, '_');
% 			if strcmp(tmp{3},'0') 
% 				ttt = ['rm ./demoDataset/ComputerScience/' tmp{1} '_result/' fileList(i).name];
% 				[a b] = system(ttt);
% 				continue; 
% 			end
			ansList(i,1).name = fileList(i).name;		
			if strcmp(tmp{2},'1') ansList(i,1).gender = 'male';
			elseif strcmp(tmp{2},'2') ansList(i,1).gender = 'female';
			end
			switch tmp{3}
				case '1'
					ansList(i,1).expression = 'HA';
				case '2'
					ansList(i,1).expression = 'SA';
				case '3'
					ansList(i,1).expression = 'SU';
				case '4'
					ansList(i,1).expression = 'AN';
				case '5'
					ansList(i,1).expression = 'DI';
				case '6'
					ansList(i,1).expression = 'FE';
			end
			fprintf('progress==>%d / %d\n', i, length(fileList));
		end
end
if saveOpt, save([name '.mat'],'ansList'); end
display('Done.');

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);