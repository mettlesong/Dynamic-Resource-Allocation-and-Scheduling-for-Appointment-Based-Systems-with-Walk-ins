function A=HS(m,N,s)
  
A=zeros(m,N);
for i=1:m
    for j=1:N
        if N*(i-1)+j<=s
        A(i,j)=1;
        end
    end
end

end
