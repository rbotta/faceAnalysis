%clc; clear; close all;
gamma = 0.0125;
cost = 2;
svmOpt=['-q -t 2 -g ' num2str(gamma) ' -c ' num2str(cost)];
for i = 1:length(cvData)
	i
	svmModel=svmtrain(cvData1(i).TS.output', cvData1(i).TS.input', svmOpt);
	[computed, rr, dec_values_L]=svmpredict(cvData1(i).VS.output', cvData1(i).VS.input', svmModel);
	computed
	totalRR(i) = rr(1);
end