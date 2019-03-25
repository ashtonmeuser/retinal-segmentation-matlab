function [bestLineScore, orthogScore, origScore] = vectorScore(neighborhood, FOVneighborhood, lineMasks, orthogMasks)
% Assign vector scores to neighborhood based on best fitting line

steps = size(lineMasks, 3);
bestLineScore = 0;
uint8 currentLineScore;
orthogScore = 0;
uint8 origScore;
kSize = size(lineMasks, 1);

neighborhoodAverage = mean2(neighborhood);
FOVneighborhoodAverage = 0;
FOVpixelcount = 0;
[h, w] = size(neighborhood);

% pixels out of FOV in the neighborhood are replaced with neighborhood
% average of pixels in FOV
% first calculate the average value of pixels in FOV
for y = 1:h
    for x = 1:w
        if(FOVneighborhood(y,x) == 255 ) % if its in FOV add to average
            FOVneighborhoodAverage = FOVneighborhoodAverage+neighborhood(y,x);
            FOVpixelcount = FOVpixelcount+1;
        end
    end
end
FOVneighborhoodAverage = FOVneighborhoodAverage/FOVpixelcount;

for y = 1:h
    for x = 1:w
        if(FOVneighborhood(y,x) == 0 ) % if its not in FOV
            neighborhood(y,x) = FOVneighborhoodAverage; %replace with average value in FOV
        end
    end
end

for index = 1:steps
    masked = neighborhood .* lineMasks(:, :, index);
    lineAverage = sum(masked(:)) / kSize;
    currentLineScore = lineAverage - neighborhoodAverage;
    if( currentLineScore > bestLineScore )
        bestLineScore = currentLineScore;
        orthogMasked = neighborhood .* orthogMasks(:, :, index);
        orthogScore = sum(orthogMasked(:)) / 3;
        orthogScore = orthogScore - neighborhoodAverage;
    end
end
origScore = neighborhood(round(kSize/2), round(kSize/2));
end
