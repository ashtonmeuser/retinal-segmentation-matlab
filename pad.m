function [output] = pad(image, padSize, value)
% Pad image with border of size ksize with value of value

[h, w] = size(image);
% output(1:h + padSize * 2, 1:w + padSize * 2) = uint8(value);
output = ones(h + padSize * 2, w + padSize * 2, 'uint8') * value; % Faster
output(padSize + 1:padSize + h, padSize + 1:padSize + w) = image;

end
