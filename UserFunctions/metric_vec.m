function metrics = metric_vec(PopObj,PF)
    metrics = [];
    metrics(1)= Spread(PopObj,PF);
    metrics(2)= Spacing(PopObj,PF);
    metrics(3)= PD(PopObj,PF);
    metrics(4)= NHV(PopObj,PF);
    metrics(5)= IGD(PopObj,PF);
    metrics(6)= HV(PopObj,PF);
    metrics(7)= GD(PopObj,PF);
    metrics(8)= DM(PopObj,PF);
    metrics(9)= Coverage(PopObj,PF);
end