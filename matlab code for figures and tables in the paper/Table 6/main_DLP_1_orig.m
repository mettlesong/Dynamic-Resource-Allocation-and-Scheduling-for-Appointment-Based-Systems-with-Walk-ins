%function main_DLP_1_orig

% Problem data
N=10;
m=2;
%D0=[0 1 2 3]; % emergency patients number
pd0=[0.5 0.3 0.2]; % emergency patients arrival probability
%D1=[0 1 2 3 4 5];  % inpatients number
%pd01=[0.5 0.3 0.12 0.08];%%%for j=9,10,11 nonstationary arrival%%%
pd1=[0.4 0.3 0.2 0.1]; % inpatients arrival probability

r_1=90;
%r_1=[200,800];
r_2=80;
w_1=10;
%w_2=[20,40];
w_2=20;
%pi_1=[500,1000];
pi_1=30;
pi_2=50;
theta_v=100000;

m0=length(theta_v);
m1=length(r_1);
m2=length(w_2);
m3=length(pi_1);

gap=zeros(m0,m1,m2,m3,3);
for i0=1:m0
    theta=theta_v(i0);
    pd0_theta=pd0;
    for i=2:theta
        pd0_theta=conv(pd0_theta,pd0);
    end

    pd1_theta=pd1;
    for i=2:theta
        pd1_theta=conv(pd1_theta,pd1);
    end

    for i1=1:m1
        r=[r_1(i1) r_2];
        for i2=1:m2
            w=[w_1 w_2(i2)];
            for i3=1:m3
                pi=[pi_1(i3) pi_2];
                
                [DLP_bar_vf,DLP_allocation,DLP_scheduling,bar_k] = DLP(N,m,r,w,pd0,pd1,pi,theta);
                
                %[VF_DLP_heu_new] = DLP_heu_new_orig(N,m,r,w,pd0_theta,pd1_theta,pi,theta,DLP_allocation,DLP_scheduling,bar_k);
                [VF_DLP_heu_simu_new] = DLP_heu_simu_new_orig(N,m,r,w,pd0,pd1,pi,theta,DLP_allocation,DLP_scheduling,bar_k);

                %[v_HS_simple,~]=get_V_HS_simple_linear(N,m,r,w,pd0_theta,pd1_theta,pi,theta);
                %[v_VS_simple,~]=get_V_VS_simple_linear(N,m,r,w,pd0_theta,pd1_theta,pi,theta);

                %gap(i0,i1,i2,i3,1)=100*(DLP_bar_vf-VF_DLP_heu_new)/DLP_bar_vf;
                gap(i0,i1,i2,i3,1)=100*(DLP_bar_vf-VF_DLP_heu_simu_new)/DLP_bar_vf;

                %gap(i0,i1,i2,i3,2)=100*(DLP_bar_vf-v_HS_simple)/DLP_bar_vf;
                %gap(i0,i1,i2,i3,3)=100*(DLP_bar_vf-v_VS_simple)/DLP_bar_vf;

            end
        end
    end
end

gap
%end