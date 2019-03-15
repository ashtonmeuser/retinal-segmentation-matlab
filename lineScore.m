function [output] = lineScore(neighborhood, lineMasks)
% Assign score to neighborhood based on best fitting line

steps = size(lineMasks, 3);
scores = zeros(steps, 1, 'uint8');
kSize = size(lineMasks, 1);

for index = 1:steps
    numNonMasked = nnz(neighborhood);
    nonMaskedAverage = sum(neighborhood(:)) / numNonMasked;
    neighborhood(neighborhood == 0) = nonMaskedAverage;
    masked = neighborhood .* uint8(lineMasks(:, :, index));
    neighborhoodAverage = mean2(neighborhood);
    lineAverage = sum(masked(:)) / kSize;
    scores(index) = lineAverage - neighborhoodAverage;
end

output = max(scores);

end
