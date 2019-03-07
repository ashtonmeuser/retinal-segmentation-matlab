% Line detector

original = imread('01_test.tif');
inverseGreen = imcomplement(original(:, :, 2));
inverseGreen(:, 300) = 100; % Debug
inverseGreen(:, 350) = 255; % Debug
inverseGreen(300, :) = 100; % Debug
inverseGreen(350, :) = 255; % Debug
image = convolve(inverseGreen, 9);

montage([inverseGreen, image]);

clear functions % Clear persistent variables