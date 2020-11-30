function [ST, abs_ST, angle_ST, Time, Frequency] = Get_ST(Time_Series, Te, Fe, F_max, Factor)
% -------------------------------------------------------------------------
% code by : RG Stockwell
%------------------------  Inputs -----------------------------------------
% "Time_series" - vector of data to be transformed
% "Fe"          - is the time interval between samples
% "F_max"       - is the maximum frequency in the ST result
% "Factor"      - is the factor in the ST
%
%---------------------- Outputs Returned ----------------------------------
% "ST"          - a complex matrix containing the Stockwell transform.
%                   The rows of STOutput are the frequencies and the
%                   columns are the time values ie each column is
%                   the "local spectrum" for that point in time
% "Time"         - a vector containing the sampled times
% "Frequency"    - a vector containing the sampled frequencies
%--------------------------------------------------------------------------
%% START OF INPUT VARIABLE CHECK
% First:  make sure it is a valid time_series
Length = length(Time_Series);
% Change to column vector
if size(Time_Series,2) > size(Time_Series,1)
    Time_Series = Time_Series';
end

% Make sure it is a 1-dimensional array
if size(Time_Series,2) > 1
    error('Please enter a *vector* of data, not matrix')
    return
elseif (size(Time_Series)==[1 1]) == 1
    error('Please enter a *vector* of data, not a scalar')
    return
end

% END OF INPUT VARIABLE CHECK

% calculate the sampled time and frequency values from the two sampling rates
Time = (0:Length-1)*Te;

% Shannon-Nyquist theorem
Frequency = (0:Length-1)*Fe/Length;

% Recherche de l'indice pour la fr�quence max dans l'intervalle des fr�quences.
indice = 1;
while Frequency(indice) < F_max
    indice = indice+1;
end,

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% The actual S Transform function is here:
% Returns the Stockwell Transform, STOutput, of the time-series
% Reference is "Localization of the Complex Spectrum: The S Transform"
% from IEEE Transactions on Signal Processing, vol. 44., number 4,
% April 1996, pages 998-1001.
%--------------------------------------------------------------------------

% Compute FFT's
% la multiplication par 2 c'est pour avoir la bonne amplitude du signal
vector_fft = 2*fft(Time_Series,Length);
vector_fft = [vector_fft,vector_fft];

% Preallocate the ST_Output matrix
ST = zeros(indice,length(Time_Series));

% Factor
% factor = 1;

% Compute the mean
% Compute S-Transform value for 1
ST(1,:) = mean(Time_Series)*(1&[1:1:length(Time_Series)]);

% The actual calculation of the ST
% Start loop to increment the frequency point
for i = 1:1:indice-1
    %gauss = g_window(length(Time_Series),i,Factor);
    ST(i+1,:) = ifft(vector_fft(i+1:i+Length).*g_window(Length,i,Factor));  
end

Frequency = Frequency(1:indice);

abs_ST = abs(ST);
angle_ST = angle(ST);

%%% end STransform function

%--------------------------------------------------------------------------
function gauss = g_window(length,freq,Factor)

% Function to compute the Gaussion window for
% function STransform. g_window is used by function
% STransform. Programmed by Eric Tittley
%
%----------------------------Inputs Needed---------------------------------
%
% "length"      - the length of the Gaussian window
% "freq"        - the frequency at which to evaluate the window
% "factor"      - the window-width factor
%
%----------------------------Outputs Returned------------------------------
% "gauss"       - The Gaussian window

vector(1,:) = (0:length-1);
vector(2,:) = (-length:-1);
vector = vector.^2;
vector = vector*(-Factor^2*2*pi^2/freq^2);
% Compute the Gaussion window
gauss = sum(exp(vector));