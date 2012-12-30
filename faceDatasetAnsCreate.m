function ansList = faceDatasetAnsCreate( dirName, saveOpt)
%FACEDATASETANSCREATE Summary of this function goes here
%   Detailed explanation goes here
existDataset = {'PAL', 'bmp'; 'Caltech', 'jpg'; 'Custom', 'jpg'; 'JAFFE', 'tiff'};

name = split(dirName, '/');
name = name{length(name)};
display('Start to create answer list....')
switch name
	case existDataset{1,1}
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
	case existDataset{2,1}
		fprintf('Choose %s dataset.\n', existDataset{2,1});
		fileList = recursiveFileList(dirName, existDataset{2,2});
		for i = 1:length(fileList)
			ansList(i,1).name = fileList(i).name;
			if strcmp(fileList(i).parentDir,'caltech_boy') ansList(i,1).gender = 'male';
			elseif strcmp(fileList(i).parentDir,'caltech_girl') ansList(i,1).gender = 'female';
			end
			fprintf('progress==>%d / %d\n', i, length(fileList));
		end
	case existDataset{3,1}
		fprintf('Choose %s dataset.\n', existDataset{3,1});
		fileList = recursiveFileList(dirName, existDataset{3,2});
		for i = 1:length(fileList)
			ansList(i,1).name = fileList(i).name;
			if strcmp(fileList(i).parentDir,'boy') ansList(i,1).gender = 'male';
			elseif strcmp(fileList(i).parentDir,'girl') ansList(i,1).gender = 'female';
			end
			fprintf('progress==>%d / %d\n', i, length(fileList));
		end
	case existDataset{4,1}
		fprintf('Choose %s dataset.\n', existDataset{4,1});
		fileList = recursiveFileList(dirName, existDataset{4,2});
		for i = 1:length(fileList)
			ansList(i,1).name = fileList(i).name;
			tmp = split(fileList(i).name, '.');
			ansList(i,1).expression = tmp{2}(1:2);
			fprintf('progress==>%d / %d\n', i, length(fileList));
		end
end
if saveOpt, save([dirName '.mat'],'ansList'); end
display('Done.');