function [tf_canolty] = tfMVL2(x,high_freq,y,low_freq, Fs)
% This function computes the phase amplitude coupling using TF-MVL method.

% Input:   x            : input signal as amplitude
%          y            : input signal as phase
%          high_freq    : Amplitude Frequency range 
%          low_freq     : Phase Frequency range 
%          Fs           : Sampling Frequency  

% Output:  tf_canolty   : Computed PAC using TF-MVL method


% Written by: Tamanna T. K. Munia, January 2019
% Please cite: Munia, Tamanna TK, and Selin Aviyente. "time-frequency Based phase-Amplitude 
% coupling Measure for neuronal oscillations." Scientific reports 9, no. 1 (2019): 1-15.

% These scripts have been optimised for the Windows operating systm  
% MATLAB version used 2018a.

%% Amplitude and Phase calculation

[tfdx] = rid_rihaczek4(x,Fs);
[tfdy] = rid_rihaczek4(y,Fs);

W = tfdx;
W2 = W(2:end,:);
Amp = abs(W2(high_freq:high_freq, :));
W = tfdy;
W2 = W(2:end,:);
Phase = angle(W2(low_freq:low_freq, :));



tf_canolty = (calc_MVL(Phase,Amp));

function [MVL] = calc_MVL(Phase,Amp)
         z1 = (exp(1i*Phase));
         z = Amp.*(z1);% Generate complex valued signal
         MVL = abs(mean(z));
end

end
