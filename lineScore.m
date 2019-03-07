function [output] = lineScore(neighborhood, kSize)
%SPATIAL Pad image with border of size ksize with value of value

mask = zeros(kSize, kSize, 'uint8');
center = (kSize - 1) / 2 + 1;
mask(:, center) = 1;
neighborhood = neighborhood .* mask;
average = mean2(neighborhood);
output = average * kSize - average; % Account for zero pixels

end
