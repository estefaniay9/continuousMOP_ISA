classdef GLOBAL < handle
%GLOBAL - The class of experimental setting.
%
%   This is the class of experimental setting. An object of GLOBAL class
%   stores the algorithm to be executed, the problem to be solved, and all
%   the parameter settings like population size, number of objectives, and
%   maximum number of evaluations. This class also has several methods
%   which can be invoked by algorithms.
%
% GLOBAL properties:
%   N               <public>	population size
%   M               <read-only>	number of objectives
%   D               <read-only>	number of variables
%   lower           <read-only>	lower bound of each decision variable
%   upper           <read-only>	upper bound of each decision variable
%   algorithm       <read-only>	algorithm function
%   problem         <read-only>	problem function
%   alpha           <read-only> controls the alpha parameter in ZDT functions
%   ctrlseq         <read-only> controls sequence of wfg transformations
%   encoding        <read-only> encoding of the problem
%   evaluated       <read-only>	number of evaluated individuals
%   evaluation      <read-only>	maximum number of evaluations
%   gen             <read-only>	current generation
%   maxgen          <read-only>	maximum generation
%   run             <read-only>	run number
%   runtime         <read-only>	runtime
%   save            <read-only> number of saved populations
%   result          <read-only>	set of saved populations
%   PF              <read-only>	true Pareto front
%   parameter       <read-only>	parameters of functions specified by users
%   outputFcn    	<read-only>	function invoked after each generation
%
% GLOBAL methods:
%   GLOBAL          <public>    the constructor, all the properties will be
%                               set when the object is creating
%   Start           <public>    start running the algorithm
%   Initialization  <public>    randomly generate an initial population
%   NotTermination  <public>	terminate the algorithm if the number of
%                               evaluations has exceeded
%   ParameterSet    <public>    obtain the parameter settings from user
%   GetObj          <static>    get the current GLOBAL object

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    properties
        N          = 100;               % Population size
    end
    properties(SetAccess = ?PROBLEM)
        zmin;                           % Controls where the minimum value of z is mapped to for WFG
        p1; p2; p3; p4; p5; p6; p7;     % Custom parameters for WFG
        alpha; pfp1; pfp2; pfp3;        % Parameter values controlling PF shape
        ctrlseq;                        % Dummy to identify which transformation sequence of the WFG function we're using
		probindex;						% Dummy to identify which problem index for a perturbation we are on
        q;                              % Parameter value controlling number of discontinous PF		
        M;                              % Number of objectives
        D;                              % Number of decision variables
        lower;                          % Lower bound of each decision variable
        upper;                          % Upper bound of each decision variable
        encoding   = 'real';            % Encoding of the problem
        evaluation = 10000;             % Maximum number of evaluations
    end
    properties(SetAccess = ?INDIVIDUAL)
        evaluated  = 0;                 % Number of evaluated individuals
    end
    properties(SetAccess = private)
        algorithm  = @NSGAII;       	% Algorithm function
        problem    = @DTLZ2;            % Problem function
        gen;                            % Current generation
        maxgen;                         % Maximum generation
        run        = 1;                 % Run number
        runtime    = 0;                 % Runtime
        save       = 0;             	% Number of saved populations
        result     = {};                % Set of saved populations
        PF;                             % True Pareto front
        parameter  = struct();      	% Parameters of functions specified by users
        outputFcn  = @GLOBAL.Output;  	% Function invoked after each generation
    end
    methods
        %% Constructor
        function obj = GLOBAL(varargin)
        %GLOBAL - Constructor of GLOBAL class.
        %
        %   GLOBAL('-Name',Value,'-Name',Value,...) returns an object with
        %   the properties specified by the inputs.
        %
        %   Example:
        %       GLOBAL('-algorithm',@NSGAII,'-problem',@DTLZ2,'-N',100,...
        %              '-M',2,'-D',10)
        
            obj.GetObj(obj);
            % Initialize the parameters which can be specified by users
            propertyStr = {'N','M','D', 'zmin', 'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'pfp1', 'pfp2', 'pfp3', ...
					'probindex', 'alpha', 'q', 'ctrlseq' ...
					'algorithm','problem','evaluation','run','save','outputFcn'};
            if nargin > 0
                IsString = find(cellfun(@ischar,varargin(1:end-1))&~cellfun(@isempty,varargin(2:end)));
                [~,Loc]  = ismember(varargin(IsString),cellfun(@(S)['-',S],propertyStr,'UniformOutput',false));
                for i = find(Loc)
                    obj.(varargin{IsString(i)}(2:end)) = varargin{IsString(i)+1};
                end
            end
            % Instantiate a problem object
            obj.problem = obj.problem();
            % Add the folders of the algorithm and problem to the top of
            % the search path
            addpath(fileparts(which(class(obj.problem))));
            addpath(fileparts(which(func2str(obj.algorithm))));
        end
        %% Start running the algorithm
        function Start(obj)
        %Start - Start running the algorithm.
        %
        %   obj.Start() runs the algorithm. This method of one GLOBAL
        %   object can only be invoked once.
        %
        %   Example:
        %       obj.Start()

            if obj.evaluated <= 0
                obj.PF = obj.problem.PF(10000);
                try
                    tic;
                    obj.algorithm(obj);
                catch err
                    if strcmp(err.identifier,'GLOBAL:Termination')
                        return;
                    else
                        rethrow(err);
                    end
                end
                obj.evaluated = max(obj.evaluated,obj.evaluation);
                if isempty(obj.result)
                    obj.result = {obj.evaluated,INDIVIDUAL()};
                end
            	obj.outputFcn(obj);
            end
        end
        %% Randomly generate an initial population
        function Population = Initialization(obj,N)
        %Initialization - Randomly generate an initial population.
        %
        %   P = obj.Initialization() returns an initial population, i.e.,
        %   an array of obj.N INDIVIDUAL objects.
        %
        %   P = obj.Initialization(N) returns an initial population with N
        %   individuals.
        %
        %   Example:
        %       P = obj.Initialization()
        
            if nargin < 2
                N = obj.N;
            end
            Population = INDIVIDUAL(obj.problem.Init(N));
        end
        %% Terminate the algorithm if the number of evaluations has exceeded
        function notermination = NotTermination(obj,Population)
        %NotTermination - Terminate the algorithm if the number of
        %evaluations has exceeded.
        %
        %   obj.NotTermination(P) stores the population P as the final
        %   population for output, and returns true if the number of
        %   evaluations has not exceeded (otherwise returns false). If the
        %   number of evaluations has exceeded, then throw an error to
        %   terminate the algorithm forcibly.
        %
        %   This function should be invoked after each generation, and the
        %   function obj.outputFcn will be invoked when obj.NotTermination
        %   is invoked.
        %
        %   The runtime of executing this function and obj.outputFcn is not
        %   counted as part of the runtime of the algorithm.
        %
        %   Example:
        %       obj.NotTermination(Population)
        
            % Accumulate the runtime
            obj.runtime = obj.runtime + toc;
            % Save the last population
            if obj.save<=0; num=10; else; num=obj.save; end
            index = max(1,min(min(num,size(obj.result,1)+1),ceil(num*obj.evaluated/obj.evaluation)));
            obj.result(index,:) = {obj.evaluated,Population};
            % Invoke obj.outputFcn
            drawnow();
            obj.outputFcn(obj);
            % Detect whether the number of evaluations has exceeded
            notermination = obj.evaluated < obj.evaluation;
            assert(notermination,'GLOBAL:Termination','Algorithm has terminated');
            tic;
        end
        %% Obtain the parameter settings from user
        function varargout = ParameterSet(obj,varargin)
        %ParameterSet - Obtain the parameter settings from user.
        %
        %   [p1,p2,...] = obj.ParameterSet(v1,v2,...) returns the values of
        %   p1, p2, ..., where v1, v2, ... are their default values. The
        %   values are specified by the user with the following form:
        %   MOEA(...,'-X_parameter',{p1,p2,...},...), where X is the
        %   function name of the caller.
        %
        %   MOEA(...,'-X_parameter',{[],p2,...},...) indicates that p1 is
        %   not specified by the user, and p1 equals to its default value
        %   v1.
        %
        %   Example:
        %       [p1,p2,p3] = obj.ParameterSet(1,2,3)

            CallStack = dbstack();
            caller    = CallStack(2).file;
            caller    = caller(1:end-2);
            varargout = varargin;
            if isfield(obj.parameter,caller)
                specified = cellfun(@(S)~isempty(S),obj.parameter.(caller));
                varargout(specified) = obj.parameter.(caller)(specified);
            end
        end
        %% Variable constraint
        function set.N(obj,value)
            obj.Validation(value,'int','size of population ''-N''',1);
            obj.N = value;
        end
        function set.zmin(obj,value)
			obj.Validation(value,'double','zmin custom parameter''-zmin''',1);
            obj.zmin = value;
        end
        function set.p1(obj,value)
			obj.Validation(value,'double','p1 custom parameter''-p1''',1);
            obj.p1 = value;
        end
        function set.p2(obj,value)
			obj.Validation(value,'double','p2 custom parameter''-p2''',1);
            obj.p2 = value;
        end
        function set.p3(obj,value)
			obj.Validation(value,'double','p3 custom parameter''-p3''',1);
            obj.p3 = value;
        end
        function set.p4(obj,value)
			obj.Validation(value,'double','p4 custom parameter''-p4''',1);
            obj.p4 = value;
        end
        function set.p5(obj,value)
			obj.Validation(value,'double','p5 custom parameter''-p5''',1);
			obj.p5 = value;
        end
        function set.p6(obj,value)
			obj.Validation(value,'double','p6 custom parameter''-p6''',1);
            obj.p6 = value;
        end
        function set.p7(obj,value)
			obj.Validation(value,'double','p7 custom parameter''-p7''',1);
            obj.p7 = value;
        end
        function set.pfp1(obj,value)
			obj.Validation(value,'double','pfp1 pf custom parameter 1''-p1''',1);
            obj.pfp1 = value;
        end			        
		function set.pfp2(obj,value)
			obj.Validation(value,'double','pfp2 pf custom parameter 2''-p2''',1);
            obj.pfp2 = value;
        end			        
        function set.pfp3(obj,value)
			obj.Validation(value,'double','pfp3 pf custom parameter 3''-p3''',1);
            obj.pfp3 = value;
        end			
        function set.probindex(obj,value)
            obj.Validation(value,'double','problem index parameter''-probindex''',1);
            obj.probindex = value;
            %obj.probindex = obj.Set('probindex',value,'double','problem index parameter''-probindex''',1);
        end		
        function set.alpha(obj,value)
			obj.Validation(value,'double','alpha parameter ''-alpha''',1);
            obj.alpha = value;
        end
        function set.q(obj,value)
			obj.Validation(value,'int','q parameter ''-q''',1);
            obj.q = value;
        end
            function set.ctrlseq(obj,value)
            obj.Validation(value,'int','ctrlseq parameter ''-ctrlseq''',1);
            obj.ctrlseq = value;
        end
        function set.M(obj,value)
            obj.Validation(value,'int','number of objectives ''-M''',2);
            obj.M = value;
        end
        function set.D(obj,value)
            obj.Validation(value,'int','number of variables ''-D''',1);
            obj.D = value;
        end
        function set.algorithm(obj,value)
            if iscell(value) 
                obj.Validation(value{1},'function','algorithm ''-algorithm''');
                obj.algorithm = value{1};
                obj.parameter.(func2str(value{1})) = value(2:end);
            else
                obj.Validation(value,'function','algorithm ''-algorithm''');
                obj.algorithm = value;
            end
        end
        function set.problem(obj,value)
            if iscell(value)
                obj.Validation(value{1},'function','test problem ''-problem''');
                obj.problem = value{1};
                obj.parameter.(func2str(value{1})) = value(2:end);
            elseif ~isa(value,'PROBLEM')
                obj.Validation(value,'function','test problem ''-problem''');
                obj.problem = value;
            else
                obj.problem = value;
            end
        end
        function set.evaluation(obj,value)
            obj.Validation(value,'int','number of evaluations ''-evaluation''',1);
            obj.evaluation = value;
        end
        function set.run(obj,value)
            obj.Validation(value,'int','run number ''-run''',1);
            obj.run = value;
        end
        function set.save(obj,value)
            obj.Validation(value,'int','number of saved populations ''-save''',0);
            obj.save = value;
        end
        %% Variable dependence
        function value = get.gen(obj)
            value = ceil(obj.evaluated/obj.N);
        end
        function value = get.maxgen(obj)
            value = ceil(obj.evaluation/obj.N);
        end
    end
    methods(Static)
        %% Get the current GLOBAL object
        function obj = GetObj(obj)
        %GetObj - Get the current GLOBAL object.
        %
        %   Global = GLOBAL.GetObj() returns the current GLOBAL object.
        %
        %   Example:
        %       Global = GLOBAL.GetObj()
        
            persistent Global;
            if nargin > 0
                Global = obj;
            else
                obj = Global;
            end
        end
    end

    % The following functions cannot be invoked by users
    methods(Access = private)
        %% Check the validity of the specific variable
        function Validation(obj,value,Type,str,varargin)
            switch Type
                case 'function'
                    assert(isa(value,'function_handle'),'INPUT ERROR: the %s must be a function handle',str);
                    assert(~isempty(which(func2str(value))),'INPUT ERROR: the function <%s> does not exist',func2str(value));
                case 'int'
                    assert(isa(value,'double') && isreal(value) && isscalar(value) && value==fix(value),'INPUT ERROR: the %s must be an integer scalar',str);
                    if ~isempty(varargin); assert(value>=varargin{1},'INPUT ERROR: the %s must be not less than %d',str,varargin{1}); end
                    if length(varargin) > 1; assert(value<=varargin{2},'INPUT ERROR: the %s must be not more than %d',str,varargin{2}); end
                    if length(varargin) > 2; assert(mod(value,varargin{3})==0,'INPUT ERROR: the %s must be a multiple of %d',str,varargin{3}); end
            end
        end
    end
    methods(Access = private, Static)
        %% Display or save the result after the algorithm is terminated
        function Output(obj)
            clc; fprintf('%s on %s, %d objectives %d variables, run %d (%6.2f%%), %.2fs passed...\n',...
                         func2str(obj.algorithm),class(obj.problem),obj.M,obj.D,obj.run,obj.evaluated/obj.evaluation*100,obj.runtime);
            if obj.evaluated >= obj.evaluation
                if obj.save == 0
                    % Identify the feasible and non-dominated solutions in the
                    % final population
                    Feasible     = find(all(obj.result{end}.cons<=0,2));
                    NonDominated = NDSort(obj.result{end}(Feasible).objs,1) == 1;
                    Population   = obj.result{end}(Feasible(NonDominated));
                    % Calculate the metric values
                    if length(Population) >= size(obj.PF,1)
                        Metrics = {@HV};
                    else
                        Metrics = {@IGD};
                    end
                    Score     = cellfun(@(S)GLOBAL.Metric(S,Population,obj.PF),Metrics,'UniformOutput',false);
                    MetricStr = cellfun(@(S)[func2str(S),' : %.4e  '],Metrics,'UniformOutput',false);
                    % Display the results
                    figure('NumberTitle','off','UserData',struct(),...
                           'Name',sprintf([MetricStr{:},'Runtime : %.2fs'],Score{:},obj.runtime));
                    title(sprintf('%s on %s',func2str(obj.algorithm),class(obj.problem)),'Interpreter','none');
                    Draw(Population.objs);
                    % Add new menus to the figure
                    top = uimenu(gcf,'Label','Data Source');
                    uimenu(top,'Label','Result (PF)',     'CallBack',{@(hObject,~,obj,P)eval('cla;Draw(P.objs);GLOBAL.cb_menu(hObject);'),obj,Population},'Checked','on');
                    uimenu(top,'Label','Result (PS)',     'CallBack',{@(hObject,~,obj,P)eval('cla;Draw(P.decs);GLOBAL.cb_menu(hObject);'),obj,Population});
                    uimenu(top,'Label','Result (Special)','CallBack',{@(hObject,~,obj,P)eval('obj.problem.Draw(P.decs);GLOBAL.cb_menu(hObject);'),obj,Population});
                    uimenu(top,'Label','True PF',         'CallBack',{@(hObject,~,obj)eval('cla;Draw(obj.PF);GLOBAL.cb_menu(hObject);'),obj},'Separator','on');
                    uimenu(top,'Label','IGD',             'CallBack',{@GLOBAL.cb_metric,obj,@IGD},'Separator','on');
                    uimenu(top,'Label','HV',              'CallBack',{@GLOBAL.cb_metric,obj,@HV});
                    uimenu(top,'Label','GD',              'CallBack',{@GLOBAL.cb_metric,obj,@GD});
                    uimenu(top,'Label','CPF',             'CallBack',{@GLOBAL.cb_metric,obj,@CPF});
                else
                    folder = fullfile('Data',class(obj.problem), func2str(obj.algorithm));
                    [~,~]  = mkdir(folder);
                    result         = obj.result;
                    Feasible     = find(all(obj.result{end}.cons<=0,2));
                    NonDominated = NDSort(obj.result{end}(Feasible).objs,1) == 1;
                    Population   = obj.result{end}(Feasible(NonDominated));
					PF			   = obj.PF;
					run_num        = obj.run;
                    metric.runtime = obj.runtime;
					input.alpha    = obj.alpha;
					input.q        = obj.q;
					input.zmin     = obj.zmin;
					input.p1       = obj.p1;
					input.p2       = obj.p2;
					input.p3       = obj.p3;
					input.p4       = obj.p4;
					input.p5       = obj.p5;
					input.p6       = obj.p6;
					input.p7       = obj.p7;
					input.pfp1     = obj.pfp1;
					input.pfp2     = obj.pfp2;
					input.pfp3     = obj.pfp3;
                    input.ctrlseq  = obj.ctrlseq;
					input.probindex = obj.probindex;
					input.evaluations = obj.evaluation;
					Metrics   = {@IGD @NIGD @IGDplus @IGDplusm};
					Score     = cellfun(@(S)GLOBAL.Metric(S,Population,obj.PF),Metrics,'UniformOutput',false);
					%add these back into metric if required 
                    %metric.HV = cell2mat(Score(1));
					%metric.NHV = cell2mat(Score(2));
					metric.IGD = cell2mat(Score(1));										
					metric.NIGD = cell2mat(Score(2));					
					metric.IGDplus = cell2mat(Score(3));					
					metric.IGDplusm = cell2mat(Score(4));					
                    %save(fullfile(folder,sprintf('%s_%s_M%d_D%d_%d.mat',func2str(obj.algorithm),class(obj.problem),obj.M,obj.D,obj.run)),'result','metric', 'input', 'PF');
					save(fullfile(folder,sprintf('%s_%s_probindex%1.1f_%d_%d.mat',...
						func2str(obj.algorithm),class(obj.problem),obj.probindex, obj.evaluation, obj.run)),...
							'result', 'metric', 'run_num', 'PF', 'input');
                end
            end
        end
        function cb_metric(hObject,eventdata,obj,metric)
            metricName   = func2str(metric);
            MetricValues = get(gcbf,'UserData');
            % Calculate the specified metric value of each population
            if ~isfield(MetricValues,func2str(metric)) 
                tempText = text('Units','normalized','Position',[.4 .5 0],'String','Please wait ... ...'); drawnow();
                MetricValues.(metricName)(:,1) = obj.result(:,1);
                MetricValues.(metricName)(:,2) = cellfun(@(S)GLOBAL.Metric(metric,S,obj.PF),obj.result(:,2),'UniformOutput',false);
                set(gcbf,'UserData',MetricValues);
                delete(tempText);
            end
            % Display the results
            cla; Draw(cell2mat(MetricValues.(metricName)),'-k.','LineWidth',1.5,'MarkerSize',10);
            xlabel('Number of Evaluations');
            ylabel(metricName);
            GLOBAL.cb_menu(hObject);
        end
        function cb_menu(hObject)
            % Switch the selected menu
            set(get(get(hObject,'Parent'),'Children'),'Checked','off');
            set(hObject,'Checked','on');
        end
        function value = Metric(metric,Population,PF)
            % Calculate the metric value of the population
            Feasible     = find(all(Population.cons<=0,2));
            NonDominated = NDSort(Population(Feasible).objs,1) == 1;
            try
                value = metric(Population(Feasible(NonDominated)).objs,PF);
            catch
                value = NaN;
            end
        end
    end
end