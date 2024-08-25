%function main_DLP_1_orig

% Problem data
N=10;
m=2;
%D0=[0 1 2 3]; % emergency patients number
pd0=[0.5 0.3 0.2]; % emergency patients arrival probability
%pd0=[0.8 0.15 0.05]; % emergency patients arrival probability
%D1=[0 1 2 3 4 5];  % inpatients number
%pd01=[0.5 0.3 0.12 0.08];%%%for j=9,10,11 nonstationary arrival%%%
pd1=[0.4 0.3 0.2 0.1]; % inpatients arrival probability
%pd1=[0.7 0.2 0.1 0];

r_1=90;
%r_1=[200,800];
r_2=80;
w_1=10;
%w_2=[20,40];
w_2=20;
%pi_1=[500,1000];
pi_1=30;
pi_2=50;

theta=5;
y=m:(m*N);

gap=zeros(3,length(y));
sum_scheduling=zeros(1,length(y));
vec_DLP_bar_vf=zeros(1,length(y));
vec_v_HS=zeros(1,length(y));
vec_v_VS=zeros(1,length(y));
vec_VF_DLP_heu=zeros(1,length(y));

pd0_theta=pd0;
for i=2:theta
    pd0_theta=conv(pd0_theta,pd0);
end

pd1_theta=pd1;
for i=2:theta
    pd1_theta=conv(pd1_theta,pd1);
end

r=[r_1 r_2];
w=[w_1 w_2];
pi=[pi_1 pi_2];

[vec_v_HS_simple,v_HS_star_simple,s_HS_star_index]=get_V_HS_simple_linear(N,m,r,w,pd0_theta,pd1_theta,pi,theta,y);
vec_v_HS(1:s_HS_star_index)=vec_v_HS_simple(1:s_HS_star_index);
vec_v_HS(s_HS_star_index:length(y))=v_HS_star_simple;

[vec_v_VS_simple,v_VS_star_simple,s_VS_star_index]=get_V_VS_simple_linear(N,m,r,w,pd0_theta,pd1_theta,pi,theta,y);
vec_v_VS(1:s_VS_star_index)=vec_v_VS_simple(1:s_VS_star_index);
vec_v_VS(s_VS_star_index:length(y))=v_VS_star_simple;
                
for num=1:length(y)
    [DLP_bar_vf,DLP_allocation,DLP_scheduling,bar_k] = DLP(N,m,r,w,pd0,pd1,pi,theta,y(num));
    sum_scheduling(num)=sum(DLP_scheduling);
    vec_DLP_bar_vf(num)=DLP_bar_vf;
                
    [vec_VF_DLP_heu(num)] = DLP_heu_new_orig(N,m,r,w,pd0_theta,pd1_theta,pi,theta,DLP_allocation,DLP_scheduling,bar_k);
    %[vec_VF_DLP_heu(num)] = DLP_heu_simu_new_orig(N,m,r,w,pd0,pd1,pi,theta,DLP_allocation,DLP_scheduling,bar_k);

    gap(1,num)=100*(DLP_bar_vf-vec_VF_DLP_heu(num))/DLP_bar_vf;
    gap(2,num)=100*(DLP_bar_vf-vec_v_HS(num))/DLP_bar_vf;
    gap(3,num)=100*(DLP_bar_vf-vec_v_VS(num))/DLP_bar_vf;

end

sum_scheduling
vec_DLP_bar_vf
vec_VF_DLP_heu
vec_v_HS
vec_v_VS
gap
%end