%% Mainscript that will link everything together
addpath(genpath(pwd));

%% PART I: Setup - Collect all necessary data required
% Algorithm, problem suite and sample size choices
%algs = ["IBEA"; "GrEA"; "HypE"; "MOEAD"; "NSGAII"; "NSGAIII"; "SPEA2"; "RVEA"];
prob_grps = ["new_ZDT"; "new_DTLZ"; "new_WFG"; "BT"; "UF"; "CF"; "MaF"; "IMOP"; "IMMOEA"; "MOEADDE"; "MOEADM2M"; "RMMEDA"];
ss = 1000;
numnbrs = 10;

% Identify full list of problems
for i = 1:numel(prob_grps)
	probs.(char(prob_grps(i))) = prob_list(char(prob_grps(i)));
end

scriptdimlist; % runscript to obtain unique dimensions across all problems

scriptlhs; % run lhs for all unique dimensions

%% PART II: Collect problem specific data
% Should be in the form of:

% Check if the idx cluster data exists. If not, then run this function and create
% the kmeans cluster assignments. Otherwise, load the data.
%prob_name = 'ZDT1'; 

%dim = GLOBAL('-problem',str2func(char(prob_name))).D;

probnames = fieldnames(probs);

for p = 1:numel(probnames)        
%       Across the individual problems
    for j = 1:numel(probs.(probnames{p}))
        probs.(probnames{p})
        prob_name = char(probs.(probnames{p})(j))
        dim = GLOBAL('-problem',str2func(char(prob_name))).D;
        if exist(strcat(prob_name, '_assigned', '_D', num2str(dim), '_S', ...
            num2str(ss), '.mat'), 'file') ~= 2
            [X_clust, X_seq, idx_clust, idx_seq, C] = assign_nbrhd(prob_name, ss);
        else
            disp('File already exists! Loading now.');
            load(strcat(prob_name, '_assigned', '_D', num2str(dim), '_S', ...
            num2str(ss), '.mat'));
        end
		if exist(strcat(prob_name,'_visit', '_rw', num2str(ss), '_nbr', ...
            num2str(numnbrs), '.mat'), 'file')~= 2
			disp('Generating visit')
            % Start generating neighbours by using the gen_nbrs function
            visit = gen_nbrs(prob_name, ss, numnbrs, X_seq, X_clust, idx_seq, idx_clust);
        else
            disp('Visit file already exists! Loading now.');
            load(strcat(prob_name,'_visit', '_rw', num2str(ss), '_nbr', ...
            num2str(numnbrs), '.mat'));
        end
        % Run the randomsequence
        %% PART III: Run pseudo randwalk algorithm (randseq) to evaluate the walks
        runrand(visit, prob_name)
    end
end
 
% %% PART IV: Calculate features
% % Turn all features into a function and call them in, PlatEMO style!
% 
% allfeat = dir(fullfile(pwd,'Features/*.m'));
% featlist = cell(1,numel(allfeat));
% for i = 1:length(featlist)
%     [path, name, ext] = fileparts(allfeat(i).name);
%     featlist{i} = name;
% end