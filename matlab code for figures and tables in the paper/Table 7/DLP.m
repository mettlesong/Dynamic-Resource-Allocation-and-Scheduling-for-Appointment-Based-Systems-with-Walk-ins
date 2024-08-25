function [DLP_bar_vf,DLP_allocation,DLP_scheduling,bar_k] = DLP(N,m,r,w,pd0,pd1,pi,theta,p_s)
%DLP_THETA 此处显示有关此函数的摘要
% DLP_theta_bar_vf returns the optimal value for the deterministic problem, which is a upper bound for the stochastic problem
% DLP_theta_policy returns the optimal sheduling and allocation for the
% deterministic problem.
DLP_allocation=zeros(2,N);  %DLP_allocation(1,j)=x^j_1; DLP_allocation{j}(2,j)=x^j_2;
DLP_scheduling=zeros(1,N);  %DLP_scheduling=a
DLP_scheduling(1)=m;
bar_k=-1;
judge=0;
Threshold=r(1)+(N-2)*w(1)+pi(1);  %k=2
if Threshold<r(2)  
    bar_k=1;
    judge=1;
else
    for k=3:N
        Threshold=r(1)+(N-k)*w(1)+pi(1);
        if Threshold<r(2)
            judge=1;
            bar_k=k-1;
            break;
        end
    end
    if k==N && judge==0
        bar_k=N;
    end
end

%dim0=length(pd0);
%dim1=length(pd1);
mu_0=0;
for i=2:length(pd0)
    mu_0=mu_0+(i-1)*pd0(i);
end

mu_1=0;
for i=2:length(pd1)
    mu_1=mu_1+(i-1)*pd1(i);
end


for j=2:bar_k   %allocate inpatients first
    DLP_allocation(1,j)=min(m-mu_0,(j-1)*mu_1-sum(DLP_allocation(1,2:j-1)));
    DLP_allocation(2,j)=max(m-mu_0-DLP_allocation(1,j),0);
    DLP_scheduling(j)=DLP_allocation(2,j);
end

for j=(1+bar_k):N   %allocate outpatients first
     DLP_allocation(1,j)=0;
     DLP_allocation(2,j)=m-mu_0;
     DLP_scheduling(j)=DLP_allocation(2,j);
end
DLP_scheduling=DLP_scheduling/p_s; % p_s will not affect the DLP solution except the a_j

DLP_bar_vf=0;
for j=2:N
    DLP_bar_vf=DLP_bar_vf+(r(1)+(N-j)*w(1)+pi(1))*DLP_allocation(1,j)+r(2)*DLP_allocation(2,j)-((N-j)*w(1)+pi(1))*mu_1;
end

DLP_bar_vf=theta*DLP_bar_vf;
return;
  
end

