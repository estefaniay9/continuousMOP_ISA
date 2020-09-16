function [mdl_r2, range_coeff] = rank_mdl(decvar, objvar)
%------------------Linearity------------------
    ranksort = NDSort(objvar,length(objvar));
% Fit a linear model using the normalised decision objectives
    mdl = fitlm(decvar,ranksort);
% R2
    mdl_r2 = mdl.Rsquared.Adjusted;
% Intercept
%intercept = mdl.Coefficients.Estimate(1);
% Difference between variable coefficient. Large values mean that
% there is at least one variable which is carrying most of the
% weight (given linearity)
    range_coeff = max(mdl.Coefficients.Estimate(2:end))-min(mdl.Coefficients.Estimate(2:end));
end