addpath(genpath(pwd))

% DTLZ7 (EImax version)
clc; clear;
load dtlz_params
avg_runs = [30];
algs = ["GrEA"; "HypE"; "IBEA"; "MOEAD"; "NSGAII"; "NSGAIII"; "RVEA"; "SPEA2"];
algs = algs(1)
for a = 1:length(avg_runs)
%     for r = 1:length(rng_runs)
        for i = 1:length(algs)
            rng('default');
            Results = SurrogateModelModule_v2(strcat('data_dtlz7_', char(algs(i))),36,'KRIGgexp1','EImax', ...
                'LHS', 0, [1 3; dtlz_params.dtlz7]);
            save(strcat('EImax_dtlz7_','Results_',algs(i), '_r', num2str(avg_runs(a))), 'Results');
        end
%     end
end
