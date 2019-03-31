clear;

maxThreshold = 100;
resolution = 15; % Line detector resolution in degrees
kSize = 15; % Kernel size

lineWeight = 8; % Featurevector weightings
orthogWeight = 7; 
origWeight = 14;

TPrate = zeros((maxThreshold)+1,20);
FPrate = zeros((maxThreshold)+1,20);
TNrate = zeros((maxThreshold)+1,20);
accuracy = zeros((maxThreshold)+1,20);

bestSegment = zeros(584,565,20);
bestAccuracy = zeros(1,20);
bestRate = zeros(1,20);
bestScore = zeros(1,20);
auc = zeros(1,20);

for driveSet = 1:20
    if driveSet<10
        filename = (['DRIVE/test/images/0', num2str(driveSet),'_test.tif']);
        maskImage = (['DRIVE/test/mask/0', num2str(driveSet),'_test_mask.gif']);
        truthImage = (['DRIVE/test/1st_manual/0', num2str(driveSet),'_manual1.gif']);
    else
        filename = (['DRIVE/test/images/', num2str(driveSet),'_test.tif']);
        maskImage = (['DRIVE/test/mask/', num2str(driveSet),'_test_mask.gif']);
        truthImage = (['DRIVE/test/1st_manual/', num2str(driveSet),'_manual1.gif']);
    end
    original = imread(filename);
    FOVmask = imread(maskImage);
    groundTruth = imread(truthImage);
    greenImage = original(:, :, 2);
    inverseGreen = imcomplement(greenImage);

    [lineMasks, orthogMasks] = generateMaskArrays(kSize, resolution); % create the line kernels
    %func1 = @(n) lineScore(n, lineMasks); % Anonymous fn called by convolution
    func2 = @(m,n) vectorScore(m, n, lineMasks, orthogMasks);
    result1 = convolve3(inverseGreen, FOVmask, kSize, func2);

    meanLineScore = mean2(result1(:,:,1));
    SDLineScore = std2(result1(:,:,1));

    meanOrthogScore = mean2(result1(:,:,2));
    SDOrthogScore = std2(result1(:,:,2));

    meanOrigScore = mean2(result1(:,:,3));
    SDOrigScore = std2(result1(:,:,3));

    result2(:,:,1) = (double(result1(:,:,1)) - meanLineScore) ./ SDLineScore;
    result2(:,:,2) = (double(result1(:,:,2)) - meanOrthogScore) ./ SDOrthogScore;
    result2(:,:,3) = (double(result1(:,:,3))  - meanOrigScore) ./ SDOrigScore;
    %result2(result2 < 0) = 0; % adjust for negative results

    S = result2(:,:,1); % the 'kSize' LineScore
    S0 = result2(:,:,2); % the 3pxl orthogonal LineScore
    I = result2(:,:,3); % the greyscale Score  

    A = S.*lineWeight + S0.*orthogWeight; % add the scores together with the vector weightings
    B = A + (I.*origWeight);
    B(B < 0) = 0; %adjust for negative scores

    [h, w] = size(B);
    bestThreshold = 0;
    segmentedImages = uint8(zeros([size(inverseGreen),maxThreshold+1]));
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
        [TPrate((threshold+1),driveSet), FPrate((threshold+1),driveSet), TNrate((threshold+1),driveSet), accuracy((threshold+1),driveSet)] = evaluateImage(segmentedImages(:,:,threshold+1),groundTruth);
        if (accuracy((threshold+1),driveSet) > bestAccuracy(driveSet))
            bestAccuracy(driveSet) = accuracy((threshold+1),driveSet);
        end
        if ((TPrate((threshold+1),driveSet))*(TNrate((threshold+1),driveSet)) > bestRate(driveSet) )
            bestRate(driveSet) = TPrate((threshold+1),driveSet)*(TNrate((threshold+1),driveSet));
        end
        if ((accuracy((threshold+1),driveSet)*TPrate((threshold+1),driveSet)*TNrate((threshold+1),driveSet)) > bestScore(driveSet))
            bestScore(driveSet) = accuracy((threshold+1),driveSet)*TPrate((threshold+1),driveSet)*TNrate((threshold+1),driveSet);
            bestThreshold = threshold; 
        end
     end
    bestSegment(:,:,driveSet) = segmentedImages(:,:,bestThreshold);
     %calculate area under curve
    auc(driveSet) = 0.0;
    for binNum = size(TPrate):-1:2
       auc(driveSet) = auc(driveSet) + ((FPrate((binNum-1),driveSet)-FPrate((binNum),driveSet))*TPrate((binNum),driveSet)) + 0.5*((FPrate((binNum-1),driveSet)-FPrate((binNum),driveSet))*(TPrate((binNum-1),driveSet)-TPrate((binNum),driveSet)));
    end
end
