function [output1, output2] = generateLineMasks(kSize, angle)
% Generates two masks, one with a line with length 'kSize' at an angle of 'angle'
% and another with a line orthoganol to previous with a length of 3

angle = mod(angle, 180); % Repeats after 180 degrees
acute = mod(angle, 90);
quarterSize = ceil(kSize / 2);
quarter = zeros(quarterSize, quarterSize, 'uint8');
orthogQuarter = zeros(quarterSize, quarterSize, 'uint8');
diagonalDifference = abs(45 - acute);
rise = tand(45 - diagonalDifference);

% Only captures 0 - 45 degrees as x must be linear
for x = 0:quarterSize - 1
    quarter(quarterSize - round(rise * x), x + 1) = 1;
    if (x < 2)
        orthogQuarter(quarterSize - round(rise * x), x + 1) = 1;
    end
end

output1 = zeros(kSize, kSize);
output1(1:quarterSize, quarterSize:kSize) = quarter; % Q1
output1(quarterSize:kSize, 1:quarterSize) = rot90(quarter, 2); % Q3

output2 = zeros(kSize, kSize);
output2(1:quarterSize, quarterSize:kSize) = orthogQuarter;
output2(quarterSize:kSize, 1:quarterSize) = rot90(orthogQuarter, 2);
output2 = rot90(output2); % rotate the 3pxl line to be orthogonal to first line

% Account for angles greater than 45 degrees
if angle > 45 && angle <= 135
    output1 = rot90(fliplr(output1), -1);
    output2 = rot90(fliplr(output2), -1);
end
if angle > 90
    output1 = fliplr(output1);
    output2 = fliplr(output2);
end

end
