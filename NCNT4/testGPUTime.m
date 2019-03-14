clear;
close all;

testNum = (100:20:600);
testTimes = zeros(3,6);
k = 1;
for j = testNum
%%
testTimes(:,k) = testGPUTimeTracker(j);
k = k+1;
end
% plot(testNum,testTimes');
% xlabel('d');
% ylabel('time(s)');
% legend('HTD','RT','DTH');

plot(testNum,testTimes(3,:));
xlabel('d');
ylabel('time(s)');
legend('DTH');
