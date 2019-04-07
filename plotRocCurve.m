function [] = plotRocCurve(vectors, weights, truth)
% Threshold vectors with range of values, plot results

steps = 255;
performance = zeros(steps, 2, 'double');
areaUnderCurve = 0;
for index = 1:steps
    prediction = thresholdVectors(vectors, weights, 1 / index);
    performance(index, :) = assess(truth, prediction, false);
    areaUnderCurve = areaUnderCurve + performance(index, 1) / steps;
end

plot(performance);
title(sprintf('ROC Curve (AUC %f)', areaUnderCurve));
xlabel('False Positive Rate');
ylabel('True Positive Rate');

end
