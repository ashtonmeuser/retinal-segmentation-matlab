% Line detector

original = imread('01_test.tif');
inverseGreen = imcomplement(original(:, :, 2));
inverseGreen(:, 300) = 100;
inverseGreen(:, 350) = 255;
image = convolve(inverseGreen, 9);

montage([inverseGreen, image]);
