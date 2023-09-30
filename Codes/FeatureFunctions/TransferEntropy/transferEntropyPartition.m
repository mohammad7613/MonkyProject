function [T nPar dimPar]=transferEntropyPartition(X,Y,t,w)

%%%%%
% This function computes the transfer entropy between time series X and Y,
% with the flow of information directed from X to Y. Probability density
% estimation is based on the Darbellay-Vajda partitioning algorithm.
% 
% For details, please see T Schreiber, "Measuring information transfer", Physical Review Letters, 85(2):461-464, 2000.
%
% Inputs:
% X: source time series in 1-D vector
% Y: target time series in 1-D vector
% t: time lag in X from present
% w: time lag in Y from present
%
% Outputs:
% T: transfer entropy (bits)
% nPar: number of partitions
% dimPar: 1-D vector containing the length of each partition (same along all three dimensions)
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

% ordinal sampling (ranking)
Nt=length(Xpat);
[B,IX]=sort(Xpat);
Xpat(IX)=1:Nt;
[B,IX]=sort(Ypat);
Ypat(IX)=1:Nt;
[B,IX]=sort(Yt);
Yt(IX)=1:Nt;

% compute transfer entropy
partitions=DVpartition3D(Xpat,Ypat,Yt,1,Nt,1,Nt,1,Nt);
nPar=length(partitions);
dimPar=zeros(nPar,1);
for i=1:nPar
    dimPar(i)=partitions(i).Xmax-partitions(i).Xmin+1;
end
T=0;
for i=1:length(partitions)
    a=partitions(i).N/Nt;
    b=sum(Xpat>=partitions(i).Xmin & Xpat<=partitions(i).Xmax & Ypat>=partitions(i).Ymin & Ypat<=partitions(i).Ymax)/Nt;
    c=sum(Yt>=partitions(i).Zmin & Yt<=partitions(i).Zmax & Ypat>=partitions(i).Ymin & Ypat<=partitions(i).Ymax)/Nt;
    d=(partitions(i).Ymax-partitions(i).Ymin+1)/Nt;
    T=T+a*log2((a*d)/(b*c));     
end


