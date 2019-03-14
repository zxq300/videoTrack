function res = tracking(seq, s_frames, patcho, param1, para, opt, Fii, Fio, res, imgSize, FiSize, patchSize, patchNum)
param = [];
param.est = param1';

for f = 2 : seq.len
    
    disp(['# ' num2str(f)]);
    img_color = imread(s_frames{f});
    if size(img_color, 3) == 3
        img = double(rgb2grey(img_color));
    else
        img = double(img_color);
    end
    
    [imgs,param] = affineSample(img, imgSize, opt, param);
    patch = affinePatch(imgs, patchSize, patchNum); % 36 * 729 * 600
    
    if f == 2
        xo = bsxfun(@minus, patcho, mean(patcho));
        alpha_qq = Fii' * xo; % 100 * 729
    end
    
    ind = size(patch); % 36 729 600
    i1 = ind(1);
    i2 = ind(2);
    i3 = ind(3);
    
    gPatch = gpuArray(patch);
    gFii = gpuArray(Fii);
    gAlpha_qq = gpuArray(alpha_qq); % 100 * 729
    
    gPatchr = reshape(gPatch, i1, i2 * i3); % 36 * (729 * 600)
    gPatchn = bsxfun(@minus, gPatchr, mean(gPatchr));
    gAlpha_p = gFii' * gPatchn; % 100 * (729 * 600)
    
    ind = size(gAlpha_p);
    i1 = ind(1);
    
    p = reshape(gAlpha_p, i1 * i2, i3); % (100 * 729) * 600
    dp = bsxfun(@rdivide, p, sqrt(sum((p.^2),1))); % (100 * 729) * 600
    q = reshape(gAlpha_qq, 1, i1 * i2); % 1 * (100 * 729)
    dq = q./(sqrt(sum(q.^2)));
    
    sim = dq * dp; % 1 * 600
    
    [vec_max, id_max] = max(sim);
    gAlp = reshape(p(:, id_max), i1, i2);
    gp = mean(dp, 2);
    
    alp = gather(gAlp); % 100 * 729
    np = gather(gp);
    
    param.est = affparam2mat(param.param(:,id_max));
    res(f, :) = param.est';
    
    %% update
    n1 = abs(np) < median(np);
    n2 = abs(np) > median(np);
    alp(n1) = 0;
    rho = 0.95;
    alpha_qq(n2) = rho * alpha_qq(n2) + (1 - rho) * alp(n2);
    
    FiNeg = sampling(img, param.est', imgSize, opt, patchSize, patchNum, FiSize);
    Fii = bsxfun(@minus, Fio, mean(Fio)) - bsxfun(@minus, FiNeg, mean(FiNeg));
    %% draw tracking result
    bSaveImage = 1;
    if bSaveImage
        imshow(img_color);
        numStr = sprintf('#%03d', f);
        text(10,20,numStr,'Color','r', 'FontWeight','bold', 'FontSize',20);
        color = [ 1 0 0 ];
        [center,corners] = drawbox(para.size, res(f,:), 'Color', color, 'LineWidth', 2.5);
        axis off;
        drawnow;
    end
    
end

end