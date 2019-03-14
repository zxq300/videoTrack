clear;
close all;

testNum = (100:20:600);
testTimes = zeros(1,6);
k = 1;
for j = testNum
%%
testTimes(k) = testCPUTimeTracker(j);
k = k+1;
end
plot(testNum,testTimes);
xlabel('d');
ylabel('time(s)');
