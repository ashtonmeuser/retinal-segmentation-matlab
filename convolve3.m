function [output] = convolve3(image, kSize, func)
% Convolve image with neighborhood size kSize*kSize applying func which
% outputs 1x3 vector

[h, w] = size(image);
padSize = floor(kSize / 2);
image = pad(image, padSize, 255);
output = zeros(h, w, 3, 'uint8'); % create output vector for scores

for y = padSize + 1:h + padSize
    for x = padSize + 1:w + padSize
        neighborhood = image(y - padSize:y + padSize, x - padSize:x + padSize);
        ypos = y - padSize;
        xpos = x - padSize;
        [S, S0, I] = func(neighborhood); %using generateMaskArrays function call
        output(ypos, xpos, 1) = S; % kSize lineScore
        output(ypos, xpos, 2) = S0; % 3pxl lineScore
        output(ypos, xpos, 3) = I; % greyScale Score
    end
end

end
