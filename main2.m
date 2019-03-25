% Line detector

resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size
filename = '01_test.tif'; % Original image file path
maskImage = '01_test_mask.gif'; % FOV mask image file path
original = imread(filename);
mask = imread(maskImage);
greenImage = original(:, :, 2);
inverseGreen = imcomplement(greenImage);

[lineMasks, orthogMasks] = generateMaskArrays(kSize, resolution); % create the line kernels
%func1 = @(n) lineScore(n, lineMasks); % Anonymous fn called by convolution
func2 = @(m,n) vectorScore(m, n, lineMasks, orthogMasks);
result2 = convolve3(inverseGreen, mask, kSize, func2);

figure, montage([result2(:,:,1), result2(:,:,2), result2(:,:,3)]);
title('Resulting vector images');

meanLineScore = mean2(result2(:,:,1));
SDLineScore = std2(result2(:,:,1));

meanOrthogScore = mean2(result2(:,:,2));
SDOrthogScore = std2(result2(:,:,2));

meanOrigScore = mean2(result2(:,:,3));
SDOrigScore = std2(result2(:,:,3));

result3(:,:,1) = (result2(:,:,1) - meanLineScore) .* (1/SDLineScore);
result3(:,:,2) = (result2(:,:,2) - meanOrthogScore) .* (1/SDOrthogScore);
result3(:,:,3) = (result2(:,:,3) - meanOrigScore) .* (1/SDOrigScore);

figure, montage([result3(:,:,1)*255, result3(:,:,2)*255, result3(:,:,3)*255]);
title('Vector images after mean/sd adjustment');

S = result3(:,:,1)*255; % the 'kSize' LineScore
S0 = result3(:,:,2)*255; % the 3pxl orthogonal LineScore
I = result3(:,:,3)*255; % the greyscale Score

groundTruth = imread('01_manual1.gif')*255;

A = S .* S0;
B = A .* I;
figure;
montage({S, S0, I, A, B, groundTruth}, 'Size', [2 3]);
title(['Using kSize = ', num2str(kSize), ' and resolution = ', num2str(resolution), ' degrees']); 
