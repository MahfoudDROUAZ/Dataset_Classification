function [ST_voices, Betas_ST, Max_ST_voices] = Get_ST_TemWin_Voices_Betas(Times_Series, indices, Length, index_ON, index_off_transient)
% Implémentation de la transformée de Stockwell version Sejdic et al. [08]
% -------------------------------------------------------------------------
%
% ------------------------------ Inputs -----------------------------------
% Time_Series =
% sigma
% indices
% Length
% nbre_harmonic
% index_ON
% ------------------------------ Outputs ----------------------------------
% ST_voices
% Betas_ST
% max_ST_voices
%% Start function
if mod(Length,2)~=0
    Length = Length-1;
end

tw = fliplr([1:floor(Length/2) -floor(Length/2)+1:0])/Length;
Fx = 2*fft(Times_Series, Length);
XF = [Fx Fx];

ST_voices = zeros(1,Length);
ST_voices_norm = zeros(1,Length);
Betas_ST = zeros(1,1);

for f = 1:1:length(indices)
    %indices(f)
    %wind = ((indices(f)^(p))/sqrt(2*pi))*exp(-0.5*(indices(f)^(2*p))*tw.^2);
    wind = ((indices(f))/sqrt(2*pi))*exp(-0.5*(indices(f)^(2))*tw.^2);
    wind = wind/(sum(wind));
    W = fft(wind);
    ST_voices(f,:) = ifft(XF(indices(f)+1:indices(f)+Length).*W);
end
 
abs_ST_voices = zeros(length(indices), Length);
Max_ST_voices = zeros(length(indices),1);
for i=1:1:length(indices)
   abs_ST_voices(i,:) = abs(ST_voices(i,:));
   Max_ST_voices(i,:) = max(abs_ST_voices(i,:));
   ST_voices_norm(i,:) = ((abs_ST_voices(i,:) - min(abs_ST_voices(i,:)))./(max(abs_ST_voices(i,:)) - min(abs_ST_voices(i,:))))+0.0001;
   Betas_ST(i,1) = -sum((ST_voices_norm(i,index_ON:index_off_transient).^2).*log(ST_voices_norm(i,index_ON:index_off_transient).^2));
end
end