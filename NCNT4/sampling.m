function FiNeg = sampling(img, param1, imgSize, opt, patchSize, patchNum, FiSize)
n = 20;
negTemp = sampleNeg(img, param1, imgSize, n, opt, 8);
FiNeg = zeros(36, FiSize);

for i = 1 : n
    image = reshape(negTemp(:,i), imgSize);
    FiNeg = FiNeg + affineTrainNeg(image, patchSize, patchNum, FiSize);
end
FiNeg = FiNeg / n;

end