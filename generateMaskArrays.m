function [output1, output2, output3] = generateMaskArrays(kSize, resolution)
% Create array of kSize * kSize masks by from resolution in degrees

if (mod(kSize, 2) == 0)
    error('Neighborhood kSize should be an odd number')
end

steps = floor(180 / resolution);
output1 = zeros(kSize, kSize, steps, 'uint8');
output2 = zeros(kSize, kSize, steps, 'uint8');
output3 = zeros(kSize, kSize, steps, 'uint8');

for index = 1:steps
    [output1(:, :, index),output2(:, :, index)] = generateLineMasks(kSize, resolution * (index - 1));
    output3(round(kSize/2), round(kSize/2), index) = 1;
end

end
