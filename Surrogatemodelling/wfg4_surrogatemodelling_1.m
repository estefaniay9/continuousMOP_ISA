addpath(genpath(pwd))

% wfg4 (EImax version)
clc; clear;
load WFG_parameters.mat
% Control how they are run.
avg_runs = [30];
algs = ["GrEA"; "HypE"; "IBEA"; "MOEAD"; "NSGAII"; "NSGAIII"; "RVEA"; "SPEA2"];
algs = algs(1)
for a = 1:length(avg_runs)
        for i = 1:length(algs)
            rng('default');
            Results = SurrogateModelModule_v2(strcat('data_wfg4_', char(algs(i))),36,'KRIGgexp1','EImax', ...
                'LHS', 0, [[0.35 30 10];[params.re_s_multi(:,3), params.re_s_multi(:,1:2)]]);
            save(strcat('EImax_wfg4_','Results_',algs(i), '_r', num2str(avg_runs(a))), 'Results');
        end
end
