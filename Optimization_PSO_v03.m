%% Copyright %%
% This file has been created by Federico Giai Pron, energy engeneering with a 2nd level master in energy managment for automotive powertrains done after the graduation. For any question, write to federico.giaipron@gmail.com

%% Particle Swarm Optimization (PSO)
function [Xfbest, ObjFunfbest, Data] = Optimization_PSO_v03(XGuess, XLim, VLim, win, wend, c1, c2, Sett, Data)
% Parameters
LengthX = length(XGuess);
% Initialization
X                   = zeros(Sett.NumPar,LengthX);
Xpbest              = zeros(Sett.NumPar,LengthX);
V                   = zeros(Sett.NumPar,LengthX);
Xzerotest           = zeros(1,LengthX);
Xgbest              = zeros(1,LengthX);
Xfbest              = zeros(1,LengthX);
ObjFun              = zeros(Sett.NumPar,1);
ObjFunpbest         = zeros(Sett.NumPar,1);
ObjFunpbestguest    = zeros(Sett.NumPar,1);
ObjFungbest         = 0;
ObjFungbestold      = 0;
ObjFunfbest         = 0;
ObjFungbestPlots    = zeros(Sett.NumIterMax,Sett.NumFam);
AvObjFunPlots       = zeros(Sett.NumIterMax,Sett.NumFam);
VarRelObjFunPlots   = zeros(Sett.NumIterMax,Sett.NumFam);
RelErrAvObjFunPlots = zeros(Sett.NumIterMax,Sett.NumFam);
% Calculation
for IndexFam = 1:1:Sett.NumFam
    fprintf('- IndexFam:    %3i out of %3i\n',IndexFam,Sett.NumFam);
    % Initialization
    IndexIter      = 0;
    VarRelObjFun   = inf;
    RelErrAvObjFun = inf;
    % Iteration
    while(((VarRelObjFun > Sett.VarRelObjFunTrgt || RelErrAvObjFun > Sett.RelErrAvObjFunTrgt) && IndexIter < Sett.NumIterMax) || IndexIter - Sett.NumIterMin <= 0)
        IndexIter = IndexIter + 1;
        fprintf('-- IndexIter:  %3i out of %3i\n',IndexIter,Sett.NumIterMax);
        % X & V
        for IndexPar = 1:1:Sett.NumPar
            % Initialization || Restart
            if IndexIter == 1 || rem(IndexIter,Sett.NumIterBtwnRestarts) == 0
                if(Sett.FlagXGuess == true)
                    for IndexX = 1:1:LengthX
                        X(IndexPar,IndexX) = XGuess(1,IndexX);
                        V(IndexPar,IndexX) = VLim(1,IndexX) + (VLim(2,IndexX) - VLim(1,IndexX))*rand(1);
                    end
                else
                    for IndexX = 1:1:LengthX
                        X(IndexPar,IndexX) = XLim(1,IndexX) + (XLim(2,IndexX) - XLim(1,IndexX))*rand(1);
                        V(IndexPar,IndexX) = VLim(1,IndexX) + (VLim(2,IndexX) - VLim(1,IndexX))*rand(1);
                    end
                end
            % Update
            else
                r1 = rand(1);
                r2 = rand(1);
                for IndexX = 1:1:LengthX
                    w = win - (win - wend) * IndexIter / Sett.NumIterMax;
                    V(IndexPar,IndexX) = min(max(w*V(IndexPar,IndexX) + c1*r1*(Xpbest(IndexPar,IndexX)-X(IndexPar,IndexX)) + c2*r2*(Xgbest(1,IndexX)-X(IndexPar,IndexX)),VLim(1,IndexX)),VLim(2,IndexX));
                    X(IndexPar,IndexX) = min(max(X(IndexPar,IndexX) + V(IndexPar,IndexX)                                                                                ,XLim(1,IndexX)),XLim(2,IndexX));
                end
            end
        end
        % ObjFun calculation
        for IndexPar = 1:1:Sett.NumPar
            fprintf('--- IndexPar:  %3i out of %3i\n',IndexPar,Sett.NumPar);
            ObjFun(IndexPar,1) = ObjFun_fun(X(IndexPar,:), Data);
        end
        % Xpbest determination
        for IndexPar = 1:1:Sett.NumPar
            if IndexIter == 1
                for IndexX = 1:1:LengthX
                    Xpbest(IndexPar,IndexX) = X(IndexPar,IndexX);
                end
                ObjFunpbest(IndexPar,1) = ObjFun(IndexPar,1);
            else
                if(ObjFun(IndexPar,1) < ObjFunpbest(IndexPar,1))
                    for IndexX = 1:1:LengthX
                        Xpbest(IndexPar,IndexX) = X(IndexPar,IndexX);
                    end
                    ObjFunpbest(IndexPar,1) = ObjFun(IndexPar,1);
                end
            end
        end
        % Xgbest determination
        if IndexIter == 1
            ObjFungbest = inf;
        end
        for IndexPar = 1:1:Sett.NumPar
            if(ObjFunpbest(IndexPar,1) < ObjFungbest)
                for IndexX = 1:1:LengthX
                    Xgbest(1,IndexX) = Xpbest(IndexPar,IndexX);
                end
                ObjFungbestold = ObjFungbest;
                ObjFungbest    = ObjFunpbest(IndexPar,1);
            end
        end
        % Xgbest and ObjFungbest output
        fprintf('-- ObjFungbest: %-+1.10e,',ObjFungbest);
        for IndexX = 1:1:LengthX
            if(IndexX < LengthX)
                fprintf(' Xgbest(%i) = %-+1.10d,',IndexX,Xgbest(1,IndexX));
            else
                fprintf(' Xgbest(%i) = %-+1.10d\n',IndexX,Xgbest(1,IndexX));
            end
        end
        % Zero test
        if rem(IndexIter,Sett.NumIterBtwnZeroTests) == 0 && IndexIter ~= 1
            Xpbestguest = Xpbest;
            for IndexX = 1:1:LengthX
                % 1 element of X per time set equal to 0
                for IndexPar = 1:1:Sett.NumPar
                    Xpbestguest(IndexPar,IndexX) = Xzerotest(1,IndexX);
                end
                % ObjFun calculation
                for IndexPar = 1:1:Sett.NumPar
                    ObjFunpbestguest(IndexPar,1) = ObjFun_fun(Xpbestguest(IndexPar,:), Data);
                end
                % Xpbest determination
                for IndexPar = 1:1:Sett.NumPar
                    if(ObjFunpbestguest(IndexPar,1) < ObjFunpbest(IndexPar,1))
                        for IndexX2 = 1:1:LengthX
                            Xpbest(IndexPar,IndexX2) = Xpbestguest(IndexPar,IndexX2);
                        end
                        ObjFunpbest(IndexPar,1) = ObjFunpbestguest(IndexPar,1);
                    end
                end
                % Xgbest determination
                for IndexPar = 1:1:Sett.NumPar
                    if(ObjFunpbestguest(IndexPar,1) < ObjFungbest)
                        for IndexX2 = 1:1:LengthX
                            Xgbest(1,IndexX2) = Xpbestguest(IndexPar,IndexX2);
                        end
                        ObjFungbestold = ObjFungbest;
                        ObjFungbest    = ObjFunpbestguest(IndexPar,1);
                    end
                end
                % Xpbestguest restore to old value
                for IndexPar = 1:1:Sett.NumPar
                    Xpbestguest(IndexPar,IndexX) = Xpbest(IndexPar,IndexX);
                end
            end
        end
        % Termination criteria
        AvObjFun       = mean(ObjFun(:,1));
        VarRelObjFun   = abs((ObjFungbest - ObjFungbestold)/ObjFungbestold);
        RelErrAvObjFun = abs(AvObjFun-ObjFungbest)/ObjFungbest;
        % Plots - Pt.1
        if(Sett.FlagPlots == true)
            ObjFungbestPlots(IndexIter,IndexFam)    = ObjFungbest;
            AvObjFunPlots(IndexIter,IndexFam)       = AvObjFun;
            VarRelObjFunPlots(IndexIter,IndexFam)   = VarRelObjFun;
            RelErrAvObjFunPlots(IndexIter,IndexFam) = RelErrAvObjFun;
        end
    end
    % Xfbest determination
    if IndexFam == 1
        ObjFunfbest = inf;
    end
    if(ObjFungbest < ObjFunfbest)
        Xfbest = Xgbest;
        ObjFunfbest = ObjFungbest;
    end
    % Xfbest and ObjFunfbest output
    fprintf('-  ObjFunfbest: %-+1.10e,',ObjFunfbest); % Added
    for IndexX = 1:1:LengthX % Added
        if(IndexX < LengthX) % Added
            fprintf(' Xfbest(%i) = %-+1.10d,',IndexX,Xfbest(1,IndexX)); % Added
        else % Added
            fprintf(' Xfbest(%i) = %-+1.10d\n',IndexX,Xfbest(1,IndexX)); % Added
        end % Added
    end % Added
end
%% Plots - Pt.2
if(Sett.FlagPlots == true)
    % ObjFungbest
    figure;
    for IndexFam = 1:1:Sett.NumFam
        semilogy(1:1:length(ObjFungbestPlots(:,IndexFam)),ObjFungbestPlots(:,IndexFam),'LineWidth',1.5);
        hold on;
    end
    title('ObjFun_{g,best}');
    xlabel('NumIter');
    ylabel('ObjFun_{g,best}');
    grid on;
    % AvObjFun
    figure;
    for IndexFam = 1:1:Sett.NumFam
        semilogy(1:1:length(AvObjFunPlots(:,IndexFam)),AvObjFunPlots(:,IndexFam),'LineWidth',1.5);
        hold on;
    end
    title('ObjFun_{av}');
    xlabel('NumIter');
    ylabel('ObjFun_{av}');
    grid on;
    % Relative variation (new-old)/old of g-best ObjFun value
    figure;
    for IndexFam = 1:1:Sett.NumFam
        semilogy(1:1:length(VarRelObjFunPlots(:,IndexFam)),VarRelObjFunPlots(:,IndexFam),'LineWidth',1.5);
        hold on;
    end
    title('(ObjFun_{g,best,new} - ObjFun_{g,best,old}) / ObjFun_{g,best,old}');
    xlabel('NumIter');
    ylabel('VarRelObjFun');
    grid on;
    % Average relative error (actual-g-best)/g-best
    figure;
    for IndexFam = 1:1:Sett.NumFam
        semilogy(1:1:length(RelErrAvObjFunPlots(:,IndexFam)),RelErrAvObjFunPlots(:,IndexFam),'LineWidth',1.5);
        hold on;
    end
    title('(ObjFun_{Av} - ObjFun_{g,best}) / ObjFun_{g,best}');
    xlabel('NumIter');
    ylabel('RelErrAvObjFun');
    grid on;
end
end