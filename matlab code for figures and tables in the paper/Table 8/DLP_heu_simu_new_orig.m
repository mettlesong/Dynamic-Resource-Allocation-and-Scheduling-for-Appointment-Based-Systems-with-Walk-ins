function [VF_DLP_heu_simu_new] = DLP_heu_simu_new_orig(N,m,r,w,pd0,pd1,pi,theta,DLP_allocation,DLP_scheduling,bar_k)
%DLP_THETA_HEURISTIC provides a lower bound for the value function
%
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

%simulation_num=N*m*length(pd0)*length(pd1)*100;
%simulation_num=1;
%VF_sample=zeros(1,simulation_num);
%for count=1:simulation_num

test_interval=10^(-3);
data=zeros(1,1000);
count=0; %measure the data size
conf_interval=1;
while conf_interval>test_interval
    count=count+1;
    VF=0;

%特定概率分布生成数据 a = randsrc(m,n,[V; P]); a为大小为m*n的矩阵,V为随机数的范围,P为概率分布。 例:a = randsrc(1,10,[1,2,3; 1/3,1/3,1/3]); 
%generate random arrivals for all settings and all slots
    rand_d0=randsrc(theta,N-1,[0:1:(length(pd0)-1);pd0]);
    rand_d1=randsrc(theta,N-1,[0:1:(length(pd1)-1);pd1]);

    rand_scheduling=zeros(theta,N);
    rand_allocation_1=zeros(theta,N);
    %rand_allocation_2=zeros(theta,N);
    %pd_a=zeros(2,N);
    %pd_1=zeros(2,N);

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

    %sum_DLP_allocation=theta*DLP_allocation;  %total allocation across all settings for a given slot <under deterministic model>
    sum_slot=zeros(1,N);  %total available slots (after serving type-0 customers) across all settings for a given slot <under stochastic model>
    %sum_DLP_x12=zeros(2,N); %total allocation for type-1/2 customers across all settings up to slot j <under stochastic model>
    %rand_sum_d1=zeros(1,N); %total random demand for type-1 customers across all settings up to slot j <under stochastic model>
    DLP_Heuristic_allocation=zeros(2,1); % total allocation across all settings for a given slot <under stochastic model>
    queue12=zeros(2,N); %total waiting type-1/2 customers across all settings at beginning of slot j before decision <under stochastic model>
    for j=2:N
        %sum_DLP_allocation(1,j)=theta*DLP_allocation(1,j); % first term in inequality (29) of paper
        %sum_DLP_allocation(2,j)=theta*DLP_allocation(2,j); % second term in inequality (29) of paper
        sum_slot(j)=theta*m-sum(rand_d0(1:theta,j-1)); %RHS of inequality (29) of paper

        if j==2
            %sum_DLP_x12(1,j)=sum_DLP_allocation(1,j);  %LHS of inequality (30) in paper
            %sum_DLP_x12(2,j)=sum_DLP_allocation(2,j);  %LHS of inequality (31) in paper
            queue12(1,j)=sum(rand_d1(1:theta,j-1));
            queue12(2,j)=sum(rand_scheduling(1:theta,j));
        else
            %sum_DLP_x12(1,j)=sum(DLP_Heuristic_allocation(1,2:j-1))+sum_DLP_allocation(1,j);  %LHS of inequality (30) in paper
            %sum_DLP_x12(2,j)=sum(DLP_Heuristic_allocation(2,2:j-1))+sum_DLP_allocation(2,j);  %LHS of inequality (31) in paper
            queue12(1,j)=queue12(1,j-1)+sum(rand_d1(1:theta,j-1))-DLP_Heuristic_allocation(1); %DLP_Heuristic_allocation(1):allocation of type-1 customers in period j-1
            queue12(2,j)=queue12(2,j-1)+sum(rand_scheduling(1:theta,j))-DLP_Heuristic_allocation(2); %DLP_Heuristic_allocation(2):allocation of type-2 customers in period j-1

        end
        %rand_sum_d1(j)=sum(sum(rand_d1(1:theta,1:j-1)));   % RHS of inequality (30) in paper

        %note that inequality (31) always holds in the stochastic model
        if j>bar_k  %allocate outpatients first %DLP_Heuristic_allocation(1/2):allocation of type-1/2 customers in period j
            DLP_Heuristic_allocation(2) = min(sum(rand_allocation_2(1:theta,j)),min(queue12(2,j),sum_slot(j)));
            DLP_Heuristic_allocation(1) = min(sum(rand_allocation_1(1:theta,j)),min(queue12(1,j),sum_slot(j)-DLP_Heuristic_allocation(2)));
        else        %allocate inpatients first
            DLP_Heuristic_allocation(1) = min(sum(rand_allocation_1(1:theta,j)),min(queue12(1,j),sum_slot(j)));
            DLP_Heuristic_allocation(2) = min(sum(rand_allocation_2(1:theta,j)),min(queue12(2,j),sum_slot(j)-DLP_Heuristic_allocation(1)));
        end
        VF=VF+r(1)*DLP_Heuristic_allocation(1)+r(2)*DLP_Heuristic_allocation(2)+((N-j)*w(1)+pi(1))*(DLP_Heuristic_allocation(1)-sum(rand_d1(1:theta,j-1)))+((N-j)*w(2)+pi(2))*(DLP_Heuristic_allocation(2)-sum(rand_scheduling(1:theta,j)));
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
VF_DLP_heu_simu_new=mean(data(1:count));

%queue12
end



