function [output] = lineMask(kSize, angle)
% Mask that passes a line around center angled at angle

angle = mod(angle, 180); % Repeats after 180 degrees
acute = mod(angle, 90);
quarterSize = ceil(kSize / 2);
quarter = zeros(quarterSize, quarterSize, 'logical');
diagonalDifference = abs(45 - acute);
rise = tand(45 - diagonalDifference);

% Only captures 0 - 45 degrees as x must be linear
for x = 0:quarterSize - 1
    quarter(quarterSize - round(rise * x), x + 1) = 1;
end

output = zeros(kSize, kSize, 'logical');
output(1:quarterSize, quarterSize:kSize) = quarter; % Q1
output(quarterSize:kSize, 1:quarterSize) = rot90(quarter, 2); % Q3

% Account for angles greater than 45 degrees
if angle > 45 && angle <= 135
    output = rot90(fliplr(output), -1); 
end
if angle > 90
    output = fliplr(output);
end

end
