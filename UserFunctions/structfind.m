function y = structfind(data,prob,alg)

% STRUCTFIND search a structure for a problem type
%   Y = STRUCTFIND(DATA,PROB) will search through a data structure and find
%   the list of indexes in the structure which corresponds 
%   to the problem arguments.
%   Y = STRUCTFIND(DATA,PROB,ALG) will search through a data structure and
%   find the index that matches with the problem and algorithm arguments.

switch nargin

    case 2
    y = [];
    for i = 1:numel(data)
        if strcmp(data(i).prob, prob) == 1
            y = [y, i];
        end
    end 
        
    case 3
    for i = 1:numel(data)
        if strcmp(data(i).prob, prob) & strcmp(data(i).alg, alg)
            y = i;
        end
    end 
    otherwise 
        fprintf('Error: Please check number of arguments')
end
