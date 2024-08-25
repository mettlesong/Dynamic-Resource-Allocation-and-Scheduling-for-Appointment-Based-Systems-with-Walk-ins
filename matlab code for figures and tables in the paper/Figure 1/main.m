function main

tic;
%global N m r w d0 pd0 d1 pd1 pi ;

% Problem data
N=20;
m=3;
r=[200 1000];
w=[0 15];

%d0=[0 1 2 3]; % emergency patients number
pd0=[0.72 0.20 0.06 0.02]; % emergency patients arrival probability

%d1=[0 1 2 3 4 5];  % inpatients number
pd1=[0.1 0.2 0.4 0.25 0.04 0.01]; % inpatients arrival probability

p_s=0.84; %outpatients show up probability


%pi=[500 400]; % (a) nonliner penalty cost function
pi=[1000 100]; % (b) liner penalty cost function

% Initialization

%A=HS(m,N,55);  %get horizontal schedule
A=VS(m,N,6);    %get vertical schedule// m facilities,N slots, first 6 slots are scheduled

a=zeros(1,N);
for i=1:N
    a(i)=sum(A(1:3,i));  % the total number of scheduled outpatients of each slot //a(1)=a(2)=..=a(6)=3
end

V = cell(N,1);
for i=1:N
    V{i} = zeros(5*N+1,sum(a)+1); %at most 5*N inpatients in queue, at most sum(a) outpatients in queue
end

H = cell(N,4); % each slot, each possible emergency patients number(0 1 2 3) //H is function g in formula (2)
for i=1:N
    for j=1:4
    H{i}{j}=-100000*ones(5*N+1,sum(a)+1);
    end
end


policy = cell(N,4);% each slot, each possible emergency patients number(0 1 2 3)
for i=1:N
    for j=1:4
    policy{i}{j}=zeros(5*N+1,sum(a)+1);%%%total waiting number(x1+d1,x2+a_j+1)
    end
end

%
q_s=zeros(length(a),m+1);
for t=1:length(a)
    q_s(t,:)=binopdf(0:m,a(t),p_s);
end
% compute boundaries

for x1=0:5*N   
    X1=x1+1;
    for x2=0:sum(a)
        X2=x2+1;
        %V{20}(X1,X2)=-x1*x1*pi(1)-x2*x2*pi(2);%(a) nonliner  //penalty cost when x1 inpatients and x2 outpatients in queue
        V{20}(X1,X2)=-x1*pi(1)-x2*pi(2);%(b) %(b) linear
    end
end



% Backward Induction

 for t=N-1:-1:1
     
     for x1=0:5*(t-1) %at most 5*(t-1) inpatients in queue at the beginning of period t
         X1=x1+1;
         for x2=0:sum(a(1:t))  %at most sum(a(1:t)) outpatients in queue at the beginning of period t 
             X2=x2+1;
             
             for D0=0:3  %random emergency patients arriving in period t (they get service from period t+1 onwards)
                 %no emergency patient arrives in period N.
                 for D1=0:5  %random inpatients arriving in period t (they get service from period t+1 onwards)
                     %no inpatient arrives in period N.
                     for k=1:(a(t+1)+1) % the number of show-up outpatients arriving in period t is k-1 (they get service from period t+1 onwards).

                     for q1=0:min(m-D0,x1+D1) %allocation for inpatients at the beginning of period t+1
                          for q2=0:min(x2+k-1,m-D0-q1) %allocation for outpatients at the beginning of period t+1
                              if q1==0&&q2==0 %no facility is available for allocation
                                  H{t}{D0+1}(X1+D1,X2+k-1)=V{t+1}(X1+D1-q1,X2+k-1-q2)+r(1)*q1+r(2)*q2;
                                  s=1;
                                  policy{t+1}{D0+1}(X1+D1,X2+k-1)=s; 
                    %optimal allocation at the beginning of period t+1 with
                    %D0 emergency patients, D1 inpatients and k-1
                    %outpatients arrive in period t
                              else
                                  g=V{t+1}(X1+D1-q1,X2+k-1-q2)+r(1)*q1+r(2)*q2;
                                  if g>H{t}{D0+1}(X1+D1,X2+k-1)
                                      H{t}{D0+1}(X1+D1,X2+k-1)=g;   %find the max g() in formula (2) given D0 and D1
                                      if q1==1&&q2==0
                                          s=2;
                                      end
                                      if q1==0&&q2==1
                                          s=3;        %%% total served number <=1
                                      end
                                      if q1==2&&q2==0
                                          s=4;
                                      end
                                      if q1==1&&q2==1
                                          s=5;
                                      end
                                      if q1==0&&q2==2
                                          s=6;      %%% total served number <=2
                                      end
                                      if q1==3&&q2==0
                                          s=7;
                                      end
                                      if q1==2&&q2==1
                                          s=8;
                                      end
                                      if q1==1&&q2==2
                                          s=9;
                                      end
                                      if q1==0&&q2==3
                                          s=10;
                                      end              %%% total served number <=3==m
                                      policy{t+1}{D0+1}(X1+D1,X2+k-1)=s;
                                  end
                              end
                          end
                     end                    
                     V{t}(X1,X2)=V{t}(X1,X2)+q_s(t+1,k)*pd0(D0+1)*pd1(D1+1)*H{t}{D0+1}(X1+D1,X2+k-1); %V is max g() in formula (2)
                     end
                 end
             end
             V{t}(X1,X2)=-w(1)*x1-w(2)*x2+V{t}(X1,X2); %V is V_j in formula (1)
         end
     end
 end

 
 %display(rot90(policy{15}{2}(1:16,1:16)')); %y denotes inpatients,x denotes scheduled patients
 %A=policy{15}{2}(1:16,1:16)';
 %pcolor(A);
 
 show(policy{15}{2}(1:16,1:16)',1,m); %y denotes inpatients,x denotes scheduled patients
 
end