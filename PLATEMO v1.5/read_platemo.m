%% STILL NEED TO WRITE OUT ERRORS %%
% AND NEST DIFFERENT M,D FOR SPECIFIC PROBLEMS (E.G. MAF)

%% START PROGRAM %%
% We run each of the algorithms and get their results as outputs.
% Then we read in their results back into MATLAB and calculate their
    % respective performance metrics.
        
% Prevent figures from killing MATLAB
opengl hardwarebasic

% Add filepath to include all files
addpath(genpath(pwd));

% Choice of algorithms and problem groups. We can add or remove.
algs = ["GrEA"; "HypE"; "MOEAD"; "MOPSO"; "NSGAII"; "NSGAIII"; "PESAII"; "SMSEMOA"; "SPEA2"];
prob_grps = ["BT"; "CF"; "DTLZ"; "LSMOP"; "UF"; "WFG"; "ZDT"];

for i = 1:numel(prob_grps)
	probs.(char(prob_grps(i))) = prob_list(char(prob_grps(i)));
end

%% Phase 2: %%
% Reading data files for above algorithms to obtain performance metrics
% And exporting as a table

tic
count = 0;
for a = 1:numel(algs)
    dat_out = [];
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
                % Obtain the file name
                fid = probfiles(f).name;
                % Read the run number from the filename
                underscore = strfind(fid, '_');
                run_num = str2num(fid(underscore(end:end)+1:end-4));
                % Import the file
                importfile(fid);
                % Find the PF and approximate PF for the mat file
                PopObj = [];
                for i = 1:size(Population,2)
                    PopObj = [PopObj; Population(i).obj];
                end
                % Collect the number of objectives for the problem
                num_obj = size(PopObj, 2);
                % Collect the number of decision variables for the problem
                num_dec = numel(Population(1).dec)
                % Calculate the metrics into a vector
                runtime = metric.runtime;
                % Writing everything into a table
                dat_out = [dat_out; table(alg, problem, num_obj, num_dec, run_num, runtime)];
                count = count + 1
            end
        end
    end
%     writetable(dat_out, strcat(alg,'2','.xls'));
end
toc