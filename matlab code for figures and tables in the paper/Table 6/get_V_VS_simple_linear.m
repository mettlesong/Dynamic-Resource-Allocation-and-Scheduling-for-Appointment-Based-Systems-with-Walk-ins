function [v_VS_simple,s_star_simple]=get_V_VS_simple_linear(N,m,r,w,pd0_theta,pd1_theta,pi,theta)

%penalty function is linear
%pd0_theta/pd1_theta is the (sum)convolution of theta i.i.d pd0/pd1
tic;
v_VS_simple=0;

L0_theta=length(pd0_theta);
L1_theta=length(pd1_theta);

for s_num=0:N*m
    a=zeros(1,N);
    A=VS(m,N,s_num);
    for i=1:N
        a(i)=sum(A(1:m,i))*theta;  % the total number of scheduled outpatients of each slot
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

    V_2=zeros((L1_theta-1)*N+1,sum(a)+1); 


    % compute boundaries

    for x1=0:(L1_theta-1)*N
        X1=x1+1;
        for x2=0:sum(a)
            X2=x2+1;
            %V{N}(X1,X2)=-x1*x1*pi(1)-x2*x2*pi(2);%(a) nonliner
            V_2(X1,X2)=-x1*pi(1)-x2*pi(2);%(b) %(b) linear
        end
    end
    
    
    % Backward Induction

    for t=N-1:-1:1
        V_1=zeros((L1_theta-1)*N+1,sum(a)+1); 

        for x1=0:(L1_theta-1)*(t-1) %at most (L1_theta-1)*(t-1) inpatients in queue at the beginning of period t
            X1=x1+1;
            for x2=0:sum(a(1:t))  %at most sum(a(1:t)) outpatients in queue at the beginning of period t 
                X2=x2+1;
             
                for D0=0:(L0_theta-1)  %random emergency patients arriving in period t (they get service from period t+1 onwards)
                    %no emergency patient arrives in period N.
                    for D1=0:(L1_theta-1)  %random inpatients arriving in period t (they get service from period t+1 onwards)
                        %no inpatient arrives in period N.
                        if (pi(1)+r(1) > pi(2)+r(2)) && (w(1) > w(2))
                            q1=min(theta*m-D0,x1+D1);
                            q2=min(max(theta*m-D0-(x1+D1),0),x2+a(t+1));
                            g_final=V_2(X1+D1-q1,X2+a(t+1)-q2)+r(1)*q1+r(2)*q2;
                        elseif (pi(1)+r(1) < pi(2)+r(2)) && (w(1) < w(2))
                            q1=min(max(theta*m-D0-(x2+a(t+1)),0),x1+D1);
                            q2=min(theta*m-D0,x2+a(t+1));
                            g_final=V_2(X1+D1-q1,X2+a(t+1)-q2)+r(1)*q1+r(2)*q2;
                        else
                            for q1=0:min(theta*m-D0,x1+D1) %allocation for inpatients at the beginning of period t+1
                                for q2=0:min(x2+a(t+1),theta*m-D0-q1) %allocation for outpatients at the beginning of period t+1
                                    if q1==0&&q2==0 %no facility is available for allocation
                                        g_final=V_2(X1+D1-q1,X2+a(t+1)-q2)+r(1)*q1+r(2)*q2;
                       %optimal allocation at the beginning of period t+1 with D0 emergency patients, D1 inpatients and a(t+1)
                       %outpatients arrive in period t
                                    else
                                        g=V_2(X1+D1-q1,X2+a(t+1)-q2)+r(1)*q1+r(2)*q2;
                                        if g>g_final
                                            g_final=g;   %find the max g() in formula (2) given D0 and D1
                                        end
                                    end
                                end
                            end
                        end
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
    end

  
    if V_1(1,1)>=v_VS_simple  %%%find optimal value and schedule number. Note that the profit is calcuated from period 2 onwards.
        v_VS_simple=V_1(1,1);
        s_star_simple=s_num;     
    end
          
end


end