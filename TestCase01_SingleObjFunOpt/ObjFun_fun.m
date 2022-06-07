%% Copyright (Federico Giai Pron)
% This file has been created by Federico Giai Pron, energy engineering with a 2nd level master in energy management for automotive powertrains done after the graduation. For any question, write to federico.giaipron@gmail.com
function [ObjFun] = ObjFun_fun(X,Data)
%% Input
% Convert the global optimization variable vector, X, into the optimization
% variables
%% Objective functions
% Calculate the objective functions
n = length(Data.Z(:,1));
Z = zeros(n,1);
for k = 1:1:n
    Z(k,1) = Data.Function(X, Data.X(k,:));
end
SSE = 0;
for k = 1:1:n
    SSE = SSE + (Z(k,1) - Data.Z(k,1))^2;
end
%% Output
% Collect the objective functions into a single row vector ObjFun
ObjFun(1,1) = SSE;
end