% Line detector

resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size
filename = '01_test.tif'; % Original image file path

original = imread(filename);
inverseGreen = imcomplement(original(:, :, 2));
inverseGreen(:, 300) = 100; % Debug
inverseGreen(:, 350) = 255; % Debug
inverseGreen(300, :) = 100; % Debug
inverseGreen(350, :) = 255; % Debug

lineMasks = generateMaskArray(kSize, resolution);
func = @(n) lineScore(n, lineMasks); % Anonymous fn called by convolution
result = convolve(inverseGreen, kSize, func);
inverseResult = imcomplement(result);

montage([inverseGreen, result, inverseResult]);
