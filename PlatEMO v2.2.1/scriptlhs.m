% For the lhs that is first generated, we don't need any form upper or
% lower bounds for scaling. We only want to generate the different lhs 
% bases for each of the unique dimensions from dim_list

% There are two types of lhs that need to be completed - one we use for the
% sequence (using CollectDataLHD which will be crossvalidated)
% and the standard lhsdesign for a larger generation

% Set the save directory
%datadir = fullfile(pwd, 'Sampling\');

for l = 1:length(dim_list)
%   Collecting the decision variable Xs that will be used for the cluster
%   in order to generate neighbours
    rng('default')
%   Check if it already has been computed, if so, do not rerun it, and
%   load the file
    if exist(strcat('X_clust', '_D', num2str(dim_list(l)), '.mat'), 'file') ~= 2
        disp(strcat('-> Running LHS for X_clust D',num2str(dim_list(l))));
        X_clust = lhsdesign(300000,dim_list(l));
%       Save the lhs for clustering
        %save([datadir strcat('X_clust', '_D', num2str(dim_list(l)))], 'X_clust');
		save(strcat('X_clust', '_D', num2str(dim_list(l))), 'X_clust');
    else
        load(strcat('X_clust', '_D', num2str(dim_list(l))))
        disp(strcat('-> Data loaded for X_clust D',num2str(dim_list(l))));
    end
    rng('default')
%   The random walk we use will only take 1000 steps, but we don't want
%   too much sparseness (by having few samples in the lhs) - for now lets
%   keep this sparseness and check it later
%   Check if it already has been computed, if so, do not rerun it, and
%   load the file
    if exist(strcat('X_sample', '_D', num2str(dim_list(l)), '_S', ...
        num2str(ss), '.mat'), 'file') ~= 2
        disp(strcat('-> Running LHS for X_sample D',num2str(dim_list(l))));
        X_sample = lhsdesign(ss,dim_list(l));
%       Obtain the sequence 
        seq = collectDataSequence_mex(X_sample');
        X_seq = X_sample(seq,:);
%       Save the lhs for clustering, with the sequence data
        %save([datadir strcat('X_sample', '_D', num2str(dim_list(l)), '_S', ...
            %num2str(ss), '.mat')], 'X_sample', 'seq', 'X_seq');
		save(strcat('X_sample', '_D', num2str(dim_list(l)), '_S', ...
		num2str(ss), '.mat'), 'X_sample', 'seq', 'X_seq');
	else
        load(strcat('X_sample', '_D', num2str(dim_list(l)), '_S', ...
            num2str(ss)))
        disp(strcat('-> Data loaded for X_sample D',num2str(dim_list(l))));
%       Rerun X_seq if it didn't work initially
        if exist('X_seq','var') ~= 1
            disp(strcat('-> Running missing sequence D',num2str(dim_list(l)), ...
                '_S', num2str(ss)));
            seq = collectDataSequence_mex(X_sample');
            X_seq = X_sample(seq,:);
            %save([datadir strcat('X_sample', '_D', num2str(dim_list(l)), '_S', ...
                %num2str(ss), '.mat')], 'X_sample', 'seq', 'X_seq');    
			save(strcat('X_sample', '_D', num2str(dim_list(l)), '_S', ...
                num2str(ss), '.mat'), 'X_sample', 'seq', 'X_seq');
		end
    end
    clear X_clust X_sample seq
end

