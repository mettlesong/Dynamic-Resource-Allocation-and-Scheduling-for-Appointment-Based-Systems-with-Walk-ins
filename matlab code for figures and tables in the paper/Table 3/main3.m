function main

tic;
global N m r w pi;
%global N m r w d0 pd0 d1 pd1 pi pd01;


IterNum = 2e5;

%%%X1:n  X2:s %%%

% Problem data
N=20;
m=3;
%r=[200 1000];
r=[800 1000];
%w=[0 10];
w=[0 20];

%pi=[500 400]; % (a) nonliner penalty cost function
pi=[2000 100]; % (b) liner penalty cost function

%d0=[0 1 2 3]; % emergency patients number
%pd0=[0.72 0.20 0.06 0.02]; % emergency patients arrival probability

%pd01=[0.5 0.3 0.12 0.08];%%%for j=9,10,11 nonstationary arrival%%%

%d1=[0 1 2 3 4 5];  % inpatients number
%pd1=[0.1 0.2 0.4 0.25 0.04 0.01]; % inpatients arrival probability

a_V=VS(m,N,19);%%%%VS%%%%
a_H=HS(m,N,23);%%%%HS%%%%

value=zeros(6,IterNum);

Iter = 0;
while (Iter < IterNum)
    Iter = Iter + 1;
    [InNumPerI,EmNumPerI] = GenerateArri();

    % VS+critical heuristic policy value
    [wait_in_V,wait_out_V,idle_V,~]=critical_first(a_V,InNumPerI,EmNumPerI);
    value(1,Iter) =wait_in_V ;
    value(2,Iter) =wait_out_V ;
    value(3,Iter) =idle_V;

    
    % HS+critical heuristic policy value
    [wait_in_H,wait_out_H, idle_H,~]=critical_first(a_H,InNumPerI,EmNumPerI);
    value(4,Iter) =wait_in_H; 
    value(5,Iter) =wait_out_H;
    value(6,Iter) =idle_H ;


end

W_in_V=mean(value(1,:)); %s1=sqrt(value(1,:));
W_out_V=mean(value(2,:));%s2=sqrt(value(2,:));
I_V=mean(value(3,:));    %s3=sqrt(value(3,:));

W_in_H=mean(value(4,:)); %s4=sqrt(value(4,:));
W_out_H=mean(value(5,:));%s5=sqrt(value(5,:));
I_H=mean(value(6,:));    %s6=sqrt(value(6,:));


   
%Err(:,1) = ((2*1.96/sqrt(IterNum))*s1/W_in_V)';         % 95% confidence interval
%Err(:,2) = ((2*1.96/sqrt(IterNum))*s2/W_out_V)';
%Err(:,3) = ((2*1.96/sqrt(IterNum))*s3/I_V)';

%Err(:,4) = ((2*1.96/sqrt(IterNum))*s4/W_out_H)';
%Err(:,5) = ((2*1.96/sqrt(IterNum))*s5/W_out_H)';
%Err(:,6) = ((2*1.96/sqrt(IterNum))*s6/I_H)';





results=zeros(2,3);

%%%%%results%%%%
results(1,:)=[W_in_V,W_out_V,I_V];
results(2,:)=[W_in_H,W_out_H,I_H];



%display(results);
disp(results)

 
end