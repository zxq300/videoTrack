function results = run_NCNT2(seq, res_path, bSaveImage)
%%
%***********************************************************************
% Copyright (C) Xinqi Zhou
% All rights reserved.
% Date: 03/2017
%***********************************************************************
%%

close all
%%
s_frames = seq.s_frames;
para = paraConfig_NCNT(seq.name);
rect = seq.init_rect;
[p, imgSize, param1, img, opt] = readImage(rect, para, s_frames);

%%
patchSize = [6, 6];
FiSize = 100;
[Fio, patcho, patchNum] = designFilters(img, param1, opt, patchSize, FiSize, imgSize);
%%
FiNeg = sampling(img, param1, imgSize, opt, patchSize, patchNum, FiSize);
%%
Fii = bsxfun(@minus, Fio, mean(Fio)) - bsxfun(@minus, FiNeg, mean(FiNeg));
seqNum = seq.endFrame - seq.startFrame + 1;
res = zeros(seqNum, 6);
res(1,:) = param1;
%%
duration = 0;
res = tracking(seq, s_frames, patcho, param1, para, opt, Fii, Fio, res, imgSize, FiSize, patchSize, patchNum);
%% save and display
results.type = 'ivtAff';
results.res = res; % each row is a rectangle
results.tmplsize = para.size; % [width, height]
results.fps=(seq.len-1)/duration;
disp(['fps: ' num2str(results.fps)])
end