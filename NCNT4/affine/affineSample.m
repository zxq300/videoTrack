function [imgs, param] = affineSample(img, imgSize, opt, param)
n = opt.numSample;

param.param1 = zeros(6, n);
param.param = zeros(6, n);
randMatrix = randn(6, n);

param.param1 = repmat(affparam2geom(param.est(:)), [1, n]);
param.param = param.param1 + randMatrix .* repmat(opt.offset(:), [1, n]);

paramo = affparam2mat(param.param);
imgs = warpimg(img, paramo, imgSize);


end