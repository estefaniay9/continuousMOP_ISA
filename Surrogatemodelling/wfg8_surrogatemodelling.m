addpath(genpath(pwd))

% wfg8 (EImax version)
clc; clear;
load WFG_parameters.mat
% Control how they are run.
% rng_runs = [9, 99, 999];
% avg_runs = [5, 10, 30];
avg_runs = [30];
algs = ["GrEA"; "HypE"; "IBEA"; "MOEAD"; "NSGAII"; "NSGAIII"; "RVEA"; "SPEA2"];
for a = 1:length(avg_runs)
        for i = 1:length(algs)
            rng('default');
            Results = SurrogateModelModule_v2(strcat('data_wfg8_', char(algs(i))),36,'KRIGgexp1','EImax', ...
                'LHS', 0, [[0.35 0.98/49.98 0.02 50]; [params.s_linear, params.b_param]]);
            save(strcat('EImax_wfg8_','Results_',algs(i), '_r', num2str(avg_runs(a))), 'Results');
        end
end
