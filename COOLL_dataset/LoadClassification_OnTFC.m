% -----------------------------------------------------------------------
% Coded by : Mahfoud Drouaz
% University of Haute-Alsace
% Ce script :
%       - trace les boxplots 'une moyenne de 100 classification pour
%       chacun des discripteurs utilisés : puissance, puissance + beta_50
%       puissance + beta_50 & 150, puissance + beta_50 & 150 & 250.
% -----------------------------------------------------------------------
clc, clear all, close all

addpath('F:\Bases de données existantes\COOLL_16-11-2017\programmes_traitements');
addpath('G:\thèse_Hakim\Chapitre6\Programmes_traitements');

discripteurs_OnTFC = load('discripteurs_OnTFC_COOLL_10-07-2018');
Load = importLoadName('appliances_and_action_delays.txt', 1, 840);
% Create the input vector samples of descriptors
groups = char(Load);
% samples_ST = [discripteurs_ST.discripteurs_ST(:,1), discripteurs_ST.discripteurs_ST(:,2), discripteurs_ST.discripteurs_ST(:,3), ...
%     discripteurs_ST.discripteurs_ST(:,4)];

k=10;
%[idx, C] = kmeans(samples_ST, 12)
%[cm, order] = ClassifyAppliances(samples_ST,groups)
cvlosss = 0; P = []; PB = []; PBB = []; PBBB = [];
%ctree = fitctree(samples_ST,groups)
% test avec P
% samples_ST = [discripteurs_ST.discripteurs_ST(:,1)];
% for i=1:100
% ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
% cvrtree = crossval(ctree);
% cvloss = kfoldLoss(cvrtree);
% P = [P cvloss];
% y_hat = predict(ctree,samples_ST);
% [cm, order] = confusionmat(groups,y_hat);
% N = sum(cm(:));
% err = (N-sum(diag(cm)));
% tree = linkage(samples_ST,'average');
% end

% test avec P et B50
samples_OnTFC = [discripteurs_OnTFC.discripteurs_OnTFC(:,1), discripteurs_OnTFC.discripteurs_OnTFC(:,2)];
for i=1:100
ctree = fitcknn(samples_OnTFC,groups,'NumNeighbors',k,'Distance','euclidean');
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PB = [PB cvloss];
y_hat = predict(ctree,samples_OnTFC);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_OnTFC,'average');
end

% test avec P et B50 B150
samples_OnTFC = [discripteurs_OnTFC.discripteurs_OnTFC(:,1), discripteurs_OnTFC.discripteurs_OnTFC(:,2), discripteurs_OnTFC.discripteurs_OnTFC(:,3)];
for i=1:100
ctree = fitcknn(samples_OnTFC,groups,'NumNeighbors',k,'Distance','euclidean');
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PBB = [PBB cvloss];
y_hat = predict(ctree,samples_OnTFC);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_OnTFC,'average');
end

% test avec P et B50 B150 B250
samples_OnTFC = [discripteurs_OnTFC.discripteurs_OnTFC(:,1), discripteurs_OnTFC.discripteurs_OnTFC(:,2), discripteurs_OnTFC.discripteurs_OnTFC(:,3), discripteurs_OnTFC.discripteurs_OnTFC(:,4)];
for i=1:100
ctree = fitcknn(samples_OnTFC,groups,'NumNeighbors',k,'Distance','euclidean');
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PBBB = [PBBB cvloss];
y_hat = predict(ctree,samples_OnTFC);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_OnTFC,'average');
end


FontSize = 24;
box = [(100*(1-PB))', (100*(1-PBB))', (100*(1-PBBB))'];
figure (1)
hold on
set(1,'PaperUnits','centimeter')
set(1,'Units','centimeter')
set(1,'PaperPosition',[0 0 40 20]); % taille transférée
set(1,'Position',[0 0 40 20]);  % taille écran
p1 = boxplot(box,'labels',{'A', 'B', 'C'})
set(p1,'linewidth',2);
grid on  
xlab=xlabel('Descripteurs');
ylab=ylabel('Taux de classification %');
set(gca,'fontsize',FontSize);
set(xlab,'fontsize',FontSize,'Rotation',0,'Interpreter','latex');
set(ylab,'fontsize',FontSize,'Rotation',90,'Interpreter','latex');
hold off