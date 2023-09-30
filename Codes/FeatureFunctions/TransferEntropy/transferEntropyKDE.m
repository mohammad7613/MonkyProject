function T = transferEntropyKDE(X,Y,t,w,N,bw_coeff)

%%%%%
% This function computes the transfer entropy between time series X and Y,
% with the flow of information directed from X to Y. Probability density
% estimation is based on Guassian kernel density estimation.
% 
% For details, please see T Schreiber, "Measuring information transfer", Physical Review Letters, 85(2):461-464, 2000.
%
% Inputs:
% X: source time series in 1-D vector
% Y: target time series in 1-D vector
% t: time lag in X from present
% w: time lag in Y from present
% N: number of equally spaced points along each dimension where probabilities are to be estimated
% bw_coeff: multiplier that adjusts the rule of thumb Gaussian bandwidth, a value of 1 means no change in the rule of thumb bandwidth
%
% Outputs:
% T: transfer entropy (bits)
%
%
% Copyright 2011 Joon Lee
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%%%%


% fix block lengths at 1
l=1; k=1;

X=X(:)';
Y=Y(:)';

% go through the time series X and Y, and populate Xpat, Ypat, and Yt
Xpat=[]; Ypat=[]; Yt=[];
for i=max([l+t k+w]):1:min([length(X) length(Y)])
    Xpat=[Xpat; X(i-l-t+1:i-t)];
    Ypat=[Ypat; Y(i-k-w+1:i-w)];
    Yt=[Yt; Y(i)];    
end

% compute transfer entropy
Xpati=linspace(min(Xpat)-0.1*range(Xpat),max(Xpat)+0.1*range(Xpat),N);
Ypati=linspace(min(Ypat)-0.1*range(Ypat),max(Ypat)+0.1*range(Ypat),N);
Yti=linspace(min(Yt)-0.1*range(Yt),max(Yt)+0.1*range(Yt),N);
pdf=zeros(length(Xpati),length(Ypati),length(Yti));
for i=1:length(Xpati)
    for j=1:length(Ypati)
        for k=1:length(Yti)
            pdf(i,j,k)=mdKDE([Xpat Ypat Yt],[Xpati(i) Ypati(j) Yti(k)],bw_coeff);            
        end
    end
end
pdf=pdf./sum(sum(sum(pdf)));    % normalize
T=0;
for i=1:length(Xpati)
    for j=1:length(Ypati)
        for k=1:length(Yti)
            a=pdf(i,j,k);
            b=sum(pdf(i,j,:));
            c=sum(pdf(:,j,k));
            d=sum(sum(pdf(:,j,:)));
            T=T+a*log2((a*d)/(b*c));  
        end
    end
end


