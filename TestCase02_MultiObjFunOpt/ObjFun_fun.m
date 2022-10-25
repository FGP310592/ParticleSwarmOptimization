%% Copyright (Federico Giai Pron)
% This file has been created by Federico Giai Pron, energy engineering with a 2nd level master in energy management for automotive powertrains done after the graduation. For any question, write to federico.giaipron@gmail.com
%% Define the objective functions
function [ObjFun] = ObjFun_fun(X,Data)
%% Input
% Convert the global optimization variable vector, X, into the optimization
% variables
A = X(1);
B = X(2);
C = X(3);
%% Objective functions
% Calculate the objective functions
Ec  = 376.3 + 697*A + 2900*B - 116.3*C - 56667*B^2 + 10.67*C^2 + 11333*A*B - 36.7*A*C;
Ra  = 0.64590 - 0.5461*A - 7.703*B + 0.02107*C + 1.3056*(A^2) + 160.35*(B^2) - 1.083*A*B - 0.07181*A*C;
MRR = 0.03670 + 0.00224*A + 0.536*B - 0.01211*C - 7.28*B^2 + 0.001043*C^2 + 0.645*A*B - 0.0104*B*C;
%% Output
% Collect the objective functions into a single row vector ObjFun
ObjFun(1,1) = Ec;
ObjFun(1,2) = Ra;
ObjFun(1,3) = MRR;
end