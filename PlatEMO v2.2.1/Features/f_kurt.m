function [kurt_rank, kurt_avg, kurt_med, kurt_min, kurt_max, kurt_rnge] = f_kurt(objvar) 
%% Checks the kurtosis of the population of objective values - both the rank
    % and univariate avg/max/min/range
	rmimg = find(sum(imag(objvar)~= 0,2));
	objvar(rmimg,:) = [];

    ranksort = NDSort(objvar,length(objvar));    
    kurt_rank = kurtosis(ranksort);
    kurt_avg = mean(kurtosis(objvar));
    kurt_max = max(kurtosis(objvar));
	kurt_med = median(kurtosis(objvar));
    kurt_min = min(kurtosis(objvar));
    kurt_rnge = kurt_max - kurt_min;
end