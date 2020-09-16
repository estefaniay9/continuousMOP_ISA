function Data=data_dtlz6_MOEAD
 
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
Data.xlow =[0];  % variable lower bounds
Data.xup=[1];     % variable upper bounds
Data.dim=1;             %problem dimension
Data.integer=[];        %indices of variables with integer constraints
Data.continuous=[1];  %indices of continuous variables 
Data.objfunction=@(x,probindex)myfun(x,probindex); %handle to objective function
end %function

function y=myfun(x,probindex) %objective function
algorithm = 'MOEAD';
algnum = 4;
x=x(:)';
new_x1 = sprintf('%1.3f', x(1));
pindex = sprintf('%1.1f', probindex);
pindex_2 = sprintf('%1.1f', probindex + algnum/10);

% Don't forget to run a setting that will run defaults as well since we want performance on these,.
% Do 5 iterations and get the average hypervolume
rng('default')
for r = 1:30
    % If it has already been run then we do not need to rerun and can just
    % load it in
    if exist(strcat(algorithm, '_new_DTLZ6', '_probindex', pindex, '_', num2str(r), '.mat')) == 2
        load(strcat(algorithm, '_new_DTLZ6', '_probindex', pindex, '_', num2str(r), '.mat'))
    else
        % Run the algorithm on the problem to get the performance metrics
        main('-algorithm',str2func(algorithm),'-problem',@new_DTLZ6,'-N',100, '-p1', x(1), ...
			'-probindex', probindex + algnum/10, '-run', r, '-save', 1);
        % We know that PLATEMO saves and clears output in the workspace. As a
        % result we must load the files to retain their information
        load(fullfile(pwd,'Data', 'new_DTLZ6', algorithm, ...
        strcat(algorithm, '_', 'new_DTLZ6', '_probindex', pindex_2, '_', num2str(r), '.mat')));
    end
    IGDplusm(r) = metric.IGDplusm;
end

y=mean(IGDplusm);
str2num(new_x1)
%evaluated_x = [str2num(new_x1), str2num(new_x2), y];
end %myfun
