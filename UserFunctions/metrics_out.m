function [spread, spacing, pd, nhv, igd, hv, gd, dm, coverage] = metrics_out(PopObj,PF)
    spread = Spread(PopObj,PF);
    spacing = Spacing(PopObj,PF);
    pd = PD(PopObj,PF);
    nhv = NHV(PopObj,PF);
    igd = IGD(PopObj,PF);
    hv = HV(PopObj,PF);
    gd = GD(PopObj,PF);
    dm = DM(PopObj,PF);
    coverage = Coverage(PopObj,PF);
end