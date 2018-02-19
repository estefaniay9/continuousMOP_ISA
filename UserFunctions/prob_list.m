function y = prob_list(prob_grp)
% Y = PROB_LIST(PROB_GRP) will return the list of all the problems within
% each respective problem group.

prob_names = dir(fullfile(pwd,'Problems/',prob_grp, '*.m'));
prob_list = {};
for i = 1:length(prob_names)
    [path, name, ext] = fileparts(prob_names(i).name);
    prob_list{i} = name;
end
y = prob_list;
