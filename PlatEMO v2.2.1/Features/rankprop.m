function x = rankprop(objvar,n)
    %------------------Evolvability------------------
    % Proportion of rank n
    rankn = objvar(NDSort(objvar,length(objvar))==n,:);
    x = numel(rankn)/numel(objvar);
end