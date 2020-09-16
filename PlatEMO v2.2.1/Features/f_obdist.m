function x = f_obdist(objvar, n1, n2)
    ranksort = NDSort(objvar,length(objvar));
    % Distance across and between n1-th and n2-th best rank front front in objective space
    x = mean(pdist2(objvar(ranksort == n1,:),objvar(ranksort == n2,:)),'all');
end