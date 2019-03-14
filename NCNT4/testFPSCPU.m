clear;
close all;

testNum = (100:20:600);
n = length(testNum);
testFPSCPUS = zeros(1,n);
k = 1;
for j = testNum
%%
testFPSCPUS(k) = testFPSCPUTracker(j);
k = k+1;
end
plot(testFPSCPUS);
