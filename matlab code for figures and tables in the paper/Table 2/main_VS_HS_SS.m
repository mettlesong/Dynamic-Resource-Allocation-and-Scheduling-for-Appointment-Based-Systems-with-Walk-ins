%function main

tic;
%global N m r w d0 pd0 d1 pd1 pi pd01;


%%%X1:n  X2:s %%%

% Problem data
N=20;
m=3;
%r=[200 1000];
r=[800 1000];
w=[0 20];
%w=[0 10];

%pi=[500 400]; % (a) nonliner penalty cost function
%pi=[2000 100]; % (b) liner penalty cost function
pi=[500 300]; % (b) liner penalty cost function

%D0=[0 1 2 3]; % emergency patients number
pd0=[0.72 0.20 0.06 0.02]; % emergency patients arrival probability

pd01=[0.5 0.3 0.12 0.08];%%%for j=9,10,11 nonstationary arrival%%%

%D1=[0 1 2 3 4 5];  % inpatients number
pd1=[0.1 0.2 0.4 0.25 0.04 0.01]; % inpatients arrival probability


[v_VS,s_VS]=get_V_VS_simple_linear_1(N,m,r,w,pd0,pd01,pd1,pi,1);
[v_HS,s_HS]=get_V_HS_simple_linear_1(N,m,r,w,pd0,pd01,pd1,pi,1);
results=zeros(3,2);
%%%%%results%%%%
results(1,:)=[v_VS,s_VS];
results(2,:)=[v_HS,s_HS];

%{
A=zeros(m,N);
A(1:m,1)=1;
%A1=zeros(m,N);

for t=2:N
    A1=A;
    W=-inf;
    for i=0:m
        A1(1:i,t)=1;
        [V_SS,s]=get_V_SS(A1,t,m,r,w,pd0,pd1,pi,pd01);
        if V_SS>W
            W=V_SS;s_SS=s;A=A1;
        end
    end
end

results(3,:)=[V_SS,s_SS];

%}

disp(results);
