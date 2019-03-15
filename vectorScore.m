function [output1, output2, output3] = vectorScore(neighborhood, lineMasks, orthogMasks, origMasks)
% Assign vector scores to neighborhood based on best fitting line

steps = size(lineMasks, 3);
bestLineScore = 0;
uint8 currentLineScore;
orthogScore = 0;
uint8 origScore;
kSize = size(lineMasks, 1);

neighborhoodAverage = mean2(neighborhood);

for index = 1:steps
    masked = neighborhood .* lineMasks(:, :, index);
    lineAverage = sum(masked(:)) / kSize;
    currentLineScore = lineAverage - neighborhoodAverage;
    if( currentLineScore > bestLineScore )
        bestLineScore = currentLineScore;
        orthogMasked = neighborhood .* orthogMasks(:, :, index);
        orthogScore = sum(orthogMasked(:)) / 3;
        orthogScore = orthogScore - neighborhoodAverage;
    end
end
origMasked = neighborhood .* origMasks(:, :, 1);
origScore = sum(origMasked(:));
output1 = bestLineScore;
output2 = orthogScore;
output3 = origScore;

end
