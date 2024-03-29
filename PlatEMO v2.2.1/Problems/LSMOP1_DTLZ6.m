classdef LSMOP1_DTLZ6 < PROBLEM
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
        function obj = LSMOP1_DTLZ6()
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
            PopDec(:,M:D) = (1+repmat((M:D)./D,N,1)).*PopDec(:,M:D) - repmat(PopDec(:,1)*10,1,D-M+1);
            G = zeros(N,M);
            for i = 1 : 2 : M
                for j = 1 : obj.nk
                    G(:,i) = G(:,i) + DTLZ6(PopDec(:,obj.len(i)+M-1+(j-1)*obj.sublen(i)+1:obj.len(i)+M-1+j*obj.sublen(i)), obj.Global.M);
                end
            end
            for i = 2 : 2 : M
                for j = 1 : obj.nk
                    %G(:,i) = G(:,i) + DTLZ1(PopDec(:,obj.len(i)+M-1+(j-1)*obj.sublen(i)+1:obj.len(i)+M-1+j*obj.sublen(i)), obj.Global.M,obj.Global.D);
					%G(:,i) = G(:,i) + DTLZ2(PopDec(:,obj.len(i)+M-1+(j-1)*obj.sublen(i)+1:obj.len(i)+M-1+j*obj.sublen(i)), obj.Global.M);
					%G(:,i) = G(:,i) + DTLZ3(PopDec(:,obj.len(i)+M-1+(j-1)*obj.sublen(i)+1:obj.len(i)+M-1+j*obj.sublen(i)), obj.Global.M,obj.Global.D);
					%G(:,i) = G(:,i) + DTLZ4(PopDec(:,obj.len(i)+M-1+(j-1)*obj.sublen(i)+1:obj.len(i)+M-1+j*obj.sublen(i)), obj.Global.M);
					%G(:,i) = G(:,i) + DTLZ6(PopDec(:,obj.len(i)+M-1+(j-1)*obj.sublen(i)+1:obj.len(i)+M-1+j*obj.sublen(i)), obj.Global.M);
                    G(:,i) = G(:,i) + Sphere(PopDec(:,obj.len(i)+M-1+(j-1)*obj.sublen(i)+1:obj.len(i)+M-1+j*obj.sublen(i)));
                end
            end
            G      = G./repmat(obj.sublen,N,1)./obj.nk;
            PopObj = (1+G).*fliplr(cumprod([ones(N,1),PopDec(:,1:M-1)],2)).*[ones(N,1),1-PopDec(:,M-1:-1:1)];
        end
        %% Sample reference points on Pareto front
        function P = PF(obj,N)
            P = UniformPoint(N,obj.Global.M);
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

function f = DTLZ6(x,M)
    f = sum(x(:,M:end).^0.01,2);
end

function f = DTLZ7(x,M)
    f = 1+9*mean(x(:,M:end),2);
end

function f = DTLZ1(x,M,D)
    f = 100*(D-M+1+sum((x(:,M:end)-0.5).^2-cos(20.*pi.*(x(:,M:end)-0.5)),2));
end

function f = DTLZ2(x,M)
    f = sum((x(:,M:end)-0.5).^2,2);
end

function f = DTLZ3(x,M,D)
    f = 100*(D-M+1+sum((x(:,M:end)-0.5).^2-cos(20.*pi.*(x(:,M:end)-0.5)),2));
end

function f = DTLZ4(x,M)
	f = sum((x(:,M:end)-0.5).^2,2);
end



