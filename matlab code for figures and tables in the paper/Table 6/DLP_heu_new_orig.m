function [VF_DLP_heu_new] = DLP_heu_new_orig(N,m,r,w,pd0_theta,pd1_theta,pi,theta,DLP_allocation,DLP_scheduling,bar_k)
%pd0_theta/pd1_theta is the (sum)convolution of theta i.i.d pd0/pd1
tic;

%VF_DLP_heu_new=0;
L0_theta=length(pd0_theta);
L1_theta=length(pd1_theta);
%test_number=N*m;

Floor_DLP_scheduling=zeros(1,N);
Ceil_DLP_scheduling=zeros(1,N);
q_a=zeros(1,N);

Floor_DLP_allocation_1=zeros(1,N);   %向下取整
Ceil_DLP_allocation_1=zeros(1,N);   %向上取整
q_1=zeros(1,N);

for j=1:N

    Floor_DLP_scheduling(j)=floor(DLP_scheduling(j));
    Ceil_DLP_scheduling(j)=ceil(DLP_scheduling(j));
    q_a(j)=DLP_scheduling(j)-Floor_DLP_scheduling(j);

    Floor_DLP_allocation_1(j)=floor(DLP_allocation(1,j));
    Ceil_DLP_allocation_1(j)=ceil(DLP_allocation(1,j));
    q_1(j)=DLP_allocation(1,j)-Floor_DLP_allocation_1(j);
    %Floor_DLP_allocation(2,j)=floor(DLP_allocation(2,j));
    %Ceil_DLP_allocation(2,j)=ceil(DLP_allocation(2,j));
    %q_1(2,j)=DLP_allocation(2,j)-Floor_DLP_allocation(2,j);

end
    %V = cell(N,1);
    %for i=1:N
    %    V{i} = zeros((L1_theta-1)*N+1,sum(a)+1); %at most (L1_theta-1)*N inpatients in queue, at most sum(a) outpatients in queue
    %end

    %H = cell(N,L0_theta);  % each slot, each possible emergency patients number(0 1 2 (L0_theta-1)) //H is function g in formula (2)
    %for i=1:N
    %    for j=1:L0_theta
    %    H{i}{j}=zeros((L1_theta-1)*N+1,sum(a)+1);
    %    end
    %end
%for k=1:test_number
%{
test_interval=10^(-2);
data=zeros(1,1000);
count=0; %measure the data size
conf_interval=1;
v=1:1:theta;
while conf_interval>test_interval
    count=count+1;
    VF=0;
%}
    rand_scheduling=zeros(theta,N);
    rand_allocation_1=zeros(theta,N);
    %{
    rand_allocation_2=zeros(theta,N);
    pd_a=zeros(2,N);
    pd_1=zeros(2,N);
    %}
    v=1:1:theta;
    for j=2:N
        m_a_j=theta*(1-(DLP_scheduling(j)-Floor_DLP_scheduling(j)));
        if (m_a_j-floor(m_a_j))<0.5
            m_a_j=floor(m_a_j);
        else
            m_a_j=floor(m_a_j)+1;
        end

        m_x1_j=theta*(1-(DLP_allocation(1,j)-Floor_DLP_allocation_1(j)));
        if (m_x1_j-floor(m_x1_j))<0.5
            m_x1_j=floor(m_x1_j);
        else
            m_x1_j=floor(m_x1_j)+1;
        end

        num_lower_a_j=sort(v(randperm(numel(v),m_a_j)));
        num_lower_x1_j=sort(v(randperm(numel(v),m_x1_j)));

        rand_scheduling(:,j)=Ceil_DLP_scheduling(j)*ones(theta,1);
        column_a=j*ones(1,m_a_j);
        rand_scheduling(sub2ind(size(rand_scheduling), num_lower_a_j, column_a))=Floor_DLP_scheduling(j);

        rand_allocation_1(:,j)=Ceil_DLP_allocation_1(j)*ones(theta,1);
        column_x1=j*ones(1,m_x1_j);
        rand_allocation_1(sub2ind(size(rand_allocation_1), num_lower_x1_j, column_x1))=Floor_DLP_allocation_1(j);


        %rand_scheduling(:,j)=randsrc(theta,1,[[Floor_DLP_scheduling(j),Ceil_DLP_scheduling(j)];[1-q_a(j),q_a(j)]]);
        %rand_allocation_1(:,j)=randsrc(theta,1,[[Floor_DLP_allocation_1(j),Ceil_DLP_allocation_1(j)];[1-q_1(j),q_1(j)]]);
    end
    rand_allocation_2=rand_scheduling;


    V_2=zeros((L1_theta-1)*N+1,sum(rand_scheduling,'all')+1); 


    % compute boundaries

for x1=0:(L1_theta-1)*N
    X1=x1+1;
    for x2=0:sum(rand_scheduling,'all')
        X2=x2+1;
        %V{N}(X1,X2)=-x1*x1*pi(1)-x2*x2*pi(2);%(a) nonliner
        V_2(X1,X2)=-x1*pi(1)-x2*pi(2);%(b) %(b) linear
    end
end
    
    
    % Backward Induction

for t=N-1:-1:1
    %V_1=zeros((L1_theta-1)*N+1,sum(rand_scheduling,'all')+1); 
    V_1=zeros((L1_theta-1)*(t-1)+1,sum(sum(rand_scheduling(1:theta,1:t)))+1); 
    for x1=0:(L1_theta-1)*(t-1) %at most (L1_theta-1)*(t-1) inpatients in queue at the beginning of period t after decision
        X1=x1+1;
        for x2=0:sum(sum(rand_scheduling(1:theta,1:t)))  %at most sum(a(1:t)) outpatients in queue at the beginning of period t after decision
            X2=x2+1;
             
            for D0=0:(L0_theta-1)  %random emergency patients arriving in period t (they get service from period t+1 onwards)
                    %no emergency patient arrives in period N.
                for D1=0:(L1_theta-1)  %random inpatients arriving in period t (they get service from period t+1 onwards)
                        %no inpatient arrives in period N.
                    if (t+1)>bar_k   %optimal allocation in period t+1
                        q2=min(min(theta*m-D0,x2+sum(rand_scheduling(1:theta,t+1))),sum(rand_allocation_2(1:theta,t+1)));
                        q1=min(min(theta*m-D0-q2,x1+D1),sum(rand_allocation_1(1:theta,t+1)));
                    else
                        q1=min(min(theta*m-D0,x1+D1),sum(rand_allocation_1(1:theta,t+1)));
                        q2=min(min(theta*m-D0-q1,x2+sum(rand_scheduling(1:theta,t+1))),sum(rand_allocation_2(1:theta,t+1)));
                    end
                    g_final=V_2(X1+D1-q1,X2+sum(rand_scheduling(1:theta,t+1))-q2)+r(1)*q1+r(2)*q2;  
                        %%%%%stationary arrival%%%%%
                    V_1(X1,X2)=V_1(X1,X2)+pd0_theta(D0+1)*pd1_theta(D1+1)*g_final;
          
                        %%%%nonstationary arrival%%%%%
                        %if t==9||t==10||t==11
                        %   V{t}(X1,X2)=V{t}(X1,X2)+pd01(D0+1)*pd1(D1+1)*H{t}{D0+1}(X1+D1,X2+a(t+1));   
                        %else
                        %   V{t}(X1,X2)=V{t}(X1,X2)+pd0(D0+1)*pd1(D1+1)*H{t}{D0+1}(X1+D1,X2+a(t+1));
                        %end
                end
            end
            V_1(X1,X2)=-w(1)*x1-w(2)*x2+V_1(X1,X2);
        end
    end      
    V_2=V_1;
    %V_1
end

VF_DLP_heu_new=V_1(1,1); 

    %{
    if V_1(1,1)>=VF  %%%find optimal value and schedule number. Note that the profit is calcuated from period 2 onwards.
        VF=V_1(1,1); 
    end
    
    data(count)=VF;
    conf_interval=confidence_interval(data(1:count));
    if count==1
        conf_interval=1;
    else
        conf_interval=conf_interval/mean(data(1:count));
    end
    %VF_DLP_heu_new=VF_DLP_heu_new+VF;        
end
%VF_DLP_heu_new=VF_DLP_heu_new/test_number;
VF_DLP_heu_new=mean(data(1:count));
end
    %}
