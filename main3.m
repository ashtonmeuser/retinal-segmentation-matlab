clear;

maxThreshold = 30;
resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size

lineWeight = 10; % Featurevector weightings
orthogWeight = 5; 
origWeight = 10;

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

figure, montage([histeq(result1(:,:,1)), histeq(result1(:,:,2)), (result1(:,:,3))]);
title('Resulting vector images after histogram equalization');

meanLineScore = mean2(result1(:,:,1));
SDLineScore = std2(result1(:,:,1));

meanOrthogScore = mean2(result1(:,:,2));
SDOrthogScore = std2(result1(:,:,2));

meanOrigScore = mean2(result1(:,:,3));
SDOrigScore = std2(result1(:,:,3));

result2(:,:,1) = (double(result1(:,:,1)) - meanLineScore) .* (1/SDLineScore);
result2(:,:,2) = (double(result1(:,:,2)) - meanOrthogScore) .* (1/SDOrthogScore);
result2(:,:,3) = (double(result1(:,:,3))  - meanOrigScore) .* (1/SDOrigScore);
result2(result2 < 0) = 0; % adjust for negative results

S = result2(:,:,1); % the 'kSize' LineScore
S0 = result2(:,:,2); % the 3pxl orthogonal LineScore
I = result2(:,:,3); % the greyscale Score  
    
A = S.*lineWeight + S0.*orthogWeight; % add the scores together with the vector weightings
B = A + (I.*origWeight);

[h, w] = size(B);

TPrate = zeros((maxThreshold*2)+1,1);
FPrate = zeros((maxThreshold*2)+1,1);
segmentedImages = uint8(zeros([size(inverseGreen),(maxThreshold*10)+1]));
% 
 for threshold=0:1:maxThreshold
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

figure, montage({segmentedImages(:,:,round(maxThreshold/4)),segmentedImages(:,:,round(maxThreshold/3)),segmentedImages(:,:,round(maxThreshold/2)),segmentedImages(:,:,round(maxThreshold*2/3)),segmentedImages(:,:,round(maxThreshold*3/4)),groundTruth}, 'Size', [2 3]);
title(['Threshold ', num2str(round(maxThreshold/4)),',', num2str(round(maxThreshold/3)),',', num2str(round(maxThreshold/2)),',', num2str(round(maxThreshold*2/3)),',', num2str(round(maxThreshold*3/4)), ' and the Ground Truth']);
figure, montage({S, S0, I, A, B, groundTruth}, 'Size', [2 3]);
title(['Using kSize = ', num2str(kSize), ' and resolution = ', num2str(resolution), ' degrees']); 
