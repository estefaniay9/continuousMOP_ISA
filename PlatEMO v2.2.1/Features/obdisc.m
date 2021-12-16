function [obdisc_max, obdisc_mean, obdisc_med, obdisc_iqr_mean] = obdisc(objvar,n)
%------------------Discontinuous front------------------
	rmimg = find(sum(imag(objvar)~= 0,2));
	objvar(rmimg,:) = [];
% Large deviances between the rank n front might suggest discontinuities in
% PF
	rmimg = find(sum(imag(objvar)~= 0,2));
	objvar(rmimg,:) = [];
    rankn = objvar(NDSort(objvar,length(objvar))==n,:);
    dist = pdist2(rankn, rankn);
    obdisc_max = max(max(dist));
	obdisc_med = median(dist,'all');
    obdisc_mean = mean(dist,'all');
    obdisc_iqr_mean = mean(iqr(dist));
end