function [wait_in,wait_out,idle,V]=critical_service(a,InNumPerI,EmNumPerI)
  
tic;
global N m r w pi;


D1=0;
D2=0;
V=0;  %the profit from period 2 onwards
wait_in=0; %count total waiting periods for inpatients
wait_out=0; %count total waiting periods for outpatients
idle=0; %count total idle periods for facilities   

for t=2:N
    D0=EmNumPerI(t-1);  %number of emergency patients served in period t
    D1=D1+InNumPerI(t-1);  %number of inpatient in queue in period t before allocation
    D2=D2+a(t); %number of outpatient in queue in period t before allocation
    
    %%%%% if $\pi_1+r_1 +w_1>= \pi_2+r_2+w_2$, inpatients first, 
    %%%%%% if $\pi_1+r_1 +w_1< \pi_2+r_2+w_2$, outpatients-first policy.
    if pi(1)+r(1)+w(1)>=pi(2)+r(2)+w(2)
        q1=min(m-D0,D1);
        q2=min(D2,max(0,m-D0-q1));
         
    else
        q2=min(m-D0,D2);
        q1=min(D1,max(0,m-D0-q2));
    end
            
    D1=D1-q1;    %number of inpatient in queue in period t after allocation
    D2=D2-q2;    %number of outpatient in queue in period t after allocation
            
    wait_in=wait_in+D1;
    wait_out=wait_out+D2;
    idle=idle+max(0,m-q1-q2-D0);
              
    V=V+r(1)*q1+r(2)*q2-w(1)*D1-w(2)*D2;        
          
end

V=V-pi(1)*D1-pi(2)*D2;

end

