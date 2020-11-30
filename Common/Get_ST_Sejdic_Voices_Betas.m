function [STS_voices, Betas_STS, Max_STS_voices] = Get_ST_Sejdic_Voices_Betas(Times_Series, P, indices, Length, index_ON, index_off_transient)
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
Fx = 2*fft(Times_Series,Length);
XF = [Fx Fx];

STS_voices = zeros(1,Length);
ST_voices_norm = zeros(1,Length);
Betas_STS = zeros(1,1);

for f = 1:1:length(indices)
    p = P(f);
    wind = ((indices(f)^(p))/sqrt(2*pi))*exp(-0.5*(indices(f)^(2*p))*tw.^2);
    wind = wind/(sum(wind));
    W = fft(wind);
    STS_voices(f,:) = ifft(XF(indices(f)+1:indices(f)+Length).*W);
end
 
abs_STS_voices = zeros(length(indices), Length);
Max_STS_voices = zeros(length(indices),1);
for i=1:1:length(indices)
   abs_STS_voices(i,:) = abs(STS_voices(i,:));
   Max_STS_voices(i,:) = max(abs_STS_voices(i,:));
   ST_voices_norm(i,:) = ((abs_STS_voices(i,:) - min(abs_STS_voices(i,:)))./(max(abs_STS_voices(i,:)) - min(abs_STS_voices(i,:))))+0.0001;
   Betas_STS(i,1) = -sum((ST_voices_norm(i,index_ON:index_off_transient).^2).*log(ST_voices_norm(i,index_ON:index_off_transient).^2));
end
end