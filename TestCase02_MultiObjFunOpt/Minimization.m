%% Copyright (Federico Giai Pron)
% This file has been created by Federico Giai Pron, energy engineering with a 2nd level master in energy management for automotive powertrains done after the graduation. For any question, write to federico.giaipron@gmail.com
%% Clear
clear all
close all
clc
%% Data
Data = [];
%% PSO
% Sizes
Sett.LengthX      = 3; % Select the number of variables          . Its value must be coherent with the number of columns of XGuess, XLim and VLim
Sett.LengthObjFun = 3; % Select the number of objective functions. Its value must be coherent with the number of rows of Sett.ObjFunType and Sett.ObjFunPrio
% Guess value of X
XGuess = zeros(1,Sett.LengthX); % Select the guess value of X
% Limit values of X and V
XLim(1,:) = [0.2,0.02,5];        % Select the lower limit value of X
XLim(2,:) = [0.4,0.04,7];        % Select the upper limit value of X
VLim(1,:) = -max(abs(XLim))/150; % Select the lower limit value of V
VLim(2,:) = +max(abs(XLim))/150; % Select the upper limit value of V
% Objective functions
Sett.ObjFunType(1,1) = "min"; % Select the optimization type for the objective function 1
Sett.ObjFunType(2,1) = "min"; % Select the optimization type for the objective function 2
Sett.ObjFunType(3,1) = "max"; % Select the optimization type for the objective function 3
Sett.ObjFunPrio(1,1) = 1.0;   % Select the priority of the objective function 1
Sett.ObjFunPrio(2,1) = 2.5;   % Select the priority of the objective function 2
Sett.ObjFunPrio(3,1) = 1.0;   % Select the priority of the objective function 3
% PSO parameters
win  = 0.3; % Select the initial weight (the weight is linearly reduced from win to wend during the simulation)
wend = 0.0; % Select the final   weight (the weight is linearly reduced from win to wend during the simulation)
c1   = 0.5; % Select the coefficient applied to "X-Xpbest" for the calculation of V
c2   = 5;   % Select the coefficient applied to "X-Xgbest" for the calculation of V
% Number of particles / families
Sett.NumPar = 1000; % Select the number of particles of each family
Sett.NumFam = 1;    % Select the number of families (the PSO is restarted for Sett.NumFam times and only the optimal one is considered)
% Termination criteria
Sett.NumIterMin = 0;                                   % Select the minimum number of iterations
Sett.NumIterMax = 50;                                  % Select the maximum number of iterations
Sett.VarRelObjFunTrgt   = 0*ones(1,Sett.LengthObjFun); % Select the relative variation at which the simulation is terminated
Sett.RelErrAvObjFunTrgt = 0*ones(1,Sett.LengthObjFun); % Select the relative error     at which the simulation is terminated
% Robustness
Sett.NumIterBtwnRestarts  = inf; % Select the number of iterations between each restart
Sett.NumIterBtwnZeroTests = inf; % Select the number of iterations between each "zero-test" (the variables are set 1 by 1 equal to a zero value to check if a better objective function is got)
% Flags
Sett.FlagXGuess = false; % Select "true" to initialize X to XGuess, "false" to initialize it randomly
Sett.FlagPlots  = true;  % Select "true" to generate figures and plots
% Run PSO
[XOpt,ObjFunOpt] = Optimization_PSO_v04(XGuess,XLim,VLim,win,wend,c1,c2,Data,Sett); % Run the PSO
%% Plot