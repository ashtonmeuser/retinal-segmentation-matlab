maxThreshold = 100;
resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size

lineWeight = 5; % Featurevector weightings
orthogWeight = 3; 
origWeight = 0.1;
vectorOffset = 0; % plus offset

filename = '01_test.tif'; % Original image file path
maskImage = '01_test_mask.gif'; % FOV mask image file path
groundTruth = imread('01_manual1.gif')*255;

original = imread(filename);
FOVmask = imread(maskImage);
greenImage = original(:, :, 2);
inverseGreen = imcomplement(greenImage);

[lineMasks, orthogMasks] = generateMaskArrays(kSize, resolution); % create the line kernels
%func1 = @(n) lineScore(n, lineMasks); % Anonymous fn called by convolution
func2 = @(m,n) vectorScore(m, n, lineMasks, orthogMasks);
result1 = convolve3(inverseGreen, FOVmask, kSize, func2);

figure, montage([histeq(result1(:,:,1)), histeq(result1(:,:,2)), histeq(result1(:,:,3))]);
title('Resulting vector images after histogram equalization');

meanLineScore = mean2(result1(:,:,1));
SDLineScore = std2(result1(:,:,1));

meanOrthogScore = mean2(result1(:,:,2));
SDOrthogScore = std2(result1(:,:,2));

meanOrigScore = mean2(result1(:,:,3));
SDOrigScore = std2(result1(:,:,3));

result2(:,:,1) = ((result1(:,:,1) - meanLineScore) .* (1/SDLineScore));
result2(:,:,2) = ((result1(:,:,2) - meanOrthogScore) .* (1/SDOrthogScore));
result2(:,:,3) = (result1(:,:,3)); % - meanOrigScore) .* (1/SDOrigScore);

S = result2(:,:,1); % the 'kSize' LineScore
S0 = result2(:,:,2); % the 3pxl orthogonal LineScore
I = result2(:,:,3); % the greyscale Score  
    
A = S.*lineWeight + S0.*orthogWeight; % add the scores together with the vector weightings
B = A + (I.*origWeight) + vectorOffset;

[h, w] = size(B);
TP = zeros(maxThreshold+1,1);
FP = zeros(maxThreshold+1,1);
TN = zeros(maxThreshold+1,1);
FN = zeros(maxThreshold+1,1);
TPrate = zeros(maxThreshold+1,1);
FPrate = zeros(maxThreshold+1,1);
segmentedImages = uint8(zeros([size(inverseGreen),maxThreshold+1]));
% 
 for threshold=0:maxThreshold
    for y=1:h
        for x=1:w
            if(B(y,x) >= threshold)
                segmentedImages(y,x,threshold+1) = 255;
            else
                segmentedImages(y,x,threshold+1) = 0;
            end
        end
    end
    [TPrate(threshold+1), FPrate(threshold+1)] = evaluateImage(segmentedImages(:,:,threshold+1),groundTruth);
 end
figure, plot(FPrate,TPrate);
title('ROC curve');
xlabel('False Positive Rate');
ylabel('True Positive Rate');

figure, montage({segmentedImages(:,:,23),segmentedImages(:,:,24),segmentedImages(:,:,25),segmentedImages(:,:,26),groundTruth}, 'Size', [2 3]);
title('Threshold 23, 24, 25, 26 and the Ground Truth');
figure, montage({histeq(S), histeq(S0), histeq(I), histeq(A), histeq(B), groundTruth}, 'Size', [2 3]);
title(['Using kSize = ', num2str(kSize), ' and resolution = ', num2str(resolution), ' degrees']); 
