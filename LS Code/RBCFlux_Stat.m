%RBC flux algorithm vs manual
clc;
clear;
close all;
RC=xlsread('RBC number and flux');
Al_rbcNum=RC(1,:); %RBCnumber by Al
Al_rbcFlux=RC(2,:);%RBC FLUX by Al
M_RBC_Num=RC(3,:);%RBCnumber by hand
M_RBC_Flux=RC(4,:);%RBCflux by hand

%Error Bar
figure
subplot(1,2,1)
x=categorical({'Algorithm RBC number','Manual RBC number'});
x=reordercats(x,{'Algorithm RBC number','Manual RBC number'});
y=[mean(RC(1,:)) mean(RC(3,:))]
bar(x,y)
hold on
er_num_Al=std(RC(1,:))
er_num_M=std(RC(3,:))
er_1=[er_num_Al er_num_M]
errorbar(x,y,er_1,er_1)

subplot(1,2,2)
X=categorical({'Algorithm RBC Flux','Manual RBC FluX'});

Y=[mean(RC(2,:)) mean(RC(4,:))]
bar(X,Y)
hold on
er_flux_Al=std(RC(2,:))
er_flux_M=std(RC(4,:))
er_2=[er_flux_Al er_flux_M]
errorbar(X,Y,er_2,er_2)

%T Test
[h_num,p_num]=ttest2(Al_rbcNum,M_RBC_Num)
[h_flux,p_flux]=ttest2(Al_rbcFlux,M_RBC_Flux)