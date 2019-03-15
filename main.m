% Line detector

resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size
originalFilename = '01_test.tif'; % Original image file path
fovMaskFilename = '01_test_mask.gif'; % Image mask file path

original = imread(originalFilename);
fovMask = logical(imread(fovMaskFilename));
inverseGreen = imcomplement(original(:, :, 2));
masked = inverseGreen .* uint8(fovMask);
lineMasks = generateMaskArray(kSize, resolution);
func = @(n) lineScore(n, lineMasks); % Anonymous fn called by convolution
result = convolve(masked, kSize, func);
inverseResult = imcomplement(result);

montage([masked result inverseResult]);
