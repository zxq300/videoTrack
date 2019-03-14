function [Fio, patcho, patchNum] = designFilters(img, param1, opt, patchSize, FiSize, imgSize)

n1 = length(patchSize(1)/2 : 1 : (imgSize(1) - patchSize(1)/2));
n2 = length(patchSize(2)/2 : 1 : (imgSize(2) - patchSize(2)/2));
patchNum = [n1, n2];

image = warpimg(img, param1, opt.size);
[data, patcho] = slidingWindow(image, patchSize, patchNum);

cluster_options.maxiters = 10;
cluster_options.verbose = 0;

Fio = vgg_kmeans(double(patcho), FiSize, cluster_options);

end
function v = myfun(n)
% v = bsxfun(@minus, n, mean(n));
v = mean(n);
end