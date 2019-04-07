function [output] = generateMaskArray(kSize, resolution, orthogonalLength)
% Create array of kSize * kSize masks by from resolution in degrees

if (mod(kSize, 2) == 0)
    error('Neighborhood kSize should be an odd number')
end

steps = floor(180 / resolution);
output = zeros(kSize, kSize, 2, steps, 'logical');
for index = 1:steps
    output(:, :, :, index) = lineMask(kSize, resolution * (index - 1), orthogonalLength);
end

end
