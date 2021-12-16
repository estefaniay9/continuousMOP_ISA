function x = f_numbest(popobj)
	rmimg = find(sum(imag(popobj)~= 0,2));
	popobj(rmimg,:) = [];
    %------------------Evolvability------------------
    % Proportion of rank n
    x = sum(NDSort(popobj,length(popobj)) == 1);
end