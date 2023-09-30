"example_data.mat" contains a 1-D structure array of example data that harnesses an information flow from X to Y at a lag of 2 according to the following relationship:

y(i)=[(1+a)*x(i-2)]^2

where "a" is a coupling constant. Also, noise from a Laplace distribution was added to X and Y according to a given SNR level. 

The structure has 5 fields:

N: number of samples (actual lengths of X and Y are N+2 due to the lag of 2), ranged from 50 to 200 at a step of 50.
SNR: signal to noise ratio, common to both X and Y, ranged from 30 to 40 dB at a step of 1 db.
a: coupling constant, determined from SNR.
X: 1-D vector containing the source time series.
Y: 1-D vector containing the sink time series.


