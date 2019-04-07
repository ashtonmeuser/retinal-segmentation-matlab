function [truePositiveRate, falsePositiveRate] = assess(truth, prediction, print)
% Assign score to neighborhood based on best fitting line

truePositive = nnz(truth & prediction);
trueNegative = nnz(~truth & ~prediction);
falsePositive = nnz(~truth & prediction);
falseNegative = nnz(truth & ~prediction);
sensitivity = truePositive / (truePositive + falseNegative);
specificity = trueNegative / (trueNegative + falsePositive);
accuracy = (truePositive + trueNegative) / (truePositive + trueNegative + falsePositive + falseNegative);

truePositiveRate = sensitivity;
falsePositiveRate = 1 - specificity;

if print
    fprintf('sensitivity %f\n', sensitivity);
    fprintf('specificity %f\n', specificity);
    fprintf('accuracy %f\n', accuracy);
end

end
