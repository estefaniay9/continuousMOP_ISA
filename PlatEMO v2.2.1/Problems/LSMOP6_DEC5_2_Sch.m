classdef LSMOP6_DEC5_2_Sch < PROBLEM
% <problem> <LSMOP>
% Large-scale benchmark MOP
% nk --- 5 --- Number of subcomponents in each variable group

%------------------------------- Reference --------------------------------
% R. Cheng, Y. Jin, and M. Olhofer, Test problems for large-scale
% multiobjective and many-objective optimization, IEEE Transactions on
% Cybernetics, 2017, 47(12): 4108-4121.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    properties(Access = private)
        nk = 5; % Number of subcomponents in each variable group
        sublen;	% Number of variables in each subcomponent
        len;    % Cumulative sum of lengths of variable groups
    end
    methods
        %% Initialization
        function obj = LSMOP6_DEC5_2_Sch()
            % Parameter setting
            obj.nk = obj.Global.ParameterSet(5);
            if isempty(obj.Global.M)
                obj.Global.M = 3;
            end
            if isempty(obj.Global.D)
                %obj.Global.D = 100*obj.Global.M;
				obj.Global.D = 30;
            end
            obj.Global.lower    = zeros(1,obj.Global.D);
            obj.Global.upper    = [ones(1,obj.Global.M-1),10.*ones(1,obj.Global.D-obj.Global.M+1)];
            obj.Global.encoding = 'real';
            % Calculate the number of variables in each subcomponent
            c = 3.8*0.1*(1-0.1);
            for i = 1 : obj.Global.M-1
                c = [c,3.8.*c(end).*(1-c(end))];
            end
            obj.sublen = floor(c./sum(c).*obj.Global.D/obj.nk);
            obj.len    = [0,cumsum(obj.sublen*obj.nk)];
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            [N,D] = size(PopDec);
            M     = obj.Global.M;
            PopDec(:,M:D) = (1+repmat(cos((M:D)./D*pi/2),N,1)).*PopDec(:,M:D) - repmat(PopDec(:,1)*10,1,D-M+1);
            G = zeros(N,M);
            for i = 1 : 2 : M
                for j = 1 : obj.nk
                    G(:,i) = G(:,i) + Deceptive5(PopDec(:,obj.len(i)+M-1+(j-1)*obj.sublen(i)+1:obj.len(i)+M-1+j*obj.sublen(i)));
                end
            end
            for i = 2 : 2 : M
                for j = 1 : obj.nk
                    G(:,i) = G(:,i) + Schwefel(PopDec(:,obj.len(i)+M-1+(j-1)*obj.sublen(i)+1:obj.len(i)+M-1+j*obj.sublen(i)));
                end
            end
            G      = G./repmat(obj.sublen,N,1)./obj.nk;
            PopObj = (1+G+[G(:,2:end),zeros(N,1)]).*fliplr(cumprod([ones(N,1),cos(PopDec(:,1:M-1)*pi/2)],2)).*[ones(N,1),sin(PopDec(:,M-1:-1:1)*pi/2)];
        end
        %% Sample reference points on Pareto front
        function P = PF(obj,N)
            P = UniformPoint(N,obj.Global.M);
            P = P./repmat(sqrt(sum(P.^2,2)),1,obj.Global.M);
        end
    end
end

function f = Sphere(x)
    f = sum(x.^2,2);
end

function f = Rastrigin(x)
    f = sum(x.^2-10.*cos(2.*pi.*x)+10,2);
end

function f = Schwefel(x)
    f = max(abs(x),[],2);
end

function f = Rosenbrock(x)
    f = sum(100.*(x(:,1:size(x,2)-1).^2-x(:,2:size(x,2))).^2+(x(:,1:size(x,2)-1)-1).^2,2);
end

function f = Deceptive1(x) %multimodal deceptive
	f = 10*(exp(1)-exp(1-sin(sum(2*pi*(x-1),2)).^2)+exp(sum(sin(2*pi*(x-1).^2),2))-cos(sum(pi*(x),2)).^2).^2;
end

function f = Deceptive2(x) %multimodal deceptive
	f = 10*10*sum(cos(pi/2.*(x-1)).^2,2).*(sum(sin(x-1).^2,2)).^0.01;
end

function f = Deceptive3(x) %biased deceptive
	f = 10*abs(sum((1./x),2)/size(x,2)-1).^0.1;
end

function f = Deceptive4(x) %biased deceptive
	f = 10*(10 - 10*exp(-0.2*sqrt((1/2).*sum((x-1).^2,2)))).^0.1;
end

function f = Deceptive5(x) %biased deceptive
	f = 2*(10 -10*exp(-sqrt((1/2).*sum((x-1).^2,2)))-sum(sin(x-1).^2,2)).^0.01;
end

function f = Deceptive6(x) %biased and deceptive
	f = 10*(2*sqrt(abs(sum(x-x.^2,2)))+0.01*abs(sum(x.^2,2))).^0.01;
end

function f = Deceptive7(x) %biased and deceptive
	f = 10*sum(cos(pi/2.*(x-1)).^12,2).*(sum(sin(x-1).^2,2)).^0.01;;
end

function f = Deceptive0(x) %base function
	f = sum(x.^0.01,2);
end

function f = Bias0(x) %base function
	f = 3*sum(x,2).^0.1
end

