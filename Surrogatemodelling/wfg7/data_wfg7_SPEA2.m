function Data=data_wfg7_SPEA2
 
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
Data.xlow =[0.01, 0.01, 0.01, 0.01];  % variable lower bounds
Data.xup=[0.99, 0.99, 1, 100];     % variable upper bounds
Data.dim=4;             %problem dimension
Data.integer=[];        %indices of variables with integer constraints
Data.continuous=(1:4);  %indices of continuous variables 
Data.objfunction=@(x, probindex)myfun(x, probindex); %handle to objective function
Data.constraint{1}=@(x) x(4)-x(3);
end %function

function y=myfun(x, probindex) %objective function
algorithm = 'SPEA2';
algnum = 8;
x=x(:)';
% x(1) is zmin, x(2) is p1, x(3) is p2, x(4) is p3
pindex = sprintf('%1.1f', probindex);
pindex_2 = sprintf('%1.1f', probindex + algnum/10);

% Don't forget to run a setting that will run defaults as well since we want performance on these,.
% Do 5 iterations and get the average hypervolume
rng('default')
for r = 1:30
    % If it has already been run then we do not need to rerun and can just
    % load it in
    if exist(strcat(algorithm, '_new_WFG7', '_probindex', pindex, '_', num2str(r), '.mat')) == 2
        load(strcat(algorithm, '_new_WFG7', '_probindex', pindex, '_', num2str(r), '.mat'))
    else
        % Run the algorithm on the problem to get the performance metrics
        main('-algorithm',str2func(algorithm),'-problem',@new_WFG7,'-N',100, '-zmin', x(1), '-p1', x(2), '-p2', x(3), '-p3', x(4), ...
		'-probindex', probindex + algnum/10, '-run', r, '-save', 1);
        % We know that PLATEMO saves and clears output in the workspace. As a
        % result we must load the files to retain their information
        load(fullfile(pwd,'Data', 'new_WFG7', algorithm, ...
        strcat(algorithm, '_', 'new_WFG7', '_probindex', pindex_2, '_', num2str(r), '.mat')));
    end
    IGDplusm(r) = metric.IGDplusm;
end

y=mean(IGDplusm);
end %myfun