addpath(genpath(pwd))

% WFG1 (EImax version)
clc; clear;
load WFG_parameters.mat
% Control how they are run.
% rng_runs = [9, 99, 999];
% avg_runs = [5, 10, 30];
avg_runs = [30];
algs = ["GrEA"; "HypE"; "IBEA"; "MOEAD"; "NSGAII"; "NSGAIII"; "RVEA"; "SPEA2"];
for a = 1:length(avg_runs)
%     for r = 1:length(rng_runs)
        for i = 1:length(algs)
            rng('default');
            Results = SurrogateModelModule_v2(strcat('data_wfg1_', char(algs(i))),36,'KRIGgexp1','EImax', ...
                'LHS', 0, [[0.35 1 5 0.8 0.75 0.85 0.02]; [params.s_linear, params.mixed, params.re_b_flat2, params.b_poly]]);
            save(strcat('EImax_wfg1_','Results_',algs(i), '_r', num2str(avg_runs(a))), 'Results');
        end
%     end
end
