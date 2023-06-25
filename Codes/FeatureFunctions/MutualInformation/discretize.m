function D = discretize(S,q)
        ma = max(S);
        mi = min(S);
        S_normalized = (S - mi)./(ma-mi) * q;
        D = round(S_normalized);
        Imax = D==q;
        D(Imax) = D(Imax) - 1; 
end