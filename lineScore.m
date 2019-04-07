function [output] = lineScore(neighborhood, lineMasks)
% Assign score to neighborhood based on best fitting line

steps = size(lineMasks, 4);
scores = zeros(steps, 2, 'double');
kSize = size(lineMasks, 1);
center = ceil(kSize / 2);
orthogonalLength = nnz(lineMasks(:, :, 2, 1));

if neighborhood(center, center) == 0 % Center pixel out of mask
    output = 0;
    return
end

for index = 1:steps
    numNonMasked = nnz(neighborhood); % To calculate non-masked average
    nonMaskedAverage = sum(neighborhood(:)) / numNonMasked;
    neighborhood(neighborhood == 0) = nonMaskedAverage; % Set masked to average
    neighborhoodAverage = mean2(neighborhood);
    % Calculate line score
    masked = neighborhood .* uint8(lineMasks(:, :, 1, index));
    lineAverage = sum(masked(:)) / kSize;
    score = max(lineAverage - neighborhoodAverage, 0);
    % Calculate orthogonal line score
    masked = neighborhood .* uint8(lineMasks(:, :, 2, index));
    lineAverage = sum(masked(:)) / orthogonalLength;
    orthogonalScore = max(lineAverage - neighborhoodAverage, 0);
    
    scores(index, :) = [score orthogonalScore];
end

output = max(scores, [], 1);

end
