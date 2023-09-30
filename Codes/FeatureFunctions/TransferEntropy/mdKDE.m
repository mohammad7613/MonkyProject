function p=mdKDE(X,xi,bw_coeff)

%%%%%
% This function implements multidimensional kernel density estimation with
% a Gaussian kernel.
%
% Inputs:
% X: data matrix, rows are observations and columns are dimensions.
% xi: coordinates at which joint probabilities are to be estimated, rows are data points and columns are dimensions.
% bw_coeff: multiplier that adjusts the rule of thumb Gaussian bandwidth, a value of 1 means no change in the rule of thumb bandwidth
%
% Output:
% p: joint probability at xi
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


N=size(X,1);
d=size(X,2);

% pick bandwidth for each dimension
h=zeros(1,d);
for i=1:d
    h(i)=bw_coeff*1.06*N^(-1/5)*std(X(:,i));  % rule of thumb that assumes a Gaussian distribution
end
    
% estimate probability at xi
p=zeros(size(xi,1),1);
for k=1:length(p)
    for i=1:N
        prod=1;
        for j=1:d
            u=(xi(k,j)-X(i,j))/h(j);
            prod=prod*1/sqrt(2*pi)*exp(-0.5*u^2)/h(j);
        end
        p(k)=p(k)+prod;
    end    
end
p=p./N;
