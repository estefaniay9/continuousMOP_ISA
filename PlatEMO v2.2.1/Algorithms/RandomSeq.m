function RandomSeq(Global)
    [type, run] = Global.ParameterSet('test',1);
    rng('default')
    % Start a counter to iterate through the pre-defined sequence.    
    c=1;
    % Generate a sequence of numbers
    % Sequence = rand(Global.evaluation,30);
    % Load sequence
    switch type
        case 'test'
			disp('This is used for testing')
        otherwise
            disp(type)
			%loadseq = getfield(load(strcat(type, '_visit_rw1000_nbr10.mat')),'visit');
			disp(run)
            Sequence = loadseq{run};			
    end
    
    % Initiate the population using the first of the sequence
    Population = INDIVIDUAL(Sequence(c,:));

	while Global.NotTermination(Population)
        c = c + 1;
        % Update the population to be matching that of the sequence
        Population(c) = Sequence(c,:);
    end
end
% main('-algorithm',@RandomSeq,'-problem',@new_ZDT1,'-N',10, '-evaluation', 600)
