clear all
close all
clc
%% Input data
% Point
Data.X(:,1) = 273.15 + [10,10,10,10,25,25,25,25,25,25,45,45,45,45,60,25,60,25,25,25,25,25,25,45,45,45,45,45]';
Data.X(:,2) = [0.375,0.4615384615,0.375,0.4615384615,0.5,0.6666666667,1,0.5,0.6666666667,1,0.3,0.375,0.5,0.6666666667,0.6666666667,0.6666666667,0.6666666667,0.6666666667,0.5,0.6666666667,0.33,0.3975903614,0.4962406015,0.5,0.6666666667,0.33,0.3975903614,0.4962406015]';
% Data.Z(:,1) = [-4.7788983114E-09,-1.2510026229E-08,-1.6195489043E-09,-7.3568071238E-09,-1.4178073421E-08,-1.7737527698E-08,-7.5387093367E-08,-1.5351242987E-08,-1.9152448170E-08,-9.1861677426E-08,-2.4121967994E-08,-2.5906809585E-08,-3.4208404277E-08,-4.2790304005E-08,-2.5577527181E-08,-1.3620230433E-08,-3.0272784405E-08,-1.3641521877E-08,-3.5567995482E-08,-3.8699222702E-08,-1.9487599655E-08,-2.0862553720E-08,-2.5464896671E-08,-3.6475732109E-08,-4.5887706770E-08,-2.4711894260E-08,-2.9516258874E-08,-3.6977631131E-08]'; % With rest
Data.Z(:,1) = [-7.5537637992E-09,-2.1091060158E-08,-2.4744654476E-09,-1.1909690888E-08,-2.5494146682E-08,-3.6534067388E-08,-2.0441327997E-07,-2.7816139152E-08,-3.9722823789E-08,-2.5558879943E-07,-3.7081071174E-08,-4.3007308318E-08,-6.2938212113E-08,-9.0264728912E-08,-7.9104978801E-08,-3.7248333193E-08,-9.5269370486E-08,-3.7576964623E-08,-6.6857952050E-08,-8.3174676784E-08,-3.0432038521E-08,-3.4780276714E-08,-4.6606775564E-08,-6.9015595281E-08,-1.0059784557E-07,-3.9048782594E-08,-4.9525103732E-08,-6.9429082045E-08]'; % Witout rest
% Outliers
% Data.X(15,:) = []; Data.Z(15,1) = [];
% Data.X(17,:) = []; Data.Z(17,1) = [];
% Function
Data.Function = @(C, X)((C(1)*X(1) + C(2)*X(1)^2 + C(3)*X(1)^3 + C(4)*X(2)^1 + C(5)*X(2)^2 +  C(6)*X(2)^3 + C(7)*exp(X(1) * (C(8) - X(2)))) / 1E+09);
%% PSO
% Guess and limit values
LengthX = 8;
XGuess  = zeros(1,LengthX);
XLim    = [-200*ones(1,LengthX);+200*ones(1,LengthX)];
VLim    = [-200*ones(1,LengthX);+200*ones(1,LengthX)];
% PSO parameters
win  = 0.3;
wend = 0.0;
c1 = 1;
c2 = 1;
% Number of particles / families of particles
Sett.NumFam = 10;
Sett.NumPar = 100;
% Termination criteria
Sett.NumIterMin = 0;
Sett.NumIterMax = 200;
Sett.VarRelObjFunTrgt   = 0;
Sett.RelErrAvObjFunTrgt = 0;
% Robustness
Sett.NumIterBtwnRestarts  = inf;
Sett.NumIterBtwnZeroTests = 5;
% Flags
Sett.FlagXGuess = false;
Sett.FlagPlots  = true;
% Run PSO
[X,SSE, Data] = Optimization_PSO_v03(XGuess, XLim, VLim, win, wend, c1, c2, Sett, Data);
AverageRelativeError = sqrt(SSE)/abs(mean(Data.Z(:,1)))/length(Data.Z(:,1));
%% Plot
% Calculation
xmap = (-25+273.15:5:50+273.15)';
ymap = (0:0.1:2)';
[xmapgrid, ymapgrid] = meshgrid(xmap, ymap);
zmapgrid = 0 * xmapgrid;
for j = 1:1:length(xmap)
    for i = 1:1:length(ymap)
        zmapgrid(i,j) = Data.Function(X, [xmapgrid(i,j),ymapgrid(i,j)]);
    end
end
% Plot
figure;
surfc(xmapgrid, ymapgrid, zmapgrid, 'Linewidth', 1.5);
hold on;
scatter3(Data.X(:,1), Data.X(:,2), Data.Z(:,1), 'Linewidth', 1.5);
legend('Fitting', 'Experimental', 'Location', 'best');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;