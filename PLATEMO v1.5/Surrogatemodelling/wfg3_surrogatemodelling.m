addpath(genpath(pwd))

% wfg3 (EImax version)
clc; clear;
load WFG_parameters.mat
Control how they are run.
avg_runs = [30];
algs = ["GrEA"; "HypE"; "IBEA"; "MOEAD"; "NSGAII"; "NSGAIII"; "RVEA"; "SPEA2"];
for a = 1:length(avg_runs)
       for i = 1:length(algs)
           rng('default');
           Results = SurrogateModelModule_v2(strcat('data_wfg3_', char(algs(i))),36,'KRIGgexp1','EImax', ...
               'LHS', 0, [[0.35]; params.s_linear]);
           save(strcat('EImax_wfg3_','Results_',algs(i), '_r', num2str(avg_runs(a))), 'Results');
       end
end
