function [P_inst, P_act, P_max_trans] = Get_Power(current, voltage, Te, T, Length)
%       Inputs
% Current   : Current vector input
% Volktage  : Voltage vector input
% Te        : Sampling time
% T         : Time of 50Hz periode
%       Outputs
% P_inst    : Instantaneous power
% P_act     : Active power
% P_max_trans : maximum active power transitory


    nombre_ech_par_T = round(T/Te); % nombre d'échantillons d'une période T à une période d'échantillonnage Te
    P_inst = current.* voltage;
    P_act = zeros(nombre_ech_par_T,1);
    for i = 1:1:Length-nombre_ech_par_T
        P_act(nombre_ech_par_T+i) = sum(P_inst(i:round(nombre_ech_par_T+i)))/nombre_ech_par_T;
    end
    P_max_trans = max(P_act);
end