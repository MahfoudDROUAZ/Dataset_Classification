function [time_ON, time_OFF, tau1,  tau2, index_OFF, P_act_moyenne] = Get_Time_ON_OFF(P_act, time, T, Te, Length)
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

    index_OFF=0;
    time_OFF=0;
    nombre_ech_par_T = T/Te; % nombre d'échantillons d'une période T à une période d'échantillonnage Te

    for i = 1:1:Length-nombre_ech_par_T
        if(P_act(i) >= 1.3)
            time_ON  = time(i);
            tau1 = i-150; % on rajuste de 150 échantillons soit une demi période l'index du ON
        break;
        end
    end
tau2 = tau1 + 14*nombre_ech_par_T;
% Calcul de la puissance active sur une période de 2s après durée de 2s de la détection de
% la charge
index_Pact = round(1/Te);
P_act_moyenne = mean(P_act((tau1+index_Pact):(tau1+2*index_Pact)));

end

