% Line detector

resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size
filename = '01_test.tif'; % Original image file path

original = imread(filename);
inverseGreen = imcomplement(original(:, :, 2));
lineMasks = generateMaskArray(kSize, resolution);
func = @(n) lineScore(n, lineMasks); % Anonymous fn called by convolution
result = convolve(inverseGreen, kSize, func);
inverseResult = imcomplement(result);

montage([inverseGreen result inverseResult]);
