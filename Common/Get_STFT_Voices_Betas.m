function [STFT_voices, Betas_STFT] = Get_STFT_Voices_Betas(Time_Series, Sigma, indices, Length, index_ON, Te, Fe)
% -------------------------------------------------------------------------
%
% ------------------------------ Inputs -----------------------------------
% "Time_Series"   - vector of data to be transformed
% "sigma"         - is the factor in the STFT
% "indices"       -
% "Length"        -
% "nbre_harmonic" -
% "index_ON"      -
% ------------------------------ Outputs ----------------------------------
% "STFT_voices"   - is the voice of
% "Betas_STFT"    - is the beta features using the STFT
%% Start funtcion
Time = (0:length(Time_Series)-1)*Te;

Frequency = (0:Length)*Fe/(Length);

Fx = fft(Time_Series,Length)/Length;
XF = [Fx Fx];

Window = (1/(Sigma*sqrt(2*pi)))*exp(-((Time - max(Time)/2).^2)/(2*Sigma^2));
wind = (fft(Window,Length))./max(fft(Window,Length));
STFT_voices = zeros(1,Length); STFT_voices_norm = zeros(1,Length); Betas_STFT = zeros(1,1);

for i = 1:1:length(indices)
    STFT_voices(i,:) = ifftshift(ifft((XF(indices(i):indices(i)+Length-1).*(wind)),Length),2);
end
% End STFT-Transform
% ------------------------------------------------------------------------------------------------------
% Calcul et stockage des valeurs du descripteur beta pour un ON/OFF d'une charge sur une période entière
abs_STFT_voices = zeros(length(indices),Length);

for i=1:1:length(indices)
    abs_STFT_voices(i,:) = abs(STFT_voices(i,:));
    STFT_voices_norm(i,:) = ((abs_STFT_voices(i,:) - min(abs_STFT_voices(i,:)))./(max(abs_STFT_voices(i,:)) - min(abs_STFT_voices(i,:))))+0.0001;
    Betas_STFT(i,1) = -sum((STFT_voices_norm(i,index_ON-1500:index_ON+4500).^2).*log(STFT_voices_norm(i,index_ON-1500:index_ON+4500).^2));
end

end
