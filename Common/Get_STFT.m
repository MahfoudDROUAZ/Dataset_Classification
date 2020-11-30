function [STFT, abs_STFT, angle_STFT, Time, Frequency] = Get_STFT(Time_Series, Te, Fe, Sigma, F_max)
% -------------------------------------------------------------------------
%                      University of Haute Alsace
%                           Mahfoud DROUAZ
%                             13/10/2015
%-------------------------- Inputs ----------------------------------------
% "Time_series" - vector of data to be transformed
% "Fe"          - is the time interval between samples
% "F_max"       - is the maximum frequency in the STFT result
% "Sigma"       - is the factor in the STFT
%
%-------------------- Outputs Returned ------------------------------------
% "STFT"         - a complex matrix containing the Short Time Fourier 
%                  Transform.
% "abs_STFT"     - absolute value of the matrix containing the STFT
% "angle_STFFT"  - phase of the matrix containing the STFT
%--------------------------------------------------------------------------
%% Start funtcion
Length = length(Time_Series);
Time = (0:length(Time_Series)-1)*Te;

Frequency = (0:Length)*Fe/(Length);
indice = 1;
while Frequency(indice) <= F_max
    indice = indice + 1;
end
Frequency = Frequency(1:indice-1);

Fx = 2*(fft(Time_Series,Length)./Length);
XF = [Fx Fx];

%Window = (1/(Sigma*sqrt(2*pi)))*exp(-((Time - max(Time)/2).^2)/(2*Sigma^2));
%wind = (fft(Window,Length))./max(fft(Window,Length));
Max = (F_max*Length*Te);

% Compute the Gaussion window
vector(1,:) = (0:Length-1);
vector(2,:) = (-Length:-1);
vector = vector.^2;
vector = vector*(-Sigma^2*2*pi^2);
gauss = sum(exp(vector));

STFT = zeros(1,Length);
STFT(1,:) = mean(Time_Series)*(1&[1:1:length(Time_Series)]);

for i = 1:1:Max-1
    STFT(i+1,:) = ifft(XF(i+1:i+Length).*gauss,Length).*Length;
end

abs_STFT = abs(STFT);
angle_STFT = angle(STFT);

end