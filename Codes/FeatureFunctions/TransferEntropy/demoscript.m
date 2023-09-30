%% Testing functions

load example_data;

t=2; w=2;
l=1; k=1;

T1=zeros(1,11); %Rank
T2=zeros(1,11); %Partition
T3=zeros(1,11); %KDE
a=zeros(1,11);

for i=1:11

X1=coupling_data(i+33).X;
Y1=coupling_data(i+33).Y;
a(i)=coupling_data(i+33).a;

T1(i) = transferEntropyRank(X1,Y1,l,k,t,w,10);

[T2(i), nPar, dimPar]=transferEntropyPartition(X1,Y1,t,w);

T3(i) = transferEntropyKDE(X1,Y1,t,w,10,1);

end


figure;plot(a,T1,'.-'); hold on; plot(a,T2,'.-r'); plot(a,T3,'.-g'); 
xlabel('a'); ylabel('Transfer Entropy/Bit'); legend('TE Rank','TE Partition','TE KDE'); title('Transfer Entropy Between Time Series'); 