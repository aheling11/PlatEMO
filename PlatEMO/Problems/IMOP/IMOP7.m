classdef IMOP7 < PROBLEM
% <problem> <IMOP>
% Benchmark MOP with irregular Pareto front
% a1 --- 0.05 --- Parameter a1
% a2 ---   10 --- Parameter a2
% K  ---    5 --- Parameter K

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    properties(Access = private)
        a1 = 0.05;  % Parameter a1
        a2 = 10;    % Parameter a2
        K  = 5;     % Parameter K
    end
    methods
        %% Initialization
        function obj = IMOP7()
            [obj.a1,obj.a2,obj.K] = obj.Global.ParameterSet(0.05,10,5);
            obj.Global.M = 3;
            if isempty(obj.Global.D)
                obj.Global.D = 10;
            end
            obj.Global.lower    = zeros(1,obj.Global.D);
            obj.Global.upper    = ones(1,obj.Global.D);
            obj.Global.encoding = 'real';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            y1 = mean(PopDec(:,1:2:obj.K),2).^obj.a1;
            y2 = mean(PopDec(:,2:2:obj.K),2).^obj.a2;
            g  = sum((PopDec(:,obj.K+1:end)-0.5).^2,2);
            PopObj(:,1) = (1+g).*cos(y1*pi/2).*cos(y2*pi/2);
            PopObj(:,2) = (1+g).*cos(y1*pi/2).*sin(y2*pi/2);
            PopObj(:,3) = (1+g).*sin(y1*pi/2);
            r = min(min(abs(PopObj(:,1)-PopObj(:,2)),abs(PopObj(:,2)-PopObj(:,3))),abs(PopObj(:,3)-PopObj(:,1)));
            PopObj = PopObj + repmat(10*max(0,r-0.1),1,3);
        end
        %% Sample reference points on Pareto front
        function P = PF(obj,N)
            P = UniformPoint(N,3);
            P = P./repmat(sqrt(sum(P.^2,2)),1,3);
            r = min(min(abs(P(:,1)-P(:,2)),abs(P(:,2)-P(:,3))),abs(P(:,3)-P(:,1)));
            P(r>0.1,:) = [];
        end
    end
end