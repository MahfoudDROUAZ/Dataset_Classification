function [time_ON, time_OFF, tau1, tau2, index_OFF, PI, PA, PAM] = Get_Time_ON_OFF_HELD(current, voltage, time, T, Te)
% This function get the active power and return the time_ON, time_OFF of
% the appliance, and there times index
% 
% -----------------------     inputs       --------------------------------
% P_act : is the active power
% time  : is the simpling time vector
% n     : is nomber of samples in one time periode
% -----------------------     outputs      --------------------------------
% time_ON   : is the time turn ON of the aplliance
% time_OFF  : is the time turn OFF of the appliance
% index_ON  : is the index time turn ON of the appliance
% index_OFF : is the index time trun OFF of the appliance
% -------------------------------------------------------------------------

    index_OnLoad = 3000;
    index_OFF=0;
    time_OFF=0;
    time_ON = 0;
    nbr_ech_par_T = T/Te; % nombre d'échantillons d'une période T à une période d'échantillonnage Te
    PI = current.* voltage; % Puissance instantanée
    PA = zeros(length(current),1); % Puissance active

    for j = 1:1:length(time)-nbr_ech_par_T
        PA(nbr_ech_par_T+j) = sum(PI(j:j+nbr_ech_par_T))/nbr_ech_par_T;
    end

% i = 1;
% while PA(i) < 3
%     i = i+1;
% end
% time_ON = time(i);
% tau1 = i-150;
tau1 = 3000-150; % de fausses détection apparaissent en utilisant le seuil de la PAM
tau2 = tau1 + 14*nbr_ech_par_T;
% Calcul de la puissance active moyenne sur une période de 2s après durée de 2s de la détection de
% la charge
index_Pact = round(1/Te);
PAM = mean(PA((tau1+index_Pact):(tau1+2*index_Pact)));

end