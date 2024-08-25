function A=VS(m,N,s)
  
A=zeros(m,N);
L=fix(s/m);
MOD=mod(s,m);
for i=1:m
    for j=1:L
    A(i,j)=1;
    end    
end

for i=1:MOD
    A(i,L+1)=1;
end

end
