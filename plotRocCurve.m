function [areaUnderCurve] = plotRocCurve(vectors, weights, truth)
% Threshold vectors with range of values, plot results

steps = 255;
performance = zeros(steps + 2, 2, 'double');

for index = 1:steps + 2
    prediction = thresholdVectors(vectors, weights, ((index - 2) / steps));
    [truePositiveRate, falsePositiveRate] = assess(truth, prediction, false);
    performance(index, :) = [truePositiveRate, falsePositiveRate];
end

areaUnderCurve = trapz(performance(:, 2), performance(:, 1)) * -1; % Account for descending X values
plot(performance(:, 2), performance(:, 1));
title(sprintf('ROC Curve (AUC %f)', areaUnderCurve));
xlabel('False Positive Rate');
ylabel('True Positive Rate');

end
