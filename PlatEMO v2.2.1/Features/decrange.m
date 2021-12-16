function dec_max_range = decrange(decvar)
%------------------Disimilar parameter domains------------------
% Difference between max and min of decision variables. Should impact
% algorithms depending on how they adjust the mutation strengths
% use difference in minimums and maximums, respectively
	dec_max_range = max(decvar,[],'all') - min(decvar,[],'all')	
	
end


