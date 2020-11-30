function [ST_voices, ST_voices_norm] = Get_ST_Voices(Time_Series, Factor, indices, Length)
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
% STFT_voices
% Betas_STFT
%% Start funtcion
% First:  make sure it is a valid time_series
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
% Compute FFT's: la multiplication par 2 c'est pour avoir la bonne amplitude du signal
vector_fft = 2*fft(Time_Series,Length);
vector_fft = [vector_fft,vector_fft];

%figure
%plot(abs(vector_fft))

ST_voices = zeros(1,Length); ST_voices_norm = zeros(1,Length); Betas_ST = zeros(1,1);

for i=1:1:length(indices)
    vector(1,:) = (0:Length-1);
    vector(2,:) = (-Length:-1);
    vector = vector.^2;
    vector = vector*(-Factor^2*2*pi^2/indices(i)^2);
    gauss = sum(exp(vector));
    ST_voices(i,:) = ifft(vector_fft(indices(i)+1:indices(i)+Length).*gauss);
end
% End S-Transform
% ------------------------------------------------------------------------------------------------------

end