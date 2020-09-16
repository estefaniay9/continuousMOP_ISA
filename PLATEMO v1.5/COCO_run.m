%% START PROGRAM %%
% We run each of the algorithms and get their results as outputs.
% Then we read in their results back into MATLAB and calculate their
    % respective performance metrics.
        
% Add filepath to include all files
addpath(genpath(pwd));

% Choice of algorithms and problem groups. We can add or remove.
algs = ["GrEA"; "HypE"; "MOEAD"; "MOPSO"; "NSGAII"; "NSGAIII"; "PESAII"; "SMSEMOA"; "SPEA2";
        "ARMOEA"; "IBEA"; "KnEA"; "RVEA"];
prob_grps = ["COCO"];

for i = 1:numel(prob_grps)
	probs.(char(prob_grps(i))) = prob_list(char(prob_grps(i)));
end

%% Phase 1: %%
% Run the specified algorithms over each chosen problem r times.
% We can further nest to run different M and D for specified problems
% Loop through the algorithms
tic
dims = [2 3 5 10 20 40];
parfor a = 1:numel(algs)    
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
        % Do r runs of the algorithm - up to 15 instances for COCO
            for d = 1:length(dims)
                for r = 1:15
                    main('-algorithm', str2func(alg), '-problem', str2func(prob_struct), ...
                    '-mode', 2, '-run', r, '-D', dims(d), '-evaluation', 20000)
                end
            end
        end
    end
end
fin = toc

%% Phase 2: %%
% Reading data files for above algorithms to obtain performance metrics
% And exporting as a table

tic
count = 0;
dat_out = [];
for a = 1:numel(algs)
    alg = algs(a);
    alg_dir = fullfile(pwd,'data/', char(alg));
    probnames = fieldnames(probs);
    % Loop through the number of problem groups
    for p = 1:numel(probnames)
        % Loop through the different problems within each group
        for j = 1:numel(probs.(probnames{p}))
        % Create the structure if not already created
        probs.(probnames{p});
        % List out each of the individual problems within each group
        % We use this to write out to a table
        problem = probs.(probnames{p})(j);
        % And this to write out into a structure
        prob_struct = char(probs.(probnames{p})(j));
        % Obtain the structure of the directory for these problems
        probfiles = dir(fullfile(alg_dir,strcat(char(alg),'_',prob_struct,'_*.mat')));
        % The number of files (runs)
        nprobfiles = length(probfiles);
            % For each run of the file
            for f = 1:nprobfiles
                run_num = f;
                % Obtain the file name
                fid = probfiles(f).name;
                % Import the file
                importfile(fid);
                % Find the PF and approximate PF for the mat file
                PopObj = [];
                for i = 1:size(Population,2)
                    PopObj = [PopObj; Population(i).obj];
                end
                % Collect the number of objectives for the problem
                num_obj = size(PopObj, 2);
                % Calculate the metrics into a vector
                [spread, spacing, pd, nhv, igd, hv, gd, dm, coverage] = metrics_out(PopObj,PF);
                runtime = metric.runtime;
                % Writing everything into a table
                dat_out = [dat_out; table(alg, problem, num_obj, run_num, runtime, spread, spacing, pd, nhv, igd, hv, gd, dm, coverage)];
                count = count + 1
            end
        end
    end
    writetable(dat_out, strcat(char(alg),'.xls'))
end
toc

%% add runtime and check PopObj vector to make sure it is okay
writetable(dat_out, 'data_outputs3.xls');

