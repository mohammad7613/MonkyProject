function partitions=DVpartition3D(X,Y,Z,Xmin,Xmax,Ymin,Ymax,Zmin,Zmax)

%%%%%
% This function implements the Darbellay-Vajda partitioning algorithm for a
% 3D space in a recursive manner. In order to support recursion, Each
% function call should specify a sub-space where partitioning should be
% executed. It is assumed that X, Y, and Z are ordinal (ranked, starting from 1) samples.
%
% For details, please see G A Darbellay and I Vajda, "Estimation of the information by an adaptive partitioning of the observation space", IEEE Transactions on Information Theory, 45(4):1315-1321, 1999.
%
% Inputs:
% X: 1-D vector containing coordinates in the first dimension
% Y: 1-D vector containing coordinates in the second dimension
% Z: 1-D vector containing coordinates in the third dimension
% Xmin: lower limit in the first dimension
% Ymin: lower limit in the second dimension
% Zmin: lower limit in the third dimension
% Xmax: upper limit in the first dimension
% Ymax: upper limit in the second dimension
% Zmax: upper limit in the third dimension
%
% Outputs:
% partitions: 1-D structure array that contains the lower and upper limits of each partition in each dimension as well as the number of data points (N) in the partition
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


alpha=0.05;

idx= X>=Xmin & X<=Xmax & Y>=Ymin & Y<=Ymax & Z>=Zmin & Z<=Zmax;
Xsub=X(idx);
Ysub=Y(idx);
Zsub=Z(idx);

Xdiv=floor(mean([Xmin Xmax]));
Ydiv=floor(mean([Ymin Ymax]));
Zdiv=floor(mean([Zmin Zmax]));

N=[sum(Xsub<=Xdiv & Ysub<=Ydiv & Zsub<=Zdiv) sum(Xsub>Xdiv & Ysub<=Ydiv & Zsub<=Zdiv) sum(Xsub<=Xdiv & Ysub>Ydiv & Zsub<=Zdiv) sum(Xsub>Xdiv & Ysub>Ydiv & Zsub<=Zdiv) ...
    sum(Xsub<=Xdiv & Ysub<=Ydiv & Zsub>Zdiv) sum(Xsub>Xdiv & Ysub<=Ydiv & Zsub>Zdiv) sum(Xsub<=Xdiv & Ysub>Ydiv & Zsub>Zdiv) sum(Xsub>Xdiv & Ysub>Ydiv & Zsub>Zdiv)];
T=sum((mean(N)-N).^2)./mean(N);  % has been corrected to include a normalization factor in the denominator
partitions=struct('Xmin',{},'Xmax',{},'Ymin',{},'Ymax',{},'Zmin',{},'Zmax',{},'N',{});

if T>icdf('chi2',1-alpha,7) && Xmax~=Xmin && Ymax~=Ymin && Zmax~=Zmin
    if N(1)~=0
        partitions=[partitions DVpartition3D(X,Y,Z,Xmin,Xdiv,Ymin,Ydiv,Zmin,Zdiv)];
    end
    if N(3)~=0
        partitions=[partitions DVpartition3D(X,Y,Z,Xmin,Xdiv,Ydiv+1,Ymax,Zmin,Zdiv)];
    end
    if N(2)~=0
        partitions=[partitions DVpartition3D(X,Y,Z,Xdiv+1,Xmax,Ymin,Ydiv,Zmin,Zdiv)];
    end
    if N(4)~=0
        partitions=[partitions DVpartition3D(X,Y,Z,Xdiv+1,Xmax,Ydiv+1,Ymax,Zmin,Zdiv)];
    end
    if N(5)~=0
        partitions=[partitions DVpartition3D(X,Y,Z,Xmin,Xdiv,Ymin,Ydiv,Zdiv+1,Zmax)];
    end
    if N(7)~=0
        partitions=[partitions DVpartition3D(X,Y,Z,Xmin,Xdiv,Ydiv+1,Ymax,Zdiv+1,Zmax)];
    end
    if N(6)~=0
        partitions=[partitions DVpartition3D(X,Y,Z,Xdiv+1,Xmax,Ymin,Ydiv,Zdiv+1,Zmax)];
    end
    if N(8)~=0
        partitions=[partitions DVpartition3D(X,Y,Z,Xdiv+1,Xmax,Ydiv+1,Ymax,Zdiv+1,Zmax)];
    end
elseif sum(idx)~=0
    partitions(1).Xmin=Xmin;
    partitions(1).Xmax=Xmax;
    partitions(1).Ymin=Ymin;
    partitions(1).Ymax=Ymax;
    partitions(1).Zmin=Zmin;
    partitions(1).Zmax=Zmax;
    partitions(1).N=sum(idx);
end

