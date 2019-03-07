function [output] = pad(image, padSize, value)
%SPATIAL Pad image with border of size ksize with value of value

[h, w] = size(image);
% Slightly faster initialization
output = ones(h + padSize * 2, w + padSize * 2, 'uint8') * value;
% output(1:h + padSize * 2, 1:w + padSize * 2) = uint8(value);
output(padSize + 1:padSize + h, padSize + 1:padSize + w) = image;

end
