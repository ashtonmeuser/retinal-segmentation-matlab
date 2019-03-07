function [output] = lineScore(neighborhood, kSize, resolution)
% Assign score to neighborhood based on best fitting line

persistent lineMasks;
if isempty(lineMasks) % Expensive, inititialize once
    lineMasks = generateMaskArray(kSize, resolution);
end

mask = zeros(kSize, kSize, 'uint8');
center = ceil(kSize / 2);
mask(:, center) = 1;
neighborhood = neighborhood .* mask;
average = mean2(neighborhood);
output = average * kSize - average; % Account for zero pixels

end
