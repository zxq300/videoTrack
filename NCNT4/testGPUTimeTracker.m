
function testTimes = testGPUTimeTracker(j,k)
%%
testTimes = zeros(1,3);

img_color = imread('0156.jpg');
if size(img_color,3)==3
    img = double(rgb2gray(img_color));
else
    img = double(img_color);
end
rectTXT = importdata('groundtruth_rect.txt');
rect = rectTXT(156,:);

p = [rect(1) + rect(3)/2, rect(2) + rect(4)/2, rect(3), rect(4), 0];

para.opt = struct('numSample', j, 'offset', [4, 4, 0.01, 0.0, 0.00, 0]);
para.size = [32, 32];
%para = paraConfig_NCNT();

imgSize = para.size;
param1 = [p(1), p(2), p(3)/imgSize(1), p(5), p(4)/p(3), 0];
param1 = affparam2mat(param1);
opt = para.opt;
opt.size = para.size;
%%
patchSize = [6, 6];
FiSize = 100;
[Fio, patcho, patchNum] = designFilters(img, param1, opt, patchSize, FiSize, imgSize);
%%
FiNeg = sampling(img, param1, imgSize, opt, patchSize, patchNum, FiSize);
%%
Fii = bsxfun(@minus, Fio, mean(Fio)) - bsxfun(@minus, FiNeg, mean(FiNeg));
% seqNum = seq.endFrame - seq.startFrame + 1;
% res = zeros(seqNum, 6);
res = zeros(2, 6);
res(1,:) = param1;

%%


%disp('read image');
%tic;
img_color = imread('0157.jpg');
if size(img_color,3)==3
    img = double(rgb2gray(img_color));
else
    img = double(img_color);
end
%toc;

%disp('affineSample');
%tic;
param = [];
param.est = param1';

[imgs,param] = affineSample(img, imgSize, opt, param);
%toc;

%disp('affinePatch');
%tic;
patch = affinePatch2(imgs, patchSize, patchNum); % 36 * 729 * 600
%toc;

%disp('runInDevice');
%tic;
xo = bsxfun(@minus, patcho, mean(patcho));
alpha_qq = Fii' * xo; % 100 * 729
%toc;
ind = size(patch); % 36 729 600
i1 = ind(1);
i2 = ind(2);
i3 = ind(3);

disp('copyFromDeviceToGPU');
tic;

gPatch = gpuArray(patch);
gFii = gpuArray(Fii);
gAlpha_qq = gpuArray(alpha_qq); % 100 * 729

toc;
testTimes(1) = toc;

disp('runInGPU');
tic;

gPatchr = reshape(gPatch, i1, i2 * i3); % 36 * (729 * 600)
gPatchn = bsxfun(@minus, gPatchr, mean(gPatchr));

gAlpha_p = gFii' * gPatchn; % 100 * (729 * 600)


ind = size(gAlpha_p);
i1 = ind(1);
p = reshape(gAlpha_p, i1 * i2, i3); % (100 * 729) * 600

tempsum = sum((p.^2),1); % 1 * 600


tempdp = sqrt(tempsum); % 1 * 600


dp = bsxfun(@rdivide, p, tempdp); % (100 * 729) * 600
q = reshape(gAlpha_qq, 1, i1 * i2); % 1 * (100 * 729)
dq = q./(sqrt(sum(q.^2)));

sim = dq * dp; % 1 * 600

[vec_max, id_max] = max(sim);
gAlp = reshape(p(:, id_max), i1, i2);
gp = mean(dp, 2);

toc;
testTimes(2) = toc;

disp('copyFromGPUToDevice');
tic;

alp = gather(gAlp); % 100 * 729
np = gather(gp);

toc;
testTimes(3) = toc;

param.est = affparam2mat(param.param(:,id_max));
res(2, :) = param.est';

%%
% bSaveImage = 1;
% if bSaveImage
% 	imshow(img_color);
% 	numStr = sprintf('#%03d', 2);
% 	text(10,20,numStr,'Color','r', 'FontWeight','bold', 'FontSize',20);
% 	color = [ 1 0 0 ];
% 	[center,corners] = drawbox(para.size, res(2,:), 'Color', color, 'LineWidth', 2.5);
% 	axis off;
% 	drawnow;
% end
end