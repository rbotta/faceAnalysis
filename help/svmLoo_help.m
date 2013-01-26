%% svmLoo
% Leave-one-out recognition rate of SVM
%% Syntax
%% Description
%
% <html>
% </html>
%% Example
%%
%
DS=prData('random2');
gamma=0.0125;
cost=2;
plotOpt=1;
[recogRate, computed] = svmLoo(DS, gamma, cost, plotOpt);
fprintf('Recog. rate = %.2f%%\n', 100*recogRate);
