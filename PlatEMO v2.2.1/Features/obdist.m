function [obdist_max, obdist_mean, obdist_iqr_mean] = obdist(objvar,n)
%------------------Discontinuous front------------------
% Large deviances between the rank n front might suggest discontinuities in
% PF
    rankn = objvar(NDSort(objvar,length(objvar))==n,:);
    dist = pdist2(rankn);
    obdist_max = max(max(dist));
    obdist_mean = mean(dist,'all');
    obdist_iqr_mean = mean(iqr(dist));
end