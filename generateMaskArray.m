function [output] = generateMaskArray(kSize, resolution)
% Create array of kSize * kSize masks by from resolution in degrees

steps = floor(180 / resolution);
output = zeros(kSize, kSize, steps);
for index = 1:steps
    output(:, :, index) = lineMask(kSize, resolution * (index - 1));
end

end
