function [TPrate, FPrate, TNrate, accuracy ] = evaluateImage(segImage, truthImage)
% returns the number of true positives between a segmented
% image and the ground truth image

[h, w] = size(segImage);
TP = 0; % number of true positives
FP = 0; % number of false positives
TN = 0; % number of true negatives
FN = 0; % number of false negatives
for y = 1:h
    for x = 1:w
        if(segImage(y,x) == truthImage(y,x))
            if (segImage(y,x) == 0)
                TN = TN+1;
            else
                TP = TP+1;
            end
        elseif(segImage(y,x) < truthImage(y,x))
                FN = FN+1;
        else
            FP = FP+1;
        end
    end
end

TPrate = TP/(TP+FN); % aka sensitivity aka recall
TNrate = TN/(TN+FP); % aka specificity
FPrate = 1 - TNrate;
accuracy = TP/(TP+FP);% aka precision