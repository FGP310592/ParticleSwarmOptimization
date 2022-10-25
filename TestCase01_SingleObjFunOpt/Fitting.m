%% Copyright (Federico Giai Pron)
% This file has been created by Federico Giai Pron, energy engineering with a 2nd level master in energy management for automotive powertrains done after the graduation. For any question, write to federico.giaipron@gmail.com
%% Clear
clear all
close all
clc
%% Data
% Define points to be fitted
Data.X(:,1) = 273.15 + [10,10,10,10,25,25,25,25,25,25,45,45,45,45,60,25,60,25,25,25,25,25,25,45,45,45,45,45]';
Data.X(:,2) = [0.375,0.4615384615,0.375,0.4615384615,0.5,0.6666666667,1,0.5,0.6666666667,1,0.3,0.375,0.5,0.6666666667,0.6666666667,0.6666666667,0.6666666667,0.6666666667,0.5,0.6666666667,0.33,0.3975903614,0.4962406015,0.5,0.6666666667,0.33,0.3975903614,0.4962406015]';
Data.Z(:,1) = [-7.5537637992E-09,-2.1091060158E-08,-2.4744654476E-09,-1.1909690888E-08,-2.5494146682E-08,-3.6534067388E-08,-2.0441327997E-07,-2.7816139152E-08,-3.9722823789E-08,-2.5558879943E-07,-3.7081071174E-08,-4.3007308318E-08,-6.2938212113E-08,-9.0264728912E-08,-7.9104978801E-08,-3.7248333193E-08,-9.5269370486E-08,-3.7576964623E-08,-6.6857952050E-08,-8.3174676784E-08,-3.0432038521E-08,-3.4780276714E-08,-4.6606775564E-08,-6.9015595281E-08,-1.0059784557E-07,-3.9048782594E-08,-4.9525103732E-08,-6.9429082045E-08]';
% Define the function to be fitted
Data.Function = @(C, X)((C(1)*X(1) + C(2)*X(1)^2 + C(3)*X(1)^3 + C(4)*X(2)^1 + C(5)*X(2)^2 + C(6)*X(2)^3 + C(7)*exp(X(1) * (C(8) - X(2)))) / 1E+09);
%% PSO
% Sizes
Sett.LengthX      = 8; % Select the number of variables          . Its value must be coherent with the number of columns of XGuess, XLim and VLim
Sett.LengthObjFun = 1; % Select the number of objective functions. Its value must be coherent with the number of rows of Sett.ObjFunType and Sett.ObjFunPrio
% Guess value of X
XGuess  = zeros(1,Sett.LengthX); % Select the guess value of X
% Limit values of X and V
XLim(1,: ) = -200*ones(1,Sett.LengthX); % Select the lower limit value of X
XLim(2,: ) = +200*ones(1,Sett.LengthX); % Select the upper limit value of X
VLim(1,:) = -max(abs(XLim))/150;        % Select the lower limit value of V
VLim(2,:) = +max(abs(XLim))/150;        % Select the upper limit value of V
% Objective functions
Sett.ObjFunType(1,1) = "min"; % Select the optimization type for the objective function 1
Sett.ObjFunPrio(1,1) = 1.0;   % Select the priority of the objective function 1
% PSO parameters
win  = 0.3; % Select the initial weight (the weight is linearly reduced from win to wend during the simulation)
wend = 0.0; % Select the final   weight (the weight is linearly reduced from win to wend during the simulation)
c1   = 1;   % Select the coefficient applied to "X-Xpbest" for the calculation of V
c2   = 1;   % Select the coefficient applied to "X-Xgbest" for the calculation of V
% Number of particles / families
Sett.NumPar = 100; % Select the number of particles of each family
Sett.NumFam = 5;   % Select the number of families (the PSO is restarted for Sett.NumFam times and only the optimal one is considered)
% Termination criteria
Sett.NumIterMin = 0;                                   % Select the minimum number of iterations
Sett.NumIterMax = 20;                                  % Select the maximum number of iterations
Sett.VarRelObjFunTrgt   = 0*ones(1,Sett.LengthObjFun); % Select the relative variation at which the simulation is terminated
Sett.RelErrAvObjFunTrgt = 0*ones(1,Sett.LengthObjFun); % Select the relative error     at which the simulation is terminated
% Robustness
Sett.NumIterBtwnRestarts  = inf; % Select the number of iterations between each restart
Sett.NumIterBtwnZeroTests = 5;   % Select the number of iterations between each "zero-test" (the variables are set 1 by 1 equal to a zero value to check if a better objective function is got)
% Flags
Sett.FlagXGuess = false; % Select "true" to initialize X to XGuess, "false" to initialize it randomly
Sett.FlagPlots  = true;  % Select "true" to generate figures and plots
% Run PSO
[XOpt,ObjFunOpt] = Optimization_PSO_v05(XGuess,XLim,VLim,win,wend,c1,c2,Data,Sett); % Run the PSO
%% Plot
% Calculate the fitted quantity
if(Sett.FlagPlots == true)
    xmap = (-25+273.15:5:50+273.15)';
    ymap = (0:0.1:2)';
    [xmapgrid, ymapgrid] = meshgrid(xmap, ymap);
    zmapgrid = 0 * xmapgrid;
    for j = 1:1:length(xmap)
        for i = 1:1:length(ymap)
            zmapgrid(i,j) = Data.Function(XOpt, [xmapgrid(i,j),ymapgrid(i,j)]);
        end
    end
    % Plot the fitted quantity
    figure;
    surfc(xmapgrid, ymapgrid, zmapgrid, 'Linewidth', 1.5);
    hold on;
    scatter3(Data.X(:,1), Data.X(:,2), Data.Z(:,1), 'Linewidth', 1.5);
    legend('Fitting', 'Experimental', 'Location', 'best');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on;
end