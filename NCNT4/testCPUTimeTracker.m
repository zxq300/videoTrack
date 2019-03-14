function testTimes = testCPUTimeTracker(j)
%%
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
n = para.opt.numSample;
%%

    tic;

    img_color = imread('0157.jpg');

    if size(img_color,3)==3
        img	= double(rgb2gray(img_color));
    else
        img	= double(img_color);
    end
param = [];
param.est = param1';
    [imgs,param] = affineSample(img, imgSize, opt, param);    % draw N candidates with particle filter

    patch = affinePatch3(imgs, patchSize, patchNum);          % obtain M patches for each candidate

    xo = bsxfun(@minus, patcho, mean(patcho));
alpha_qq = Fii' * xo; % 100 * 729

    sim = zeros(1,n);

    for i = 1:n
        x = bsxfun(@minus,patch(:,:,i),mean(patch(:,:,i)));
        S = Fii'*x; %Eq.(1)
        alpha_p(:,:,i) = S;

        p = S;
        p = reshape(p, 1, numel(p));
        p  = p./(sqrt(sum(p.^2))+eps);
        q = alpha_qq;
        q = reshape(q, 1, numel(q));

        q = q./(sqrt(sum(q.^2))+eps);
        sim(i) = p*q';
    end      

    likelihood = sim;
    [v_max,id_max] = max(likelihood);

    param.est = affparam2mat(param.param(:,id_max));
    res = param.est';
toc;
testTimes = toc;
   %%----------------- Update Scheme ----------------%%

   alp = alpha_p(:,:,id_max);
   alp(abs(p)<median(abs(p))) = 0; %Eq.(3)
   alpha_qq(abs(p)>median(abs(p))) = 0.95*alpha_qq(abs(p)>median(abs(p)))+0.05*alp(abs(p)>median(abs(p))); %Eq.(4)
   neg = sampleNeg(img, param.est', imgSize, 20, opt, 8);
   FiNeg = zeros(36,FiSize);
   for i = 1:size(neg,2)
       FiNeg = FiNeg + affineTrainNeg(reshape(neg(:,i),[32 32]), patchSize, patchNum, FiSize);
    end
    FiNeg = FiNeg/size(neg,2);
    Fii =  bsxfun(@minus,Fio,mean(Fio))-bsxfun(@minus,FiNeg,mean(FiNeg));%Update filters
  %%
    bSaveImage = 1;
    if bSaveImage
        % display the tracking result in each frame
%         te      = importdata([ 'Datasets\' title '\' 'dataInfo.txt' ]);
%         imageSize = [ te(2) te(1) ];

%         if f == 1
%             figure('position',[ 100 100 imageSize(2) imageSize(1) ]);
%             set(gcf,'DoubleBuffer','on','MenuBar','none');
%         end

%         axes(axes('position', [0 0 1.0 1.0]));
%         imagesc(img_color, [0,1]);
        imshow(img_color);
        numStr = sprintf('#%03d', 157);
        text(10,20,numStr,'Color','r', 'FontWeight','bold', 'FontSize',20);

        color = [ 1 0 0 ];
        [ center corners ] = drawbox(imgSize, res, 'Color', color, 'LineWidth', 2.5);

        axis off;
        drawnow;
    end
end
