function visit = gen_nbrs(prob_name, ss, numnbrs, X_seq, X_clust, idx_seq, idx_clust)

%% 
% This function generates neighbours for the sequence of points in the random walk

% Inputs
% prob_name: The filename of a given PlatEMO problem
% ss: Sample size of the random walk
% numnbrs: The number of neighbours we are finding for each problem
% X_clust: rescaled X_clust for bounds (no change if same bounds)
% idx_seq: cluster ids of the random walk sequence

% Outputs
% visit: The entire set of the decision space that needs to be visited
% during the random walk. This file is what will be read into the randseq
% algorithm.

%%  
    % When neighbours aren't found, we'll substitute with zeros
    X_clust(end+1,:) = zeros(1,size(X_clust,2));
%   Create a vector containing the indexes of idx_clust, we will use this to identify
%   which Y's have been checked
    clust_ind = 1:length(X_clust);
%   Vector for collecting the neighbours for each idx_seq
    nbrs = zeros(length(idx_seq),numnbrs);
    rng('default')
    for i = 1:length(idx_seq)
%       Find the indexes of Y which are in the same cluster as the
%       walk data (i.e. potential neighbours)
        potn = clust_ind(idx_seq(i) == idx_clust);
%       Set/reset counter so we can stop looking for neighbouring points
        n_count = 1;
        if length(potn) < numnbrs
            nbrs(i,:) = length(X_clust);
            disp('Error! Not enough neighbours to satisfy the minimum requirement!')
            disp(i)
            % Gonna introduce something here where if they're <numnbrs
            % it'll be filled with a dominating solution that is much
            % worse, as a dummy.
        else
%           While there are less neighbours iterated through than the number
%           required
            while n_count <= numnbrs
%               Select a random index from the potential neighbours
                R = potn(randi(length(potn)));
%               Check if the point has already been checked
                if ~ismember(R, nbrs(i,:))
%               If it has not been checked previously, append it to the 
%               checked list
                    nbrs(i,n_count) = R;
%                   Iterate the count by one
                    n_count = n_count+1;
                else
%                   if it has been checked, obtain a new point to check
%                   and continue adding until all numnbrs is found.
                    continue
                end
            end
        end
    end
%idx = (nbrs == 0);
%[delRows,~] = find(idx);
%delRows = unique(delRows);
%nbrs(delRows,:) = [];
% the neighbours we're going to visit
nbrs_seq = reshape(nbrs', [numel(nbrs'), 1]);
%clear idx delRows
% the X and Y values we will visit
visit = [X_seq; X_clust(nbrs_seq,:)];

save(strcat(prob_name,'_visit', '_rw', num2str(ss), '_nbr', num2str(numnbrs), '.mat'), 'visit')    
end