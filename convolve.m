function [output] = convolve(image, kSize, features, func)
% Convolve image with neighborhood size kSize*kSize applying func

[h, w] = size(image);
padSize = floor(kSize / 2);
image = pad(image, padSize, 255);
output = zeros(h, w, features, 'double');

for y = padSize + 1:h + padSize
    for x = padSize + 1:w + padSize
        neighborhood = image(y - padSize:y + padSize, x - padSize:x + padSize);
        output(y - padSize, x - padSize, :) = func(neighborhood);
    end
end

end
