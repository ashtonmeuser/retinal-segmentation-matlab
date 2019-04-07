function [output] = thresholdVectors(vectors, weights, threshold)
% Apply weights to feature vectors, classify using global thresholding

weighted = bsxfun(@times, reshape(weights, [1 1 3]), vectors);
weighted = sum(weighted, 3); % Sum weighted feature vectors
adjustment = 255 / max(weighted, [], 'all');
integers = uint8(weighted * adjustment);
output = imbinarize(integers, threshold);

end
