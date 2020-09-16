function Score = IGDplusm(PopObj,PF)
% <metric> <min>
% Using Ishibuchi et al. 2015
% Modified Distance Calculation in Generational Distance and Inverted
% Generational Distance

%--------------------------------------------------------------------------
% Copyright (c) 2016-2017 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB Platform
% for Evolutionary Multi-Objective Optimization [Educational Forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
	rmimg = find(sum(imag(PopObj)~= 0,2));
	PopObj(rmimg,:) = [];
	Distance = min(pdist2(PF,PopObj, @dplus),[],2);	
	IGDplus_m = mean(Distance);
    if (IGDplus_m >= 0 & IGDplus_m <= 1)
        Score = 1 - IGDplus_m;
    elseif (IGDplus_m > 1)
        Score = 1/IGDplus_m - 1;
    end
end