clear;
close all;

testNum = (100:20:600);
n = length(testNum);
testFPSGPU = zeros(1,n);
k = 1;
for j = testNum
%%
testFPSGPU(k) = testFPSTracker(j);
k = k+1;
end
% plot(testNum,testFPSGPU);
% xlabel('d');
% ylabel('fps');

%%
testFPSCPUS = zeros(1,n);
k = 1;
for j = testNum
%%
testFPSCPUS(k) = testFPSCPUTracker(j);
k = k+1;
end
% plot(testNum,testFPSCPUS);
% xlabel('d');
% ylabel('fps');

% plot(testNum,testFPSGPU,testNum,testFPSCPUS);
% xlabel('d');
% ylabel('fps');
% legend('GPU','CPU');

% plot(testNum,testFPSGPU./testFPSCPUS);
% xlabel('d');
% ylabel('fps');