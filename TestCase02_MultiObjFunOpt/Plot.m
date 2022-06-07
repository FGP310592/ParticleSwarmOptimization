%% Copyright (Federico Giai Pron)
% This file has been created by Federico Giai Pron, energy engineering with a 2nd level master in energy management for automotive powertrains done after the graduation. For any question, write to federico.giaipron@gmail.com
%% Plot the objective functions and particles
function [h1,h2,h3] = Plot(XLim,X,h1,h2,h3)
%% Calculate the objective functions
% Sizes
LengthA = 10;
LengthB = 10;
LengthC = 15;
% Generate the optimization variables
A = linspace(XLim(1,1),XLim(2,1),LengthA);
B = linspace(XLim(1,2),XLim(2,2),LengthB);
C = linspace(XLim(1,3),XLim(2,3),LengthC);
[Agrid,Bgrid,Cgrid] = meshgrid(A,B,C);
% Calculate the objective functions
Coords = zeros(LengthA*LengthB*LengthC,3);
Ec     = zeros(LengthA*LengthB*LengthC,1);
Ra     = zeros(LengthA*LengthB*LengthC,1);
MRR    = zeros(LengthA*LengthB*LengthC,1);
k = 0;
for a = 1:1:LengthA
    for b = 1:1:LengthB
        for c = 1:1:LengthC
            k = k + 1;
            Coords(k,:) = [Agrid(a,b,c),Bgrid(a,b,c),Cgrid(a,b,c)];
            [ObjFun] = ObjFun_fun([Agrid(a,b,c),Bgrid(a,b,c),Cgrid(a,b,c)]);
            Ec(k,1)  = ObjFun(1,1);
            Ra(k,1)  = ObjFun(1,2);
            MRR(k,1) = ObjFun(1,3);
        end
    end
end
%% Plot the objective functions
figure(1);
set(gcf,'position',[0,0,1000,500]);
% Ec
subplot(1,3,1);
scatter3(Coords(:,1),Coords(:,2),Coords(:,3),[],Ec,'filled');
view([0.5,0.5,0.05]);
xlim([XLim(1,1),XLim(2,1)]);
ylim([XLim(1,2),XLim(2,2)]);
zlim([XLim(1,3),XLim(2,3)]);
title('E_{c}');
xlabel('A');
ylabel('B');
zlabel('C');
grid on;
colorbar;
% Ra
subplot(1,3,2);
scatter3(Coords(:,1),Coords(:,2),Coords(:,3),[],Ra,'filled');
view([0.5,0.5,0.05]);
xlim([XLim(1,1),XLim(2,1)]);
ylim([XLim(1,2),XLim(2,2)]);
zlim([XLim(1,3),XLim(2,3)]);
title('R_{a}');
xlabel('A');
ylabel('B');
zlabel('C');
grid on;
colorbar;
% MRR
subplot(1,3,3);
scatter3(Coords(:,1),Coords(:,2),Coords(:,3),[],MRR,'filled');
view([0.5,0.5,0.05]);
xlim([XLim(1,1),XLim(2,1)]);
ylim([XLim(1,2),XLim(2,2)]);
zlim([XLim(1,3),XLim(2,3)]);
title('MRR');
xlabel('A');
ylabel('B');
zlabel('C');
grid on;
colorbar;
%% Plot the particles
% Ec
subplot(1,3,1);
hold on;
delete(h1);
h1 = scatter3(X(:,1),X(:,2),X(:,3),'k');
% Ra
subplot(1,3,2);
hold on;
delete(h2);
h2 = scatter3(X(:,1),X(:,2),X(:,3),'k');
% MRR
subplot(1,3,3);
hold on;
delete(h3);
h3 = scatter3(X(:,1),X(:,2),X(:,3),'k');
end

