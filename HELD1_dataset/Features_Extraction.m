% ------------------------------------------------------------------------------------------------------
% Coded by : Mahfoud DROUAZ
% 
%
% ------------------------------------------------------------------------------------------------------
% Last update 28-11-2020
% ------------------------------------------------------------------------------------------------------
clc, clear all, close all,
% ------------------------------------------------------------------------------------------------------
% Example to read NC-file of the HELD1 dataset
% $Rev 532 $
% $Author pheld $
% $Date 2018-01-10 141906 +0100 (Mi, 10 Jan 2018) $
% ------------------------------------------------------------------------------------------------------
% Select NC file
clc, clear all, close all
ST_Features = []; STS_Features = [];
%[FileName, PathName] = uigetfile('.nc', 'Auswahl der Messung welche eingelesen werden soll');
F_max = 3;                  % nombre de voies fréquentielles calculées
f = [50, 150, 250, 350, 450]; % voie fréquentielles calculées
lambda = 0.01;              % pas du gradient
beta = 0.001;               % facteur d'oubli
FontSize = 16; %figure text font size
Fe = 4000; Te = 1/Fe;
Factor = 1; % window width gaussian
T = 20e-3; % time of one period 20ms

addpath('F:\disc local G\thèse_Hakim\Chapitre6\Programmes_traitements\Common');

for file=1:1:14

    PathName = 'F:\dataset\HELD1\HELD1_data\training_set\';
    FileName = ['scenario_',num2str(file),'.nc'];
    % Informationen auslesen
    Ainfo = ncinfo([PathName '' FileName])
    % read data
    % voltage
    v1_1 = ncread([PathName '/' FileName],'v1'); % entire record
    v1_2 = ncread([PathName '/' FileName],'v1',5E4,1E5); % from index 5E4, 1E5 sampels
    % current
    i1_1 = ncread([PathName '/' FileName],'i1'); % entire record
    i1_2 = ncread([PathName '/' FileName],'i1',5E4,1E5); % from index 5E4, 1E5 sampels
    
    % refference data
    
    Length = length(v1_1);
    E_IDX = ncreadatt([PathName '/' FileName],'/','event_idx'); % event index
    E_DIR = ncreadatt([PathName '/' FileName],'/','event_dir'); % event ON(1)  OFF(0)
    E_ID  = ncreadatt([PathName '/' FileName],'/','event_id');  % device ID
    
    % time = 0:Te:(Length-1)*Te; % entire record
    index_E_DIR = find(E_DIR); 
    index_OnLoad = E_IDX(index_E_DIR);

    descripteurs_ST = zeros(1,13);
    descripteurs_STS = zeros(1,13);
    %descripteurs_OnTFC = zeros(1,5);

    for i=1:1:length(index_OnLoad)
        
        current = i1_1(index_OnLoad(i)-3000:index_OnLoad(i)+12000);
        voltage = v1_1(index_OnLoad(i)-3000:index_OnLoad(i)+12000);
        LengthCutCurrent = length(current);
        Time = 0:Te:(LengthCutCurrent-1)*Te; % time vector
        
        [P_inst, P_act, P_max_trans] = Get_Power(current, voltage, Te, T, LengthCutCurrent);
        [time_ON, time_OFF, tau1, tau2, index_OFF, PI, PA, PAM] = Get_Time_ON_OFF_HELD(current, voltage, Time, T, Te);
        indices = ceil([50, 150, 250, 350, 450]*LengthCutCurrent/Fe)+1;
%         hold on,
%         plot(current(index_ON:index_OFF_Transient))
%         plot(PA(index_ON:index_OFF_Transient))        

        % Get the Stokwell voices for each harmonics and the beta
        [ST_voices, Betas_ST, Max_ST_voices] = Get_ST_Voices_Betas(current, Factor, indices, LengthCutCurrent, tau1, tau2);
        % Get the Stokwell voices with Sejdic parameter for each harmonics and the beta
        p = [1, 0.9, 0.8, 0.8, 0.8, 0.8];
        [STS_voices, Betas_STS, Max_STS_voices] = Get_ST_Sejdic_Voices_Betas(current, p, indices, LengthCutCurrent, tau1, tau2);
        
        descripteurs_ST(i,:) = [E_ID(index_E_DIR(i)) PAM P_max_trans Betas_ST(1) Betas_ST(2) Betas_ST(3)...
            Betas_ST(4) Betas_ST(5) Max_ST_voices(1) Max_ST_voices(2) Max_ST_voices(3) Max_ST_voices(4) Max_ST_voices(5)];
        descripteurs_STS(i,:) = [E_ID(index_E_DIR(i)) PAM P_max_trans Betas_STS(1) Betas_STS(2) Betas_STS(3)...
            Betas_STS(4) Betas_STS(5) Max_STS_voices(1) Max_STS_voices(2) Max_STS_voices(3) Max_STS_voices(4) Max_STS_voices(5)];
    end
    
    ST_Features = [ST_Features; descripteurs_ST];
    STS_Features = [STS_Features; descripteurs_STS];
end
