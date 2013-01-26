function faceInfoPlot(faceInfo)
%faceInfoPlot: plot face information
%
%	Usage:
%
%	Description:
%
%	Example:
%		faceInfoPlot(faceDatasetRead('./demoDataset/Custom', 'jpg'));
%
%	See also faceDatasetRead

%	Category: faceAnalysis
%	Mymy, 20120103, 20130103

if nargin < 1, selfdemo; return; end
%faceInfo = cell2mat(faceInfoList);
cou = 0;
if isfield(faceInfo,'gender')
	[uni,~,idx] = unique({faceInfo(:).gender});
	counts = accumarray(idx(:),1,[],@sum);
	cou = cou + 1;
	plotInfoList{cou}.uni = uni;
	plotInfoList{cou}.counts = counts;
	plotInfoList{cou}.type = 'gender';
end
if isfield(faceInfo,'age')
	ageRange = {'1-10','11-20','21-30','31-40','41-50','51-60','61-70','71-80','81-90','91-100'};
	ageIdx = ceil([faceInfo(:).age]./10);
	[uni,~,idx] = unique({ageRange{ageIdx}});
	counts = accumarray(idx(:),1,[],@sum);
	cou = cou + 1;
	plotInfoList{cou}.uni = uni;
	plotInfoList{cou}.counts = counts;
	plotInfoList{cou}.type = 'age';
end
if isfield(faceInfo,'expression')
	[uni,~,idx] = unique({faceInfo(:).expression});
	counts = accumarray(idx(:),1,[],@sum);
	cou = cou + 1;
	plotInfoList{cou}.uni = uni;
	plotInfoList{cou}.counts = counts;
	plotInfoList{cou}.type = 'expression';
end

for i = 1:cou
	subplot(1, cou, i);
	bar(plotInfoList{i}.counts);
	set(gca,'XTickLabel', plotInfoList{i}.uni);
	title(['# of the each ' plotInfoList{i}.type]);
end

function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
