% function patch = affinePatch(imgs, patchSize, patchNum)
% n = size(imgs, 3);
% patch = zeros(prod(patchSize), prod(patchNum), n);
% blockSize = size(imgs(:, :, 1));
% for s = 1 : n
%     image = imgs(:, :, s);
%     x = patchSize(2) / 2;
%     y = patchSize(1) / 2;
%     centx = x : 1 : (blockSize(2) - x);
%     centy = y : 1 : (blockSize(1) - y);
%     i = 1;
%     for j = 1 : patchNum(1)
%         for k = 1 : patchNum(2)
%             data = image(centy(j) - y + 1 : centy(j) + y, centx(k) - x + 1 : centx(k) + x);
%             patch(:, i, s) = reshape(data, numel(data), 1);
%             i = i + 1;
%         end
%     end
% end
% end
function patch = affinePatch(imgs, patchSize, patchNum)
n = size(imgs, 3);
patch = zeros(prod(patchSize), prod(patchNum), n);
blockSize = size(imgs(:, :, 1));
% for s = 1 : n
%     image = imgs(:, :, s);
image = imgs;
    x = patchSize(2) / 2;
    y = patchSize(1) / 2;
    centx = x : 1 : (blockSize(2) - x);
    centy = y : 1 : (blockSize(1) - y);
    i = 1;
    for j = 1 : patchNum(1)
        for k = 1 : patchNum(2)
            data = image(centy(j) - y + 1 : centy(j) + y, centx(k) - x + 1 : centx(k) + x, :);
            patch(:, i, :) = reshape(data, 36, n);
            i = i + 1;
        end
    end
% end
end