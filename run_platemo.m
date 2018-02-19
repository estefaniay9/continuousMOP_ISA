%% START PROGRAM %%
% We run each of the algorithms and get their results as outputs.
% Then we read in their results back into MATLAB and calculate their
    % respective performance metrics.
        
% Add filepath to include all files
addpath(genpath(pwd));

% Choice of algorithms and problem groups. We can add or remove.
algs = ["GrEA"; "HypE"; "MOEAD"; "MOPSO"; "NSGAII"; "NSGAIII"; "PESAII"; "SMSEMOA"; "SPEA2"];
prob_grps = ["BT"; "CF"; "DTLZ"; "LSMOP"; "MaF"; "UF"; "WFG"; "ZDT"];

% For testing purposes:
% algs = [algs(5:6)]
% prob_grps = [prob_grps(1); prob_grps(8)]

for i = 1:numel(prob_grps)
	probs.(char(prob_grps(i))) = prob_list(char(prob_grps(i)));
end

%% Phase 1: %%
% Run the specified algorithms over each chosen problem r times.
% We can further nest to run different M and D for specified problems
% Loop through the algorithms
tic
for a = 1:numel(algs)    
    alg = char(algs(a));
%   Obtain the list of fieldnames for our problemset
    probnames = fieldnames(probs);
%   Across the groups of problems
    for p = 1:numel(probnames)        
%       Across the individual problems
        for j = 1:numel(probs.(probnames{p}))
        % Create the structure array names of problems
        probs.(probnames{p});
        prob_struct = char(probs.(probnames{p})(j));
        % Do r runs of the algorithm
            parfor r = 1:30
                main('-algorithm', str2func(alg), '-problem', str2func(prob_struct) , '-mode', 2, '-run', r)     
            end
        end
    end
end
fin = toc

