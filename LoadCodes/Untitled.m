for j=1:9
    [pxx, f] = pmtm(squeeze(rawData(j, :)), 4, [], 2000);
    hold on;
    plot(f, pow2db(pxx))
    
end

%%
figure
grid on