function [poly2_coeff_amax, poly2_coeff_amin, poly2_coeff_min ] = poly2_coeff(objvar, n)
    
%------------------Convexity/concavity/linearity------------------
    %Shape of n-th ranked front
    rankfront = objvar(NDSort(objvar,length(objvar))==n,:);
    poly = polyfit(rankfront(:,1),rankfront(:,2),2);
    pcount = 1;
    % Compute the fit between the different combinations of x, y, z
    for ii = 1:size(rankfront,2)
        for jj = 1:size(rankfront,2)
            if ii ~= jj
                poly(pcount,:) = polyfit(rankfront(:,ii),rankfront(:,jj),2);
                pcount = pcount + 1;
            else
                continue
            end
        end
    end
    % The largest absolute value, then cross-referenced back into OG
    poly2_coeff_amax = poly(abs(poly(:,1)) == max(abs(poly(:,1))));
    % The smallest absolute value, then cross-referenced back into OG
    poly2_coeff_amin = poly(abs(poly(:,1)) == min(abs(poly(:,1))));
    % The minimum value
    poly2_coeff_min = min(poly(:,1));
end