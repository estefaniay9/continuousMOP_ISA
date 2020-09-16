function Data=data_wfg9_HypE
 
%ZDT1 function with changeable parameters
%--------------------------------------------------------------------------
%Copyright (c) 2012 by Juliane Mueller
%
% This file is part of the surrogate model module toolbox.
%
%--------------------------------------------------------------------------
%Author information
%Juliane Mueller
%Tampere University of Technology, Finland
%juliane.mueller2901@gmail.com
%--------------------------------------------------------------------------
%
Data.xlow =[0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 1, 0];  % variable lower bounds
Data.xup=[0.99, 0.99, 100, 100, 0.1, 0.1, 100, 100];     % variable upper bounds
Data.dim=8;             %problem dimension
Data.integer=[7];        %indices of variables with integer constraints
Data.continuous=[1, 2, 3, 4, 5, 6, 8];  %indices of continuous variables 
Data.objfunction=@(x, probindex)myfun(x, probindex); %handle to objective function
Data.constraint{1}=@(x) x(1) - x(5);
Data.constraint{2}=@(x) 1-x(5)-x(6); % from s_decept
Data.constraint{3}=@(x) x(4)-x(3); % from b_param
Data.constraint{1}=@(x) (4*x(7)+8)*pi-4*x(8); % for s_multi
end %function

function y=myfun(x, probindex) %objective function
algorithm = 'HypE';
algnum = 2;
x=x(:)';
% s_linear, mixed, mixed, re_b_flat2, re_b_flat2, re_b_flat_2, b_poly
pindex = sprintf('%1.1f', probindex);
pindex_2 = sprintf('%1.1f', probindex + algnum/10)

% Don't forget to run a setting that will run defaults as well since we want performance on these,.
% Do 5 iterations and get the average hypervolume
rng('default')
for r = 1:30
    % If it has already been run then we do not need to rerun and can just
    % load it in
    if exist(strcat(algorithm, '_new_WFG9', '_probindex', pindex, '_', num2str(r), '.mat')) == 2
        load(strcat(algorithm, '_new_WFG9', '_probindex', pindex, '_', num2str(r), '.mat'))
	elseif exist(strcat(algorithm, '_new_WFG9', '_probindex', pindex_2, '_', num2str(r), '.mat')) == 2
		load(strcat(algorithm, '_new_WFG9', '_probindex', pindex_2, '_', num2str(r), '.mat'))
	else
        fprintf('not found')
		not_found = strcat(algorithm, '_new_WFG9', '_probindex', pindex, '_', num2str(r), '.mat')
	% Run the algorithm on the problem to get the performance metrics
        main('-algorithm',str2func(algorithm),'-problem',@new_WFG9,'-N',100, '-zmin', x(1), '-p1', x(2), '-p2', x(3),...
	'-p3', x(4), '-p4', x(5), '-p5', x(6), '-p6', x(7), '-p7', x(8), ...
	'-probindex', probindex + algnum/10, '-run', r, '-save', 1);
        % We know that PLATEMO saves and clears output in the workspace. As a
        % result we must load the files to retain their information
        load(fullfile(pwd,'Data', 'new_WFG9', algorithm, ...
        strcat(algorithm, '_', 'new_WFG9', '_probindex', pindex_2, '_', num2str(r), '.mat')));
    end
    IGDplusm(r) = metric.IGDplusm;
end

y=mean(IGDplusm);
end %myfun

