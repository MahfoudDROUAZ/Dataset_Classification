% ---------------------------------------------------------------------------------------------
% Coded by  : Mahfoud Drouaz
% University of Haute-Alsace
% Trace les boxplots une moyenne de 100 classification pour chacun des discripteurs utilisés
%
% Data Input :
% Colonne 1 : PA -> Puissance active moyen : régime étalbi
% Colonne 2 : PM -> Puissance max du transitoire
% Colonne 3 : Beta_50                                           | Colonne 8  : Max_Voice_50
% Colonne 4 : Beta_150                                          | Colonne 9  : Max_Voice_150
% Colonne 5 : Beta_250                                          | Colonne 10 : Max_Voice_250
% Colonne 6 : Beta_350                                          | Colonne 11 : Max_Voice_350
% Colonne 7 : Beta_450                                          | Colonne 12 : Max_Voice_450
%
% ---------------------------------------------------------------------------------------------
% Ouput :
% PA        : Case A : % Puissance Active moyenne
% PM        : Case B : % Puissance max du transitoire

% B         : Case C : % Beta 50
% BB        : Case D : % Beta 50, Beta 150
% BBB       : Case E : % Beta 50, Beta 150, Beta 250

% PMB       : Case F : % Puissance max du transitoire, Beta 50
% PMBB      : Case G : % Puissance max du transitoire, Beta 50, Beta 150
% PMBBB     : Case H : % Puissance max du transitoire, Beta 50, Beta 150, Beta 250

% PMV       : Case I : % Puissance max du transitoire, Max Voice 50
% PMVV      : Case J : % Puissance max du transitoire, Max Voice 50, Max Voice 150
% PMVVV     : Case K : % Puissance max du transitoire, Max Voice 50, Max Voice 150, Max Voice 250

% PAB       : Case L : % Puissance Active moyenne, Beta 50
% PABB      : Case M : % Puissance Active moyenne, Beta 50, Beta 150
% PABBB     : Case N : % Puissance Active moyenne, Beta 50, Beta 150, Beta 250
% ---------------------------------------------------------------------------------------------
% Updated : 03-08-2020
% Version : 0.04
% ---------------------------------------------------------------------------------------------
clc, clear all, close all

addpath('F:\Bases de données existantes\COOLL_16-11-2017\programmes_traitements');

uiopen('*.mat')
Load = importLoadName('appliances_and_action_delays.txt', 1, 840);
% Create the input vector samples of descriptors
groups = char(Load);
% samples_ST = [discripteurs_STS.discripteurs_STS(:,1), discripteurs_STS.discripteurs_STS(:,2), discripteurs_STS.discripteurs_STS(:,3), ...
%     discripteurs_STS.discripteurs_STS(:,4)];

k=3;
%[idx, C] = kmeans(samples_ST, 12)
%[cm, order] = ClassifyAppliances(samples_ST,groups)
cvlosss = 0;    PA = [];  PM = [];   
                B = [];   BB = [];   BBB = [];
                PMV = []; PMVV = []; PMVVV = [];
                PMB = []; PMBB = []; PMBBB = [];  
                PAB = []; PABB = []; PABBB = [];          
          
%ctree = fitctree(samples_ST,groups)
It = 100;
% Case A : P_act_moy
samples_STS = [discripteurs_STS(:,2)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PA = [PA cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,1)= [cm];

% Case B : P_max_trans
samples_STS = [discripteurs_STS(:,2)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PM = [PM cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,2)= [cm]

% Case C : Beta_50
samples_STS = [discripteurs_STS(:,3)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
B = [B cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,3)= [cm];

% Case D : Beta_50, Beta_150
samples_STS = [discripteurs_STS(:,3), discripteurs_STS(:,4)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
BB = [BB cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,4)= [cm];

% Case E : Beta_50, Beta_150, Beta_250
samples_STS = [discripteurs_STS(:,3), discripteurs_STS(:,4), discripteurs_STS(:,5)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
BBB = [BBB cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,5)= [cm];

% Case F : P_max_trans, Beta_50
samples_STS = [discripteurs_STS(:,2), discripteurs_STS(:,3)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PMB = [PMB cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,6)= [cm];

% Case G : P_max_trans, Beta_50, Beta_150
samples_STS = [discripteurs_STS(:,2), discripteurs_STS(:,3), discripteurs_STS(:,4)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PMBB = [PMBB cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,7)= [cm];

% Case H : P_max_trans, Beta_50, Beta_150, Beta_250
samples_STS = [discripteurs_STS(:,2), discripteurs_STS(:,3), discripteurs_STS(:,4), discripteurs_STS(:,5)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PMBBB = [PMBBB cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,8)= [cm];

% Case I : P_max_trans, Max_Voice_50
samples_STS = [discripteurs_STS(:,2), discripteurs_STS(:,8)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PMV = [PMV cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,9)= [cm];

% Case J : P_max_trans, Max_Voice_50, Max_Voice_150
samples_STS = [discripteurs_STS(:,2), discripteurs_STS(:,8), discripteurs_STS(:,9)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PMVV = [PMVV cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,10) = [cm];

% Case K : P_max_trans, Max_Voice_50, Max_Voice_150, Max_Voice_250
samples_STS = [discripteurs_STS(:,2), discripteurs_STS(:,8), discripteurs_STS(:,9), discripteurs_STS(:,10)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PMVVV = [PMVVV cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,11) = [cm];

% Case L : P_act_moy, Beta_50
samples_STS = [discripteurs_STS(:,1), discripteurs_STS(:,3)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PAB = [PAB cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,12) = [cm];

% Case M : P_act_moy, Beta_50, Beta_150
samples_STS = [discripteurs_STS(:,1), discripteurs_STS(:,3), discripteurs_STS(:,4)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PABB = [PABB cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,13) = [cm];

% Case N : P_act_moy, Beta_50, Beta_150, Beta_250
samples_STS = [discripteurs_STS(:,1), discripteurs_STS(:,3), discripteurs_STS(:,4), discripteurs_STS(:,5)];
for i=1:It
%ctree = fitcknn(samples_ST,groups,'NumNeighbors',k,'Distance','euclidean');
ctree = fitctree(samples_STS,groups)
cvrtree = crossval(ctree);
cvloss = kfoldLoss(cvrtree);
PABBB = [PABBB cvloss];
y_hat = predict(ctree,samples_STS);
[cm, order] = confusionmat(groups,y_hat);
N = sum(cm(:));
err = (N-sum(diag(cm)));
tree = linkage(samples_STS,'average');
end
CM(:,:,14) = [cm];

Class_rate = [(100*(1-PM))', (100*(1-PA))',...
              (100*(1-B))', (100*(1-BB))', (100*(1-BBB))',... 
              (100*(1-PMB))', (100*(1-PMBB))', (100*(1-PMBB))',...
              (100*(1-PMV))', (100*(1-PMVV))', (100*(1-PMVVV))',...
              (100*(1-PAB))', (100*(1-PABB))', (100*(1-PABBB))'];

FontSize = 24;
% box = [(100*(1-P))', (100*(1-B))', (100*(1-BB))', (100*(1-BBB))',(100*(1-PB))', (100*(1-PBB))', (100*(1-PBBB))', (100*(1-PMB))', (100*(1-PMBB))', (100*(1-PMBBB))'];
box = [Class_rate]
figure (2)
hold on
set(2,'PaperUnits','centimeter')
set(2,'Units','centimeter')
set(2,'PaperPosition',[0 0 40 20]); % taille transférée
set(2,'Position',[0 0 40 20]);  % taille écran
p1 = boxplot(box,'labels',{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'})
set(p1,'linewidth',2);
grid on  
xlab=xlabel('Descripteurs');
ylab=ylabel('Taux de classification %');
set(gca,'fontsize',FontSize);
set(xlab,'fontsize',FontSize,'Rotation',0,'Interpreter','latex');
set(ylab,'fontsize',FontSize,'Rotation',90,'Interpreter','latex');
hold off
