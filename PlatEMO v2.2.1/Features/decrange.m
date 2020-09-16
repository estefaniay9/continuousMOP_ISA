function [dec_min_range, dec_max_range] = decrange(decvar)
%------------------Disimilar parameter domains------------------
% Difference between max and min of decision variables. Should impact
% algorithms depending on how they adjust the mutation strengths
% use difference in minimums and maximums, respectively
    dec_min_range = min(abs(decvar),[],'all')-min(min(abs(decvar)),[],'all');
    dec_max_range = max(abs(decvar),[],'all')-min(max(abs(decvar)),[],'all');
end
