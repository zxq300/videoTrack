function Fi = affineTrainNeg(image, patchSize, patchNum, FiSize)
[data, patch] = slidingWindow(image, patchSize, patchNum);
ind = randperm(196);
Fi = patch(:, ind(1 : FiSize));

end