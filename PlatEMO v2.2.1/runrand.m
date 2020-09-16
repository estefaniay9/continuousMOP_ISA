function runrand(visit, prob_name)

%% This function runs the Randomseq for each of the problems    

    load zdt_params
    load dtlz_params
    load WFG_parameters.mat
    evals = length(visit);

    switch prob_name
        % Depending on the problem name, there are different runs that need
        % to be made
        case "new_ZDT1"
            for i=1:length(zdt1_param)+1
                rng('default')
                if i==length(zdt1_param)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_ZDT1,...,
                        '-evaluation', evals, '-probindex', 0, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_ZDT1, '-probindex', i, ...
                            '-evaluation', evals, '-alpha', zdt1_param(i), ...
                                '-save', 1)
                end
            end

        case "new_ZDT3"
            for i=1:length(zdt3_param)+1
                rng('default')
                if i==length(zdt3_param)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_ZDT3, '-probindex', 0, ...
                    '-evaluation', evals, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_ZDT3, '-probindex', i, ...
                    '-alpha', zdt3_param(i,1), '-q', zdt3_param(i,2), ...
                        '-evaluation', evals, '-save', 1)
                end
            end

        case "new_ZDT4"
            for i=1:length(zdt1_param)+1
                rng('default')
                if i==length(zdt1_param)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_ZDT4,...,
                        '-evaluation', evals, '-probindex', 0, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_ZDT4, '-probindex', i, ...
                            '-evaluation', evals, '-alpha', zdt1_param(i), ...
                                '-save', 1)
                end
            end

        case "new_ZDT6"
            for i=1:length(zdt6_param)+1
                rng('default')
                if i==length(zdt6_param)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_ZDT6,...,
                        '-evaluation', evals, '-probindex', 0, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_ZDT6, '-probindex', i, ...
                            '-evaluation', evals, '-alpha', zdt6_param(i), ...
                                '-save', 1)
                end
            end            

        case "new_DTLZ1"
            for i=1:length(dtlz_params.dtlz1)+1
                rng('default')
                if i==length(dtlz_params.dtlz1)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ1, '-probindex', 0, '-evaluation', evals, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ1, '-probindex', i, ...
                    '-p1', dtlz_params.dtlz1(i,1), '-p2', dtlz_params.dtlz1(i,2), '-p3', dtlz_params.dtlz1(i,3), ...
                        '-evaluation', evals, '-save', 1)
                end
            end

        case "new_DTLZ2"
            for i=1:length(dtlz_params.dtlz2)+1
                rng('default')
                if i==length(dtlz_params.dtlz2)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ2, '-probindex', 0, '-evaluation', evals, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ2, '-probindex', i, ...
                        '-p1', dtlz_params.dtlz2(i,1), ...
                            '-evaluation', evals, '-save', 1)
                end
            end

        case "new_DTLZ3"
            for i=1:length(dtlz_params.dtlz3)+1
                rng('default')
                if i==length(dtlz_params.dtlz3)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ3, '-probindex', 0, '-evaluation', evals, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ3, '-probindex', i, ...
                        '-p1', dtlz_params.dtlz3(i,1), '-p2', dtlz_params.dtlz3(i,2), '-p3', dtlz_params.dtlz3(i,3), ...
                            '-evaluation', evals, '-save', 1)
                end
            end


        case "new_DTLZ4"
            for i=1:length(dtlz_params.dtlz4)+1
                rng('default')
                if i==length(dtlz_params.dtlz4)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ4, '-probindex', 0, '-evaluation', evals, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ4, '-probindex', i, ...
                        '-p1', dtlz_params.dtlz4(i,1), '-p2', dtlz_params.dtlz4(i,2), ...
                            '-evaluation', evals, '-save', 1)
                end
            end


        case "new_DTLZ5"
            for i=1:length(dtlz_params.dtlz5)+1
                rng('default')
                if i==length(dtlz_params.dtlz5)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ5, '-probindex', 0, '-evaluation', evals, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ5, '-probindex', i, ...
                        '-p1', dtlz_params.dtlz5(i,1), ...
                            '-evaluation', evals, '-save', 1)
                end
            end


        case "new_DTLZ6"
            for i=1:length(dtlz_params.dtlz6)+1
                rng('default')
                if i==length(dtlz_params.dtlz6)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ6, '-probindex', 0, '-evaluation', evals, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ6, '-probindex', i, ...
                        '-p1', dtlz_params.dtlz6(i,1), ...
                            '-evaluation', evals, '-save', 1)
                end
            end


        case "new_DTLZ7"
            for i=1:length(dtlz_params.dtlz7)+1
                rng('default')
                if i==length(dtlz_params.dtlz7)+1
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ7, '-probindex', 0, '-evaluation', evals, '-save', 1)
                else
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_DTLZ7, '-probindex', i, ...
                        '-p1', dtlz_params.dtlz7(i,1), '-p2', dtlz_params.dtlz7(i,2), ...
                            '-evaluation', evals, '-save', 1)
                end
            end

        case "new_WFG1"
            for i=1:length(params.s_linear)+1
                rng('default')
                if i==length(params.s_linear)+1
                    % Run for default values
                    main('-algorithm', {@RandomSeq, char(prob_name)}, '-problem', @new_WFG1, '-probindex', 0, ...
                    '-evaluation', evals, '-save', 1)			
                else  
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG1, '-probindex', i, ...
                    '-zmin', params.s_linear(i), '-pfp1', params.mixed(i,1), '-pfp2', params.mixed(i,2), ...
                    '-p1', params.re_b_flat2(i,1), '-p2', params.re_b_flat2(i,2), '-p3', params.re_b_flat2(i,3), ...
                    '-p4', params.b_poly(i), ...
                    '-save',1)
                end
            end
            
        case "new_WFG2"
            for i=1:length(params.s_linear)+1
                rng('default')
                if i==length(params.s_linear)+1
                    % Run for default values
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG2, '-probindex', 0, ...
                        '-evaluation', evals, '-save', 1)
                else  
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG2, '-probindex', i, ...
                    '-zmin', params.s_linear(i), ...
                    '-pfp1', params.disc(i,1), '-pfp2', params.disc(i,2), '-pfp3', params.disc(i,3), ...
                    '-evaluation', evals, '-save', 1)
                end
            end
            
        case "new_WFG3"
            for i=1:length(params.s_linear)+1
                rng('default')
                if i==length(params.s_linear)+1              
    %             Run for default values
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG3, '-probindex', 0, ...
                    '-evaluation', evals, '-save', 1) 
                else  
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG3, '-probindex', i, ...
                    '-zmin', params.s_linear(i), ...
                    '-evaluation', evals, '-save', 1)
                end
            end
            
        case "new_WFG4"
            for i=1:length(params.s_linear)+1
                rng('default')
                if i==length(params.s_linear)+1              
    %             Run for default values
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG4, '-probindex', 0, ...
                    '-evaluation', evals, '-save', 1)    
                else  
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG4, '-probindex', i, ...
                    '-zmin', params.re_s_multi(i,3), ...
                    '-p1', params.re_s_multi(i,1), '-p2', params.re_s_multi(i,2), ...
                    '-evaluation', evals, '-save', 1)
                end
            end
            
        case "new_WFG5"
            for i=1:length(params.s_linear)+1
                rng('default')
                if i==length(params.s_linear)+1              
        %             Run for default values
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG5, '-probindex', 0, ...
                        '-save',1)    
                else  
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG5, '-probindex', i, ...
                        '-zmin', params.re_s_decept(i,1), ...
                        '-p1', params.re_s_decept(i,2), '-p2', params.re_s_decept(i,3), ...
                        '-save',1)
                end
            end
            
        case "new_WFG6"
            for i=1:length(params.s_linear)+1
                rng('default')
                if i==length(params.s_linear)+1
                    % Run for default values
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG6, '-probindex', 0, ...
                        '-evaluation', evals, '-save', 1)
                else  
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG6, '-probindex', i, ...
                        '-zmin', params.s_linear(i), ...
                        '-evaluation', evals, '-save', 1)
                end
            end
            
        case "new_WFG7"
            for i=1:length(params.s_linear)+1
                rng('default')
                if i==length(params.s_linear)+1              
    %             Run for default values
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG7, '-probindex', 0, ...
                        '-evaluation', evals, '-save', 1)
                else  
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG7, '-probindex', i, ...
                        '-zmin', params.s_linear(i), ...
                        '-p1', params.b_param(i,1), '-p2', params.b_param(i,2), '-p3', params.b_param(i,3), ...
                        '-evaluation', evals, '-save', 1)
                end
            end
            
        case "new_WFG8"
            for i=1:length(params.s_linear)+1
                rng('default')
                if i==length(params.s_linear)+1              
    %             Run for default values
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG8, '-probindex', 0, ...
                        '-evaluation', evals, '-save', 1)
                else  
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG8, '-probindex', i, ...
                        '-zmin', params.s_linear(i), ...
                        '-p1', params.b_param(i,1), '-p2', params.b_param(i,2), '-p3', params.b_param(i,3), ...
                        '-evaluation', evals, '-save', 1)
                end
            end
            
        case "new_WFG9"
            for i=1:length(params.s_linear)+1
                rng('default')
                if i==length(params.s_linear)+1              
    %             Run for default values
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG9, '-probindex', 0, ...
                    '-evaluation', evals, '-save', 1)
                else
                    % we let zmin come from the s_decept lhs since it is the first
                    % transition
                    main('-algorithm', {@RandomSeq, char(prob_name)},'-problem',@new_WFG9, '-probindex', i, ...
                    '-zmin', params.re_s_decept(i,1), ...
                    '-p1', params.b_param(i,1), '-p2', params.b_param(i,2), '-p3', params.b_param(i,3), ...
                    '-p4', params.re_s_decept(i,2), '-p5', params.re_s_decept(i,3), ...
                    '-p6', params.re_s_multi(i,1), '-p7', params.re_s_multi(i,2), ...
                    '-evaluation', evals, '-save', 1)
                end

            end
            
        otherwise
            rng('default')
            main('-algorithm',{@RandomSeq, char(prob_name)},'-problem',str2func(char(prob_name)), ...
            '-probindex', 0, '-run', 1, '-evaluation', evals, '-save', 1) 
    end
end
