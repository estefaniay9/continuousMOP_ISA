addpath(genpath(pwd))

% % WFG2 (EImax version)
clc; clear;
load WFG_parameters.mat
% Control how they are run.
% rng_runs = [9, 99, 999];
% avg_runs = [5, 10, 30];
avg_runs = [30];
algs = ["GrEA"; "HypE"; "IBEA"; "MOEAD"; "NSGAII"; "NSGAIII"; "RVEA"; "SPEA2"];
algs = algs(1)
for a = 1:length(avg_runs)
%     for r = 1:length(rng_runs)
        for i = 1:length(algs)
            rng('default');
            Results = SurrogateModelModule_v2(strcat('data_wfg2_', char(algs(i))),36,'KRIGgexp1','EImax', ...
                'LHS', 0, [[0.35 1 1 5];[params.s_linear, params.disc]]);
            save(strcat('EImax_wfg2_','Results_',algs(i), '_r', num2str(avg_runs(a))), 'Results');
        end
%     end
end
