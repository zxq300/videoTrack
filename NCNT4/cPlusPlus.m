clear;
close all;
imgs = randn(32,32,600);
patchSize = [32,32];
patchNum = [27,27];
tic;
patch = affinePatch(imgs, patchSize, patchNum);
toc;