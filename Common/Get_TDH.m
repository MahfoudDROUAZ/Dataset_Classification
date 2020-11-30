function [TDH] = Get_TDH(ST_voices, index_ON, nbre_samples_T)
% -------------------------------------------------------------------------
% 
% ----------------------------- Inputs ------------------------------------
% "ST_voices"
% "index_ON"
% "nbre_samples_T"
% ----------------------------- Outputs -----------------------------------
% "TDH"  


sum_STvoices = sum(abs(ST_voices(2:end,:)).^2,1);

%index_ON-5*nbre_samples_T:index_ON+150*nbre_samples_T
TDH = sum_STvoices./abs(ST_voices(1,:));

end