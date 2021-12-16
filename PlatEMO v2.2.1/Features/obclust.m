function [obclust_n, obclust_min, obclust_max, obclust_range] = obclust(objvar)
%------------------Bias------------------
	rmimg = find(sum(imag(objvar)~= 0,2));
	objvar(rmimg,:) = [];
%Density in space - how many clusters are there? How much in each cluster?
    rng('default')
    va = evalclusters(objvar, 'kmeans', 'CalinskiHarabasz', 'KList', [1:20]);

    [idx] = kmeans(objvar,va.OptimalK);

    obclust_n = va.OptimalK;
    % percentage of points in same cluster.. potentially bias?
    obclust_min = min(groupcounts(idx)/sum(groupcounts(idx)));
    obclust_max = max(groupcounts(idx)/sum(groupcounts(idx)));
    obclust_range = obclust_max - obclust_min;
end