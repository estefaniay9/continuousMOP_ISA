function [X_clust, X_seq, idx_clust, idx_seq, C] = assign_nbrhd(prob_name, ss)
%%
% This function rescales problems into their respective lower and upper 
% bounds, and then assigns clusters as neighbourhoods for the sample data.

% Inputs
% prob_name: The filename of a given PlatEMO problem
% ss: Sample size of the random walk

% Outputs
% X_clust: rescaled X_clust for bounds (no change if same bounds)
% X_seq: rescaled X_seq for bounds (no change if same bounds)
% idx_clust: cluster ids of the generated neighbours
% idx_seq: cluster ids of the random walk sequence
% C: centroid co-ordinates for the clusters.

% set the directory we're working in. It will always be the \Sampling folder
% for these.
%datadir = fullfile(pwd, 'Sampling\');
%%
    % Initially we need to get the problems  
    % Obtain problem dimension
    dim = GLOBAL('-problem',str2func(char(prob_name))).D;
    % Load required data
    load(strcat('X_clust', '_D', num2str(dim)))
    load(strcat('X_sample', '_D', num2str(dim), '_S', ...
      num2str(ss)), 'X_seq')
    % Obtain bounds for each problem
    bnd_u = GLOBAL('-problem',str2func(char(prob_name))).upper;
    bnd_l = GLOBAL('-problem',str2func(char(prob_name))).lower;    
    % Check if the problem is bounded by (0,1)^D (like our lhs data)
    % If it is, do not waste computational effort rescaling

    % X_clust = X_clust(1:1000,:); % THIS IS TEMPORARY - JUST TO CHECK RUN
 
    if mean(abs(min(X_clust) - bnd_l) <= 0.00001 & abs(bnd_u - max(X_clust)) <= 0.00001) ~= 1
        disp('Rescaling problem')
    %   Rescale X_clust and X_seq
        X_clust = rescale(X_clust, bnd_l, bnd_u);
        X_seq = rescale(X_seq, bnd_l, bnd_u);
    end
    % Generate clusters using X_clust to form the neighbourhood
    % We set 10k clusters to allow for a minimum of 300k/10k = 20 points
    % In the neighbourhood for each point in the sample
    rng('default')
    [idx_clust, C] = kmeans(X_clust, 10000, 'MaxIter', 100000);
    % Assign the sample into a cluster to identify its neighbourhood
    rng('default')
    [~,idx_seq] = pdist2(C,X_seq,'euclidean','Smallest',1);
    save(strcat(prob_name, '_assigned', '_D', num2str(dim), '_S', ...
    num2str(ss)));
end

