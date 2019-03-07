function [output] = convolve(image, kSize, func)
% Convolve image with neighborhood size kSize*kSize applying func

size([0 0 0; 0 0 0])
[h, w] = size(image);
padSize = (kSize - 1) / 2;
image = pad(image, padSize, 255);
output = zeros(h, w, 'uint8');

for y = padSize + 1:h + padSize
    for x = padSize + 1:w + padSize
        neighborhood = image(y - padSize:y + padSize, x - padSize:x + padSize);
        output(y - padSize, x - padSize) = lineScore(neighborhood, kSize);
    end
end

end
