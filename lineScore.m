function [output] = lineScore(neighborhood, kSize)
% Assign score to neighborhood based on best fitting line

persistent a; % Line masks
if isempty(a) % Expensive, inititialize once
    a = []; % Debug
end

mask = zeros(kSize, kSize, 'uint8');
center = ceil(kSize / 2);
mask(:, center) = 1;
neighborhood = neighborhood .* mask;
average = mean2(neighborhood);
output = average * kSize - average; % Account for zero pixels

end
