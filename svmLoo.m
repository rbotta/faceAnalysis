function [recogRate, computed] = svmLoo(DS, gamma, cost, plotOpt)
%svmLoo: Leave-one-out recognition rate of SVM
%
%	Usage:
%
%	Description:
%
%	Example:
%		DS=prData('random2');
%		gamma=0.0125;
%		cost=2;
%		plotOpt=1;
%		[recogRate, computed] = svmLoo(DS, gamma, cost, plotOpt);
%		fprintf('Recog. rate = %.2f%%\n', 100*recogRate);
%
%	See also svmArguTune

%	Category: Utility
%	Mymy, 20130122, 20130122
if nargin<1, selfdemo; return; end
if nargin<2, gamma=0.0125; end
if nargin<3, cost=2; end
if nargin<4, plotOpt=0; end

[dim, dataNum] = size(DS.input);
computed = zeros(size(DS.output));

svmOpt=['-q -t 2 -g ' num2str(gamma) ' -c ' num2str(cost)];

for i=1:dataNum
	looData = DS;
	looData.input(:,i) = [];
	looData.output(:,i) = [];
	TS.input=DS.input(:,i);
	TS.output=DS.output(:,i);
	svmModel=svmtrain(looData.output', looData.input', svmOpt);
	[computed(i), rr, dec_values_L]=svmpredict(TS.output', TS.input', svmModel);
end
hitIndex=find(DS.output==computed);
recogRate=length(hitIndex)/dataNum;


if plotOpt & dim==2
	dsScatterPlot(DS);
	axis image; box on
	missIndex=1:dataNum;
	missIndex(hitIndex)=[];
	% display these points
	for i=1:length(missIndex),
		line(DS.input(1,missIndex(i)), DS.input(2,missIndex(i)), 'marker', 'x', 'color', 'k');
	end
	titleString = sprintf('%d leave-one-out error points denoted by "x".', length(missIndex));
	title(titleString);
end
% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);

