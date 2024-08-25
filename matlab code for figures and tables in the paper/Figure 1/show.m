function show(policy,D0,m)
 A=policy;
 
  %%%%when d0==0
 if D0==0 
 %A(1,:)=0;
 %A(:,1)=0;
 %A(2,1:3)=0;
 %A(1:3,2)=0;
 [I1,J1] = ind2sub(size(A),find(A<=6)); I1=I1-1;J1=J1-1;     %%% total served number <=2
 [I2,J2] = ind2sub(size(A),find(A==7)); I2=I2-1;J2=J2-1;     %%% q1==3&&q2==0
 [I3,J3] = ind2sub(size(A),find(A==8)); I3=I3-1;J3=J3-1;     %%% q1==2&&q2==1
 [I4,J4] = ind2sub(size(A),find(A==9)); I4=I4-1;J4=J4-1;     %%% q1==1&&q2==2
 [I5,J5] = ind2sub(size(A),find(A==10)); I5=I5-1;J5=J5-1;    %%% q1==0&&q2==3
 scatter(I1,J1,150,'x','k'); %
 hold on;
 scatter(I2,J2,150,'o','k'); %
 hold on;
 scatter(I3,J3,150,'o','k','filled'); %
 hold on;
 scatter(I4,J4,150,'s','k'); %
  hold on;
 scatter(I5,J5,150,'s','k','filled'); %
 
 legend('incomplete allocation','serve 3 inpatients','serve 2 inpatiets and 1 outpatients',...
     'serve 1 inpatiets and 2 outpatients','serve 3 outpatients');
 
 set(gca,'XTick',0:16);  
 set(gca,'YTick',0:16); 
 set(gca,'FontSize',14);
 %title('Sine Function');  
 xlabel('','Interpreter','latex','String','$\bar x_2$');  %$\bar x_2$ number of outpatients in queue
 ylabel('','Interpreter','latex','String','$\bar x_1$');  %$\bar x_1$ number of inpatients in queue
 
 
 %%%switch curve
 hold on;
 for i=1:length(I2)
     if ((I2(i)+J2(i)>m-D0) || (I2(i)+J2(i)==m-D0))&&(I2(i)>0)
         s=i;
         break;
     end
 end
 
 %s=1;
 %for i=2:length(I2)
  for i=(s+1):length(I2)
     if I2(i)>I2(s)
        h=line([I2(s) I2(i)],[J2(s) J2(i)],'LineWidth',2);
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        s=i;
     end
 end
text(I2(s),J2(s),'$\rightarrow x_{10}^{15,3}(\bar x_2)$','interpreter','latex','fontsize',14);
hold on;
 for i=1:length(I3)
     if ((I3(i)+J3(i)>m-D0) || (I3(i)+J3(i)==m-D0))&&(I3(i)>1)
         s=i;
         break;
     end
 end
 %s=1;
 %for i=2:length(I3)
  for i=(s+1):length(I3)
     if I3(i)>I3(s)
        h=line([I3(s) I3(i)],[J3(s) J3(i)],'LineWidth',2);
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        s=i;
     end
 end
 text(I3(s),J3(s),'$\rightarrow x_{11}^{15,3}(\bar x_2)$','interpreter','latex','fontsize',14);
 hold on;
 for i=1:length(I4)
     if ((I4(i)+J4(i)>m-D0) || (I4(i)+J4(i)==m-D0))&&(I4(i)>2)
         s=i;
         break;
     end
 end
 %s=1;
 %for i=2:length(I4)
 for i=(s+1):length(I4)
     if I4(i)>I4(s)
        h=line([I4(s) I4(i)],[J4(s) J4(i)],'LineWidth',2);
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        s=i;
     end
 end
 text(I4(s),J4(s),'$\rightarrow x_{12}^{15,3}(\bar x_2)$','interpreter','latex','fontsize',14);
   %{
 hold on;
 s=1;
 for i=2:length(I5)
     if I5(i)>I5(s)
        line([I5(s) I5(i)],[J5(s) J5(i)]);
        s=i;
     end
 end
 %}

 end
 
  %%%%when d0==1
 if D0==1 
 %A(1,:)=0;
 %A(:,1)=0;
 %A(2,1:2)=0;
 %A(1:2,2)=0;
 [I1,J1] = ind2sub(size(A),find(A<=3)); I1=I1-1;J1=J1-1;
 [I2,J2] = ind2sub(size(A),find(A==4)); I2=I2-1;J2=J2-1; 
 [I3,J3] = ind2sub(size(A),find(A==5)); I3=I3-1;J3=J3-1;
 [I4,J4] = ind2sub(size(A),find(A==6)); I4=I4-1;J4=J4-1;
 scatter(I1,J1,'x','k'); %??????
 hold on;
 scatter(I2,J2,'o','k'); %??????
 hold on;
 scatter(I3,J3,'o','k','filled'); %??????
  hold on;
 scatter(I4,J4,'s','k'); %??????

 
 legend('incomplete allocation','serve 2 outpatients','serve 1 inpatiets and 1 outpatients',...
     'serve 2 inpatients');
 set(gca,'XTick',0:16);  
 set(gca,'YTick',0:16);  
 set(gca,'FontSize',14);
 %title('Sine Function');  
 xlabel('','Interpreter','latex','String','$\bar x_2$');  
 ylabel('','Interpreter','latex','String','$\bar x_1$');  

  %%%switch curve
 %{
 hold on;
  s=1;
 for i=2:length(I2)
     if I2(i)>I2(s)
        line([I2(s) I2(i)],[J2(s) J2(i)]);
        s=i;
     end
 end
 %}
hold on; 
 for i=1:length(I2)
     if ((I2(i)+J2(i)>m-D0) || (I2(i)+J2(i)==m-D0))&&(I2(i)>0)
         s=i;
         break;
     end
 end
 %s=1;
 %for i=2:length(I3)
  for i=(s+1):length(I2)
     if I2(i)>I2(s)
        h=line([I2(s) I2(i)],[J2(s) J2(i)],'LineWidth',2);
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        s=i;
     end
 end
 text(I2(s),J2(s),'$\rightarrow x_{10}^{15,2}(\bar x_2)$','interpreter','latex','fontsize',14);
 hold on;
 for i=1:length(I3)
     if ((I3(i)+J3(i)>m-D0) || (I3(i)+J3(i)==m-D0))&&(I3(i)>1)
         s=i;
         break;
     end
 end
 %s=1;
 %for i=2:length(I4)
 for i=(s+1):length(I3)
     if I3(i)>I3(s)
        h=line([I3(s) I3(i)],[J3(s) J3(i)],'LineWidth',2);
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        s=i;
     end
 end
  text(I3(s),J3(s),'$\rightarrow x_{11}^{15,2}(\bar x_2)$','interpreter','latex','fontsize',14);
 
 end
 
 %%%%when d0==2
  if D0==2 
 %A(1,:)=0;
 %A(:,1)=0;
 [I1,J1] = ind2sub(size(A),find(A<=1)); I1=I1-1;J1=J1-1;
 [I2,J2] = ind2sub(size(A),find(A==2)); I2=I2-1;J2=J2-1; 
 [I3,J3] = ind2sub(size(A),find(A==3)); I3=I3-1;J3=J3-1;
 scatter(I1,J1,'x','k'); %??x??
 hold on;
 scatter(I2,J2,'o','k'); %??????
 hold on;
 scatter(I3,J3,'o','k','filled'); %??????
  
legend('incomplete allocation','serve 1 outpatients',...
     'serve 1 inpatients');
 set(gca,'XTick',0:16);  
 set(gca,'YTick',0:16); 
 set(gca,'FontSize',14);
 %title('Sine Function');  
 xlabel('','Interpreter','latex','String','$\bar x_2$');  
 ylabel('','Interpreter','latex','String','$\bar x_1$');  
 
   %{
 hold on;
   s=1;
 for i=2:length(I2)
     if I2(i)>I2(s)
        line([I2(s) I2(i)],[J2(s) J2(i)]);
        s=i;
     end
 end
  %} 
 hold on;
  for i=1:length(I2)
     if ((I2(i)+J2(i)>m-D0) || (I2(i)+J2(i)==m-D0))&&(I2(i)>0)
         s=i;
         break;
     end
 end
 %s=1;
 %for i=2:length(I3)
  for i=(s+1):length(I2)
     if I2(i)>I2(s)
        h=line([I2(s) I2(i)],[J2(s) J2(i)],'LineWidth',2);
        set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        s=i;
     end
 end
 text(I2(s),J2(s),'$\rightarrow x_{10}^{15,1}(\bar x_2)$','interpreter','latex','fontsize',14);
 
 
 end
 
end