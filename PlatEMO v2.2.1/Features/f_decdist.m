function x = f_decdist(decvar, objvar, n1, n2)
    ranksort = NDSort(objvar,length(objvar));
    % Distance across and between n1-th and n2-th best rank front front in decision space
    x = mean(pdist2(decvar(ranksort == n1,:),decvar(ranksort == n2,:)),'all');
end