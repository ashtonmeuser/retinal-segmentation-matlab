% Line detector

resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size
orthogonalLength = 3; % Length of orthogonal line score
originalFilename = 'DRIVE/01_test.tif'; % Original image file path
fovMaskFilename = 'DRIVE/01_test_mask.gif'; % Image mask file path

original = imread(originalFilename);
fovMask = logical(imread(fovMaskFilename));
inverseGreen = imcomplement(original(:, :, 2));
masked = inverseGreen .* uint8(fovMask);
lineMasks = generateMaskArray(kSize, resolution, orthogonalLength);
func = @(n) lineScore(n, lineMasks); % Anonymous fn called by convolution
vectors = convolve(masked, kSize, 2, func); % First, second feature vectors
vectors(:, :, 3) = rgb2gray(original); % Third feature vector
result = vectors(:, :, 1);
inverseResult = imcomplement(result);

montage([masked result inverseResult]);
