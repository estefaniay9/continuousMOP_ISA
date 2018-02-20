function varargout = COCO52(Operation,Global,input)
% <problem> <COCO52>
% Comparison of Multiobjective Evolutionary Algorithms: Empirical Results
% operator --- EAreal
% E.g. call as
% main('-algorithm',@NSGAII,'-problem',@COCO52,'-N',100, '-run', 2, '-D', 2)

% Function is fixed to COCO function number (55 functions)
% Instances will be controlled by run specified (max 15 for COCO)
% Dimensions from COCO can be [2, 3, 5, 10, 20, 40]
   
    F_idx = 52;
    I_idx = Global.run;
    dims = [2 3 5 10 20 40];
    D_idx = find(dims == Global.D);
    P_idx = 15*(F_idx-1)+(I_idx-1)+825*(D_idx-1);
    
    % Problem index is calculated across Function (1-55) x Instance (1-15)
    % x  Dimension (1-6) as:
        % P_idx = 15*(F_idx-1)+(I_idx-1)+825*(D_idx-1)
    
    % Set up COCO problem;
    suite_name = 'bbob-biobj';
    suite = cocoSuite(suite_name, '', '');
    problem = cocoSuiteGetProblem(suite,P_idx);
    CostFunction=@(x)cocoEvaluateFunction(problem, x);
    
    switch Operation
        case 'init'
            
            Global.M        = 2;
            Global.M        = 2;
            Global.D        = length(cocoProblemGetSmallestValuesOfInterest(problem));
            Global.lower    = cocoProblemGetSmallestValuesOfInterest(problem);
            Global.upper    = cocoProblemGetLargestValuesOfInterest(problem);
            Global.operator = @EAreal;
            
            PopDec    = rand(input,Global.D);

            varargout = {PopDec};
            
        case 'value'

            PopDec = input;
            
            PopObj = [];
            for i = 1:length(PopDec)
                PopCost = CostFunction(PopDec(i,1:end));
                PopObj = [PopObj; PopCost];
            end

            PopCon = [];
            
            varargout = {input,PopObj,PopCon};
            
        case 'PF'
            
            % Make a dummy PF for now - we don't really care what it is at
            % all.
            f(:,1)    = zeros(1,2);
            f(:,2)    = zeros(1,2);
            varargout = {f};
    end
end