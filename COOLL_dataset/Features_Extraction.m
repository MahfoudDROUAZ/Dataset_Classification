% ------------------------------------------------------------------------------------------------------
% Coded by : Mahfoud DROUAZ
% Ce script réalise :
%       - sous échantillonnage des données de la base COOLL
%       - affichage des courbes courant et tension
%       - calcul de la puissance active
%       - détermine l'instant de mise en marche des charges électriques
%       - affiche la courbe de la puissance active
%       - calcul les betas à base des voices sur les harmoniques de courants jusqu'à la 16ème
%       harmoniques en utilisant la ST et la STFT
%       - Calcul le taux de distortion harmonique en se basant se les
%       voices de la ST et la STFT
%       - Crée un vecteur de discipteurs [Pactive B50 B150 B250] pour la ST
%       et la STFT.
%       - Calcul voices Sejdic ST
% ------------------------------------------------------------------------------------------------------
% Last update : 25-10-2020
% ------------------------------------------------------------------------------------------------------
clc, clear all, close all
% ------------------------------------------------------------------------------------------------------
% Load data
addpath('F:\dataset\COOLL\COOLL Data\Current_1to210');
addpath('F:\dataset\COOLL\COOLL Data\Current_211to420');
addpath('F:\dataset\COOLL\COOLL Data\Current_421to630');
addpath('F:\dataset\COOLL\COOLL Data\Current_631to840');
addpath('F:\dataset\COOLL\COOLL Data\Voltage_1to210');
addpath('F:\dataset\COOLL\COOLL Data\Voltage_211to420');
addpath('F:\dataset\COOLL\COOLL Data\Voltage_421to630');
addpath('F:\dataset\COOLL\COOLL Data\Voltage_631to840');
addpath('..\Common');

%%
dataSetSize = 840;
%Beta_ST = zeros(dataSetSize,5);
%Beta_STFT = zeros(dataSetSize,5);
%Beta_OnTFC = zeros(dataSetSize,5);
discripteurs_ST = zeros(dataSetSize,12);
discripteurs_STS = zeros(dataSetSize,12);
%discripteurs_OnTFC = zeros(dataSetSize,6);
%discripteurs_STFT = zeros(dataSetSize,6);
Fe = 100*10^3;                      % sampling frequency
FontSize = 16;                      % figure text font size
Factor = 1;                         % Gaussian parameter for ST
Sigma = 0.05;                       % Gaussian parameter for STFT
F_max = 5;                          % nombre de voies fréquentielles calculées
f = [50, 150, 250, 350, 450, 550];  % voie fréquentielles calculées
lambda = 0.01;                      % pas du gradient
beta = 0.001;                       % facteur d'oubli
T = 0.02;                           % time of one period 20 ms
decimateFactor = 10;
%Fe = Fe/decimateFactor
Te = 1/Fe;


for N=1:1:dataSetSize
scals = load('scaleFactors.txt');
fileToReadC1 = ['scenarioC1_',num2str(N),'.flac'];
fileToReadV1 = ['scenarioV1_',num2str(N),'.flac'];
importfile_COOLL(fileToReadC1)
current = scals(N,1).*data'; clear data;
importfile_COOLL(fileToReadV1)
voltage = scals(N,2).*data'; clear data; clear fileToReadC1; clear fileToReadV1;
           
Length = length(current);   %length of the current vector
Time = 0:Te:(Length-1)*Te;  %time vector

[P_inst, P_act, P_max_trans] = Get_Power(current, voltage, Te, T, Length);
[time_ON, time_OFF, tau1, tau2, index_OFF, P_act_moyenne] = Get_Time_ON_OFF(P_act, Time, T, Te, Length);

% figure(3),
% hold on
% set(3,'PaperUnits','centimeter')
% set(3,'Units','centimeter')
% set(3,'PaperPosition',[0 0 40 20]); % taille transférée
% set(3,'Position',[0 0 40 20]);  % taille écran
% p2=plot(Time, P_inst);
% p3=plot(Time(index_ON:index_off_transient),current(index_ON:index_off_transient));
% %plot(Time, P_inst)
% set(p3,'linewidth',2,'LineStyle', '-','color','b');
% set(p2,'linewidth',2,'LineStyle', '-','color','r');
% xlab=xlabel('Temps (s)');
% ylab=ylabel('I (A)');
% grid on, box on, 
% set(gca,'fontsize',FontSize);
% set(xlab,'fontsize',FontSize,'Rotation',0);
% set(ylab,'fontsize',FontSize,'Rotation',90);
% hold off

% Calcul des voies fréquentielles des harmoniques en vue d'extraire la
% indices = round(f*Length/Fe)
indices = [301, 901, 1501, 2101, 2701, 3301];
% Get the Stokwell voices for each harmonics and the beta
[ST_voices, Betas_ST, Max_ST_voices] = Get_ST_Voices_Betas(current, Factor, indices, Length, tau1,tau2);
% [ST_voices, Betas_ST, Max_ST_voices] = Get_ST_TemWin_Voices_Betas(current, indices, Length, tau1,tau2);

% Get the Stokwell voices with Sejdic parameter for each harmonics and the beta
p = [1, 0.9, 0.8, 0.8, 0.8, 0.8];
[STS_voices, Betas_STS, Max_STS_voices] = Get_ST_Sejdic_Voices_Betas(current, p, indices, Length, tau1,tau2);
% Get the STFT voices for each harmonic and the beta
% [STFT_voices, Betas_STFT] = Get_STFT_Voices_Betas(Time_Series, Sigma, indices, Length, index_ON, Te, Fe);

% Get the OnTFC voices for each harmonic and the beta
% [Betas_OnTFC] = Get_OnTFC_Voices_Betas(current, Time, f, F_max, lambda, beta, index_ON);

% figure(N+1)
% hold on
% set(N+1,'PaperUnits','centimeter')
% set(N+1,'Units','centimeter')
% set(N+1,'PaperPosition',[0 0 40 20]); % taille transférée
% set(N+1,'Position',[0 0 40 20]);  % taille écran
% p1=plot(Time, abs(ST_voices(1,:)));
% p2=plot(Time, abs(ST_voices(2,:)));
% p3=plot(Time, abs(ST_voices(3,:)));
% set(p1,'linewidth',2,'LineStyle', '-','color','b');
% set(p2,'linewidth',2,'LineStyle', '-','color','r');
% set(p3,'linewidth',2,'LineStyle', '-','color','g');
% xlab=xlabel('Temps (s)');
% ylab=ylabel('\beta');
% grid on; box on;
% legend('\beta_{50}','\beta_{150}','\beta_{250}')
% set(gca,'fontsize',FontSize);
% set(xlab,'fontsize',FontSize,'Rotation',0);
% set(ylab,'fontsize',FontSize,'Rotation',90);
% title('Stockwell')
% hold off
% saveas(gcf, ['figure ',num2str(N),'.png'])

% figure(N)
% hold on
% set(N,'PaperUnits','centimeter')
% set(N,'Units','centimeter')
% set(N,'PaperPosition',[0 0 40 20]); % taille transférée
% set(N,'Position',[0 0 40 20]);  % taille écran
% p1=plot(Time, abs(STS_voices(1,:)));
% p2=plot(Time, abs(STS_voices(2,:)));
% p3=plot(Time, abs(STS_voices(3,:)));
% set(p1,'linewidth',2,'LineStyle', '-','color','b');
% set(p2,'linewidth',2,'LineStyle', '-','color','r');
% set(p3,'linewidth',2,'LineStyle', '-','color','g');
% xlab=xlabel('Temps (s)');
% ylab=ylabel('\beta');
% grid on; box on;
% legend('\beta_{50}','\beta_{150}','\beta_{250}')
% set(gca,'fontsize',FontSize);
% set(xlab,'fontsize',FontSize,'Rotation',0);
% set(ylab,'fontsize',FontSize,'Rotation',90);
% title('Sejdic')
% hold off
% saveas(gcf, ['figure ',num2str(N),'.png'])

%save the beta features for the ST and STFT
%Beta_ST(N,:) = [Betas_ST(1) Betas_ST(2) Betas_ST(3) Betas_ST(4) Betas_ST(5)];
%Beta_STFT(N,:) = [Betas_STFT(1) Betas_STFT(2) Betas_STFT(3) Betas_STFT(4) Betas_STFT(5)];
%Beta_OnTFC(N,:) = [Betas_OnTFC(1) Betas_OnTFC(2) Betas_OnTFC(3) Betas_OnTFC(4) Betas_OnTFC(5)];
% save the beta features and active power for the ST and STFT
discripteurs_ST(N,:) = [P_act_moyenne P_max_trans Betas_ST(1) Betas_ST(2) Betas_ST(3) Betas_ST(4) Betas_ST(5) Max_ST_voices(1) Max_ST_voices(2) Max_ST_voices(3) Max_ST_voices(4) Max_ST_voices(5)];
%discripteurs_STFT(N,:) = [P_act_moyenne Betas_STFT(1) Betas_STFT(2) Betas_STFT(3) Betas_STFT(4) Betas_STFT(5)];
%discripteurs_OnTFC(N,:) = [P_act_moyenne Betas_OnTFC(1) Betas_OnTFC(2) Betas_OnTFC(3) Betas_OnTFC(4) Betas_OnTFC(5)];
discripteurs_STS(N,:) = [P_act_moyenne P_max_trans Betas_STS(1) Betas_STS(2) Betas_STS(3) Betas_STS(4) Betas_STS(5) Max_STS_voices(1) Max_STS_voices(2) Max_STS_voices(3) Max_STS_voices(4) Max_STS_voices(5)];
%close(figure(N));
end
