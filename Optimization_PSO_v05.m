%% Copyright (Federico Giai Pron)
% This file has been created by Federico Giai Pron, energy engineering with a 2nd level master in energy management for automotive powertrains done after the graduation. For any question, write to federico.giaipron@gmail.com
%% Particle Swarm Optimization (PSO)
function [Xfbest,ObjFunfbest] = Optimization_PSO_v04(XGuess,XLim,VLim,win,wend,c1,c2,Data,Sett)
% Parameters
LengthX      = Sett.LengthX;      % Import the number of variables from the Sett object
LengthObjFun = Sett.LengthObjFun; % Import the number of objective functions from the Sett object
NumPar       = Sett.NumPar;       % Import the number of particles from the Sett object
% Initialization
X                   = zeros(NumPar,LengthX);
Xpbest              = zeros(NumPar,LengthX);
Xgbest              = zeros(1,LengthX);
Xfbest              = zeros(1,LengthX);
Xzerotest           = zeros(1,LengthX);
V                   = zeros(NumPar,LengthX);
ObjFun              = zeros(NumPar,LengthObjFun);
ObjFunpbest         = zeros(NumPar,LengthObjFun);
ObjFunpbestguest    = zeros(NumPar,LengthObjFun);
ObjFungbest         = zeros(1,LengthObjFun);
ObjFungbestold      = zeros(1,LengthObjFun);
ObjFunfbest         = zeros(1,LengthObjFun);
ObjFunpRelDis       = zeros(NumPar,LengthObjFun);
ObjFunpRelDisguest  = zeros(NumPar,LengthObjFun);
ObjFungRelDis       = zeros(NumPar,LengthObjFun);
ObjFungRelDisguest  = zeros(NumPar,LengthObjFun);
ObjFunfRelDis       = zeros(1,LengthObjFun);
AvObjFun            = zeros(1,LengthObjFun);
ObjFungbestPlots    = zeros(Sett.NumIterMax,Sett.NumFam,LengthObjFun);
AvObjFunPlots       = zeros(Sett.NumIterMax,Sett.NumFam,LengthObjFun);
VarRelObjFunPlots   = zeros(Sett.NumIterMax,Sett.NumFam,LengthObjFun);
RelErrAvObjFunPlots = zeros(Sett.NumIterMax,Sett.NumFam,LengthObjFun);
% Iterate for each family
for IndexFam = 1:1:Sett.NumFam
    % Output the current family number
    fprintf('- IndexFam:    %3i out of %3i\n',IndexFam,Sett.NumFam);
    % Initialization
    IndexIter    = 0;    % Initialize the number of iterations for the current family
    FlagContinue = true; % Initialize the FlagContinue flag to true
    % Iterate until the FlagContinue is equal to true
    while(FlagContinue == true)
        % Update the current iteration number
        IndexIter = IndexIter + 1;
        % Output the current iteration number
        fprintf('-- IndexIter:  %3i out of %3i\n',IndexIter,Sett.NumIterMax);
        % Iterate for each particle
        for IndexPar = 1:1:NumPar
            % Initialize X and V
            if IndexIter == 1 || rem(IndexIter,Sett.NumIterBtwnRestarts) == 0
                if(Sett.FlagXGuess == true)
                    for IndexX = 1:1:LengthX
                        X(IndexPar,IndexX) = XGuess(IndexX);
                        V(IndexPar,IndexX) = VLim(1,IndexX) + (VLim(2,IndexX) - VLim(1,IndexX))*rand(1);
                    end
                else
                    for IndexX = 1:1:LengthX
                        X(IndexPar,IndexX) = XLim(1,IndexX) + (XLim(2,IndexX) - XLim(1,IndexX))*rand(1);
                        V(IndexPar,IndexX) = VLim(1,IndexX) + (VLim(2,IndexX) - VLim(1,IndexX))*rand(1);
                    end
                end
            % Update X and V
            else
                r1 = rand(1);
                r2 = rand(1);
                for IndexX = 1:1:LengthX
                    w = win - (win - wend) * IndexIter / Sett.NumIterMax;
                    V(IndexPar,IndexX) = min(max(w*V(IndexPar,IndexX) + c1*r1*(Xpbest(IndexPar,IndexX)-X(IndexPar,IndexX)) + c2*r2*(Xgbest(IndexX)-X(IndexPar,IndexX)),VLim(1,IndexX)),VLim(2,IndexX));
                    X(IndexPar,IndexX) = min(max(X(IndexPar,IndexX) + V(IndexPar,IndexX)                                                                              ,XLim(1,IndexX)),XLim(2,IndexX));
                end
            end
        end
        % Plot in real-time
        % if(Sett.FlagPlots == true)
        %     if(IndexIter == 1)
        %         h1 = [];
        %         h2 = [];
        %         h3 = [];
        %     end
        %     [h1,h2,h3] = Plot(XLim,X,h1,h2,h3);
        % end
        % Calculate the objective functions
        for IndexPar = 1:1:NumPar
            fprintf('--- IndexPar:  %3i out of %3i\n',IndexPar,NumPar);
            ObjFun(IndexPar,:) = ObjFun_fun(X(IndexPar,:),Data);
            for IndexObjFun = 1:1:LengthObjFun
                if(Sett.ObjFunType(IndexObjFun) == "max")
                    ObjFun(IndexPar,IndexObjFun) = -ObjFun(IndexPar,IndexObjFun);
                end
            end
        end
        % Determine Xpbest
        for IndexPar = 1:1:NumPar
            if IndexIter == 1
                for IndexX = 1:1:LengthX
                    Xpbest(IndexPar,IndexX) = X(IndexPar,IndexX);
                end
                for IndexObjFun = 1:1:LengthObjFun
                    ObjFunpbest(IndexPar,IndexObjFun) = ObjFun(IndexPar,IndexObjFun);
                end
            else
                for IndexObjFun = 1:1:LengthObjFun
                    ObjFunpRelDis(IndexPar,IndexObjFun) = Sett.ObjFunPrio(IndexObjFun)*(ObjFun(IndexPar,IndexObjFun)-ObjFunpbest(IndexPar,IndexObjFun))/abs(ObjFunpbest(IndexPar,IndexObjFun));
                end
                if(sum(ObjFunpRelDis(IndexPar,:)) <= 0 || isnan(sum(ObjFunpRelDis(IndexPar,:))) == true)
                    for IndexX = 1:1:LengthX
                        Xpbest(IndexPar,IndexX) = X(IndexPar,IndexX);
                    end
                    for IndexObjFun = 1:1:LengthObjFun
                        ObjFunpbest(IndexPar,IndexObjFun) = ObjFun(IndexPar,IndexObjFun);
                    end
                end
            end
        end
        % Xgbest determination
        if IndexIter == 1
            for IndexX = 1:1:LengthX
                Xgbest(IndexX) = Xpbest(1,IndexX);
            end
            for IndexObjFun = 1:1:LengthObjFun
                ObjFungbest(IndexObjFun) = ObjFunpbest(1,IndexObjFun);
            end
        end
        for IndexPar = 1:1:NumPar
            for IndexObjFun = 1:1:LengthObjFun
                ObjFungRelDis(IndexPar,IndexObjFun) = Sett.ObjFunPrio(IndexObjFun)*(ObjFunpbest(IndexPar,IndexObjFun)-ObjFungbest(IndexObjFun))/abs(ObjFungbest(IndexObjFun));               
            end
            if(sum(ObjFungRelDis(IndexPar,:)) <= 0 || isnan(sum(ObjFungRelDis(IndexPar,:))) == true)
                for IndexX = 1:1:LengthX
                    Xgbest(IndexX) = Xpbest(IndexPar,IndexX);
                end
                for IndexObjFun = 1:1:LengthObjFun
                    ObjFungbestold(IndexObjFun) = ObjFungbest(IndexObjFun);
                    ObjFungbest(IndexObjFun)    = ObjFunpbest(IndexPar,IndexObjFun);
                end
            end
        end
        % Output Xgbest and ObjFungbest
        fprintf('--');
        for IndexObjFun = 1:1:LengthObjFun
            if(ObjFungbest(IndexObjFun) == 0)
                if(Sett.ObjFunType(IndexObjFun) == "min")
                    fprintf(' ObjFungbest(%i): %-+1.16e,',IndexObjFun,+ObjFungbest(IndexObjFun));
                elseif(Sett.ObjFunType(IndexObjFun) == "max")
                    fprintf(' ObjFungbest(%i): %-+1.16e,',IndexObjFun,-ObjFungbest(IndexObjFun));
                end
            else
                if(Sett.ObjFunType(IndexObjFun) == "min")
                    fprintf(' ObjFungbest(%i): %-+1.10e,',IndexObjFun,+ObjFungbest(IndexObjFun));
                elseif(Sett.ObjFunType(IndexObjFun) == "max")
                    fprintf(' ObjFungbest(%i): %-+1.10e,',IndexObjFun,-ObjFungbest(IndexObjFun));
                end
            end
        end
        for IndexX = 1:1:LengthX
            if(IndexX < LengthX)
                if(Xgbest(IndexX) == 0)
                    fprintf(' Xgbest(%i) = %-+1.16d,',IndexX,Xgbest(IndexX));
                else
                    fprintf(' Xgbest(%i) = %-+1.10d,',IndexX,Xgbest(IndexX));
                end
            else
                if(Xgbest(IndexX) == 0)
                    fprintf(' Xgbest(%i) = %-+1.16d\n',IndexX,Xgbest(IndexX));
                else
                    fprintf(' Xgbest(%i) = %-+1.10d\n',IndexX,Xgbest(IndexX));
                end
            end
        end
        % Perform the zero-test
        if rem(IndexIter,Sett.NumIterBtwnZeroTests) == 0 && IndexIter ~= 1
            Xpbestguest = Xpbest;
            for IndexX = 1:1:LengthX
                % 1 element of X per time set equal to 0
                for IndexPar = 1:1:NumPar
                    Xpbestguest(IndexPar,IndexX) = Xzerotest(IndexX);
                end
                % ObjFun calculation
                for IndexPar = 1:1:NumPar
                    ObjFunpbestguest(IndexPar,:) = ObjFun_fun(Xpbestguest(IndexPar,:),Data);
                    for IndexObjFun = 1:1:LengthObjFun
                        if(Sett.ObjFunType(IndexObjFun) == "max")
                            ObjFunpbestguest(IndexPar,IndexObjFun) = -ObjFunpbestguest(IndexPar,IndexObjFun);
                        end
                    end
                end
                % Xpbest determination
                for IndexPar = 1:1:NumPar
                    for IndexObjFun = 1:1:LengthObjFun
                        ObjFunpRelDisguest(IndexPar,IndexObjFun) = Sett.ObjFunPrio(IndexObjFun)*(ObjFunpbestguest(IndexPar,IndexObjFun)-ObjFunpbest(IndexPar,IndexObjFun))/abs(ObjFunpbest(IndexPar,IndexObjFun));
                    end
                    if(sum(ObjFunpRelDisguest(IndexPar,:)) <= 0 || isnan(sum(ObjFunpRelDisguest(IndexPar,:))) == true)
                        for IndexX2 = 1:1:LengthX
                            Xpbest(IndexPar,IndexX2) = Xpbestguest(IndexPar,IndexX2);
                        end
                        for IndexObjFun = 1:1:LengthObjFun
                            ObjFunpbest(IndexPar,IndexObjFun) = ObjFunpbestguest(IndexPar,IndexObjFun);
                        end
                    end
                end
                % Xgbest determination
                for IndexPar = 1:1:NumPar
                    for IndexObjFun = 1:1:LengthObjFun
                        ObjFungRelDisguest(IndexPar,IndexObjFun) = Sett.ObjFunPrio(IndexObjFun)*(ObjFunpbestguest(IndexPar,IndexObjFun)-ObjFungbest(IndexObjFun))/abs(ObjFungbest(IndexObjFun));
                    end
                    if(sum(ObjFungRelDisguest(IndexPar,:)) <= 0 || isnan(sum(ObjFungRelDisguest(IndexPar,:))) == true)
                       for IndexX2 = 1:1:LengthX
                            Xgbest(IndexX2) = Xpbestguest(IndexPar,IndexX2);
                       end
                       for IndexObjFun = 1:1:LengthObjFun
                           ObjFungbestold(IndexObjFun) = ObjFungbest(IndexObjFun);
                           ObjFungbest(IndexObjFun)    = ObjFunpbestguest(IndexPar,IndexObjFun);
                       end
                    end
                end
                % Xpbestguest restore to old value
                for IndexPar = 1:1:NumPar
                    Xpbestguest(IndexPar,IndexX) = Xpbest(IndexPar,IndexX);
                end
            end
        end
        % Determine FlagContinue flag
        for IndexObjFun = 1:1:LengthObjFun
            AvObjFun(IndexObjFun)       = mean(ObjFun(:,IndexObjFun));
            VarRelObjFun(IndexObjFun)   = abs((ObjFungbest(IndexObjFun) - ObjFungbestold(IndexObjFun))/ObjFungbestold(IndexObjFun));
            RelErrAvObjFun(IndexObjFun) = abs(AvObjFun(IndexObjFun)-ObjFungbest(IndexObjFun))/ObjFungbest(IndexObjFun); 
        end
        FlagContinue = true;
        for IndexObjFun = 1:1:LengthObjFun
            if((VarRelObjFun(IndexObjFun) < Sett.VarRelObjFunTrgt(IndexObjFun) && RelErrAvObjFun(IndexObjFun) < Sett.RelErrAvObjFunTrgt(IndexObjFun)) || IndexIter >= Sett.NumIterMax)
                FlagContinue = false;
            end
        end
        % Plots - Pt.1
        if(Sett.FlagPlots == true)
            for IndexObjFun = 1:1:LengthObjFun
                if(Sett.ObjFunType(IndexObjFun) == "min")
                    ObjFungbestPlots(IndexIter,IndexFam,IndexObjFun) = +ObjFungbest(IndexObjFun);
                elseif(Sett.ObjFunType(IndexObjFun) == "max")
                    ObjFungbestPlots(IndexIter,IndexFam,IndexObjFun) = -ObjFungbest(IndexObjFun);
                end
            end
            AvObjFunPlots(IndexIter,IndexFam,:)       = AvObjFun;
            VarRelObjFunPlots(IndexIter,IndexFam,:)   = VarRelObjFun;
            RelErrAvObjFunPlots(IndexIter,IndexFam,:) = RelErrAvObjFun;
        end
    end
    % Determine Xfbest
    if IndexFam == 1
        Xfbest = Xgbest;
        ObjFunfbest = ObjFungbest;
    end
    for IndexObjFun = 1:1:LengthObjFun
        ObjFunfRelDis(IndexObjFun) = Sett.ObjFunPrio(IndexObjFun)*(ObjFungbest(IndexObjFun)-ObjFunfbest(IndexObjFun))/abs(ObjFunfbest(IndexObjFun));
    end
    if(sum(ObjFunfRelDis) <= 0 || isnan(sum(ObjFunfRelDis)) == true)
        Xfbest = Xgbest;
        ObjFunfbest = ObjFungbest;
    end
    % Output Xfbest and ObjFunfbest
    fprintf('- ');
    for IndexObjFun = 1:1:LengthObjFun
        if(ObjFunfbest(IndexObjFun) == 0)
            if(Sett.ObjFunType(IndexObjFun) == "min")
                fprintf(' ObjFunfbest(%i): %-+1.16e,',IndexObjFun,+ObjFunfbest(IndexObjFun));
            elseif(Sett.ObjFunType(IndexObjFun) == "max")
                fprintf(' ObjFunfbest(%i): %-+1.16e,',IndexObjFun,-ObjFunfbest(IndexObjFun));
            end
        else
            if(Sett.ObjFunType(IndexObjFun) == "min")
                fprintf(' ObjFunfbest(%i): %-+1.10e,',IndexObjFun,+ObjFunfbest(IndexObjFun));
            elseif(Sett.ObjFunType(IndexObjFun) == "max")
                fprintf(' ObjFunfbest(%i): %-+1.10e,',IndexObjFun,-ObjFunfbest(IndexObjFun));
            end
        end
    end
    for IndexX = 1:1:LengthX
        if(IndexX < LengthX)
            if(Xfbest(IndexX) == 0)
                fprintf(' Xfbest(%i) = %-+1.16d,',IndexX,Xfbest(IndexX));
            else
                fprintf(' Xfbest(%i) = %-+1.10d,',IndexX,Xfbest(IndexX));
            end
        else
            if(Xfbest(1,IndexX) == 0)
                fprintf(' Xfbest(%i) = %-+1.16d\n',IndexX,Xfbest(IndexX));
            else
                fprintf(' Xfbest(%i) = %-+1.10d\n',IndexX,Xfbest(IndexX));
            end
        end
    end
end
% Adjust sign at the end of optimization
for IndexObjFun = 1:1:LengthObjFun
    if(Sett.ObjFunType(IndexObjFun) == "max")
        ObjFunfbest(IndexObjFun) = -ObjFunfbest(IndexObjFun);
    end
end
% Plots - Pt.2
if(Sett.FlagPlots == true)
    for IndexObjFun = 1:1:LengthObjFun
        % ObjFungbest
        figure;
        for IndexFam = 1:1:Sett.NumFam
            semilogy(1:1:length(ObjFungbestPlots(:,IndexFam,IndexObjFun)),ObjFungbestPlots(:,IndexFam,IndexObjFun),'LineWidth',2);
            hold on;
        end
        title('ObjFun_{g,best}');
        xlabel('NumIter');
        ylabel('ObjFun_{g,best}');
        grid on;
    end
end
end