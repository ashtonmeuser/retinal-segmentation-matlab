% Classify image vessel and non-vessel pixels

resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size
orthogonalLength = 3; % Length of orthogonal line score
originalFilename = 'DRIVE/image/01.tif'; % Original image file path
fovMaskFilename = 'DRIVE/mask/01.gif'; % Image mask file path
truthFilename = 'DRIVE/truth/01.gif'; % Manual segmentation file path
weights = [7 2 6]; % Weights for features (line, orthogonal, greyscale)

original = imread(originalFilename);
fovMask = logical(imread(fovMaskFilename));
truth = logical(imread(truthFilename));
inverseGreen = imcomplement(original(:, :, 2));
masked = inverseGreen .* uint8(fovMask);
lineMasks = generateMaskArray(kSize, resolution, orthogonalLength);
func = @(n) lineScore(n, lineMasks); % Anonymous fn called by convolution
vectors = convolve(masked, kSize, 2, func); % First, second feature vectors
vectors(:, :, 3) = masked; % Third feature vector
normalized = normalizeVectors(vectors);

plotRocCurve(normalized, weights, truth); % Range of threshold values
prediction = thresholdVectors(normalized, weights, 0.095); % Using nominal threshold value
assess(truth, prediction, true); % Assess performance of nominal threshold value

imwrite(prediction, 'prediction.png');
