addpath(genpath(pwd))
sort = []; dat_out = []; numnbrs = 10;
% Add list of problems here
probs = ["new_ZDT1"];

for ii = 1:length(probs)
    count = 0;
    % Loop through the number of problem groups
        problem_name = char(probs(ii))
        prob_dir = fullfile(pwd,'Data','RandomSeq');
        probfiles = dir(fullfile(prob_dir,strcat('*', char(problem_name),'_probindex*', '11000_*.mat')));
        nprobfiles = length(probfiles)
        for f = 1:nprobfiles
            count = count + 1;
            fid = probfiles(f).name;
            filename = string(fid)
            importfile(fid);
            probindex = input.probindex;
            if isempty(probindex)
                probindex = 1;
            end
            
            % Create dummy popdec and popobj because we will need to re-order
            % to make neighbourhoods next to each other
            for o=1:length(result{end})
                popdec_d(o,:) = result{end}(o).dec;
                popobj_d(o,:) = result{end}(o).obj;
            end

            % Here nbr_ind will list the indexes that need to be grouped together
            % because this is not grouped by neighbours when generated
            nbr_ind = [];
            for c = 1:length(popobj_d)/(numnbrs+1)
            nbr_ind(c,:) = [c, length(popobj_d)/(numnbrs+1)+(10*(c-1))+1:(length(popobj_d)/(numnbrs+1)+(10*(c-1))+1+9)];
            end

            % N will reshape it so that they are in the right neighbourhood
            nbr_adj = reshape(nbr_ind', 11000, [], 1);
            popdec = popdec_d(nbr_adj,:);
            popobj = popobj_d(nbr_adj,:);

            sort = NDSort(popobj, length(popobj))';
            
            S = size(popobj);
            R = (numnbrs+1)*ones(1,ceil(S(1)/(numnbrs+1))); % number of rows in each cell.
            %R(end) = 1+mod(S(1)-1,numnbrs+1); % number of rows in last cell.
            M = mat2cell(popobj,R,S(2));
            M_sort = mat2cell(sort,R,size(sort,2));
            N = mat2cell(popdec,R,size(popdec,2));

            % Now adjust M by removing any dummy 0s we placed in the dec variables 
            % when there were not enough neighbours found

            for n = 1:length(N)
                if ~isempty(find(all(N{n}==0,2),1))
                % Update in M (obj) and N (dec)
                M{n}(all(N{n}==0,2),:) = [];
                N{n}(all(N{n}==0,2),:) = [];
                end
            end
            
            for i=1:length(M)
                sort = NDSort(M{i},numnbrs+1);
                % Proportion it is dominated by others
                sup(i) = 1/numnbrs*sum(sort(2:end) > sort(1));
                % Proportion it is dominating others
                infi(i) = 1/numnbrs*sum(sort(2:end) < sort(1));
                % Proportion of incomparable neighbours
                inc(i) = 1/numnbrs*sum(sort(2:end) == sort(1));
                % Non-dominated solutions in neighbourhood
                lnd(i) = 1/numnbrs*sum(sort(2:end) == 1);
                % Displacement of points across PF
%                 % Autocorrelations cannot be run if only 1 observation
%                 if size(M{i},1) > 1
%                     obj1(i,:) = autocorr(M{i}(:,1),1); 
%                     obj2(i,:) = autocorr(M{i}(:,2),1);
%                 else
%                     obj1(i,:) = NaN; 
%                     obj2(i,:) = NaN;
%                 end
            end
                rwalk_l = length(popobj); 
                sup_avg_rws = mean(sup); inf_avg_rws = mean(infi); inc_avg_rws = mean(inc);
                lnd_avg_rws = mean(lnd); 
                p_disp_avg_rws = mean(p_disp); 

                % acf calculation one step ahead
                sup_acf = autocorr(sup,1);
                inf_acf = autocorr(infi,1);
                inc_acf = autocorr(inc,1);
                lnd_acf = autocorr(lnd,1);

                sup_r1_rws = sup_acf(2); inf_r1_rws = inf_acf(2); inc_r1_rws = inc_acf(2);
                lnd_r1_rws = lnd_acf(2); 
                dec_max_range = decrange(popdec);
                decdist = f_decdist(popdec, popobj, 1, 1);
                obdist = f_obdist(popobj, 1, 1);
                [obclust_n, obclust_min, obclust_max, obclust_range] = obclust(popobj);
                [obdist_max, obdist_mean, obdist_iqr_mean] = obdisc(popobj,1);
                [mdl_r2, range_coeff] = rank_mdl(popdec, popobj);
                rankprop = f_rankprop(popobj,1);
                
                decsize = size(popdec,2);
                probsize = size(popobj,2);
                
                % kurtosis
                [kurt_rank, kurt_avg, kurt_min, kurt_max, kurt_rnge] = f_kurt(popobj);
                
               % The proportion of total number of neighbours that were found successfully
                nbrs_fnd = (sum(~all(popdec_d==0,2))-length(popobj_d)/(numnbrs+1))/(numnbrs*length(popobj)/(numnbrs+1));
                
                
                numbest = f_numbest(popobj);

                Hx = kdpee(popdec(:,1:end));
                Hy = kdpee(popobj(:,1:end));
                Hxy = kdpee([popdec(:,1:end) popobj(:,1:end)]);
                Signif = (Hx + Hy - Hxy)/Hy;
                
                avg_nbr_rank_count = 0;
                clear avg_nbr_rank
                for i=1:length(M_sort)
                    if any(M_sort{i} == 1)
                    avg_nbr_rank_count = avg_nbr_rank_count + 1;
                    avg_nbr_rank(avg_nbr_rank_count) = mean(M_sort{i});
                    else
                    continue
                    end
                end
                avg_nbr_rank_best = mean(avg_nbr_rank);
                min_nbr_rank_best = min(avg_nbr_rank);
                max_nbr_rank_best = max(avg_nbr_rank);

                for j=1:length(M)
                    % Escape probability calculation, %select smallest value, so largest +value
                    ibea_fit = -CalFitness(M{j},0.05);
                    %Fitness of the walk
                    M_walk(j) = ibea_fit(1); 
                    P_fi(j) = 1/sum(ibea_fit(1) < ibea_fit);   
                end
                % The probabilities for better ones
                P_fi(P_fi==inf) = 0;
                for fp_i=1:length(P_fi)
                    if P_fi(fp_i) == 0
                        esc_pr(fp_i) = 0;
                    else
                        esc_pr(fp_i) = mean(P_fi(M_walk(fp_i) < M_walk));
                    end
                end

                esc_pr(isnan(esc_pr)) = 0;
                aep = mean(esc_pr);

                dat_out = [dat_out; table(string(problem_name), probindex, rwalk_l, ... 
                sup_avg_rws, inf_avg_rws , inc_avg_rws, lnd_avg_rws, ...
                sup_r1_rws, inf_r1_rws, inc_r1_rws, lnd_r1_rws, ...
                dec_max_range, decdist, obdist, ...
                obclust_n, obclust_min, obclust_max, obclust_range, ...
                obdist_max, obdist_mean, obdist_iqr_mean, ...
                mdl_r2, range_coeff, rankprop, decsize, probsize, ...
                kurt_rank, kurt_avg, kurt_min, kurt_max, kurt_rnge, ...
                nbrs_fnd, Hx, Hy, Hxy, Signif, avg_nbr_rank_best, ...
                min_nbr_rank_best, max_nbr_rank_best, aep ...
            )];
        end
end
    writetable(dat_out, strcat(char(problem_name),'.xlsx'))