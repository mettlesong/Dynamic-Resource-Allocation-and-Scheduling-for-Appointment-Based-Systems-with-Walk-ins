function A=HS(m,N,s)

s_left=s-m;
A=zeros(m,N);
A(:,1)=1;
for i=1:m
    for j=2:N
        if (N-1)*(i-1)+j-1<=s_left
        A(i,j)=1;
        end
    end
end

end
