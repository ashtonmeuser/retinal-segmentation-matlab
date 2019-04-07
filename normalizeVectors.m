function [output] = normalizeVectors(vectors)
% Account for image differences by normalizing feature vectors

scalar = mean(vectors, [1 2]) ./ std(vectors, 0, [1 2]);
output = bsxfun(@times, reshape(scalar, [1 1 3]), vectors);

end
