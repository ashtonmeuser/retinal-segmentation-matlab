function [output] = normalizeVectors(vectors)
% Account for image differences by normalizing feature vectors

output = vectors - mean(vectors, [1 2]);
output = output ./ std(vectors, 0, [1 2]);

end
