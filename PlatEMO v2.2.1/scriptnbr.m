% Create an empty vector which will collect all the unique problem
% dimensions

% Initially we need to get the problems

for p = 1:numel(probnames)        
%       Across the individual problems
    for j = 1:numel(probs.(probnames{p}))
%       Create the structure array names of problems
        probs.(probnames{p});
        prob_name = char(probs.(probnames{p})(j));
%       Obtain dimension
        dim = GLOBAL('-problem',str2func(char(prob_name))).D;
%       Load required data
        load(strcat('X_clust', '_D', num2str(dim)))
        load(strcat('X_sample', '_D', num2str(dim), '_S', ...
                num2str(ss)), 'X_seq')
%       Obtain bounds for each problem
        bnd_u = GLOBAL('-problem',str2func(char(prob_name))).upper;
        bnd_l =  GLOBAL('-problem',str2func(char(prob_name))).lower;    
%       Check if the problem is bounded by (0,1)^D (like our lhs data)
%       If it is, do not waste computational effort rescaling
        if abs(min(X_clust) - bnd_l) <= 0.00001 && abs(bnd_u - max(X_clust)) > 0.00001
%           Rescale X_clust and X_seq
            X_clust = rescale(X_clust, bnd_l, bnd_u);
            X_seq = rescale(X_seq, bnd_l, bnd_u);
        else
            continue
        end
%       Generate clusters using X_clust to form the neighbourhood
%       We set 10k clusters to allow for a minimum of 200k/10k = 20 points
%       In the neighbourhood for each point in the sample
        rng('default')
        [idx_clust, C] = kmeans(X_clust, 1000, 'MaxIter', 10000);
%       Assign the sample into a cluster to identify its neighbourhood
        rng('default')
        [~,idx_seq] = pdist2(C,X_seq,'euclidean','Smallest',1);
%       Create a vector containing the indexes of idx_clust, we will use this to identify
%       which Y's have been checked
        clust_ind = 1:length(X_clust);
%       Create to collect the neighbours for each idx_seq
        nbrs = zeros(length(idx_seq),numneighbours);
        rng('default')
        for i = 1:length(idx_seq)
%           Find the indexes of Y which are in the same cluster as the
%           walk data (i.e. potential neighbours)
            potn = Y_ind(idx_seq(i) == idx_clust);
%           Set/reset counter so we can stop looking for neighbouring points
            n_count = 1;
            if length(potn) < numneighbours
                nbrs(i,:) = 0;
                disp('Error! Not enough neighbours to satisfy the minimum requirement!')
            else	
                while n_count <= numneighbours
%                   Select a random index from the potential neighbours
                    R = potn(randi(length(potn)));
%                   Check if the point has already been checked
                    if ~ismember(R, nbrs(i,:))
%                   If it has not been checked previously, add it to the checked
%                   list 
                        nbrs(i,n_count) = R;
                        % Iterate the count by one
                        n_count = n_count+1;
                    else
                        % if it has been checked, obtain a new point to check
                        continue
                    end
                end
            end
        end
        
    end     
end

