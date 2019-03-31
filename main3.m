clear;

maxThreshold = 50;
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

TPrate = zeros((maxThreshold)+1,1);
FPrate = zeros((maxThreshold)+1,1);
TNrate = zeros((maxThreshold)+1,1);
accuracy = zeros((maxThreshold)+1,1);
bestAccuracy = 0;
bestThreshold = 0;
bestRate = 0;
bestScore = 0;

segmentedImages = uint8(zeros([size(inverseGreen),(maxThreshold*10)+1]));
% build up true positive and false positive rates for ROC curve
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
    [TPrate(threshold+1), FPrate(threshold+1), TNrate(threshold+1), accuracy(threshold+1)] = evaluateImage(segmentedImages(:,:,threshold+1),groundTruth);
    if (accuracy(threshold+1) > bestAccuracy)
        bestAccuracy = accuracy(threshold+1);
    end
    if ((TPrate(threshold+1)*(TNrate(threshold+1))) > bestRate )
        bestRate = TPrate(threshold+1)*(TNrate(threshold+1));
    end
    if ((accuracy(threshold+1)*TPrate(threshold+1)*(TNrate(threshold+1)) > bestScore))
        bestScore = accuracy(threshold+1)*TPrate(threshold+1)*TNrate(threshold+1);
        bestThreshold = threshold; 
    end
 end
figure, plot(FPrate,TPrate);
title('ROC curve');
xlabel('False Positive Rate');
ylabel('True Positive Rate');

%[optimalResult, Tvalues] = BasicGlobalThreshold(B,0.1);

figure, montage({segmentedImages(:,:,round(maxThreshold/3)),segmentedImages(:,:,round(maxThreshold/2)),segmentedImages(:,:,round(maxThreshold*2/3)),segmentedImages(:,:,round(maxThreshold*3/4)),segmentedImages(:,:,round(bestThreshold+1)),groundTruth}, 'Size', [2 3]);
title(['Threshold ',num2str(round(maxThreshold/3)),', ', num2str(round(maxThreshold/2)),', ', num2str(round(maxThreshold*2/3)),', ', num2str(round(maxThreshold*3/4)),', optimal threshold T = ',num2str(bestThreshold),' with ',num2str(uint8(accuracy(bestThreshold+1)*100)),'% precision , and the Ground Truth']);
figure, montage({uint8(A), uint8(B)}, 'Size', [1 2]);
title('Images after adding the weighted vector scores, first using line scores, then adding the original pixel score'); 
