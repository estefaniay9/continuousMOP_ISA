function x = f_rankprop(popobj,n)
	rmimg = find(sum(imag(popobj)~= 0,2));
	popobj(rmimg,:) = [];
    %------------------Evolvability------------------
    % Proportion of rank n
    rankn = popobj(NDSort(popobj,length(popobj))==n,:);
    x = numel(rankn)/numel(popobj);
end