clc;
clear;
close all;


folder ='E:\2021-07-07-aged\2021-08-18'
cd(folder)
PicNum=28;
tiffFilename=sprintf('%d.tif',PicNum);
A=imread(tiffFilename);
A=double(A);
normA = A - min(A(:));
normA = normA ./ max(normA(:));
%calibration of xy axis on the graph
%time 
[Cali_Factor] = CF_read(folder)
Time=Cali_Factor{PicNum,1};%unit s
P_T= 256; % pixels for time interval
T_Per_Pixel= Time/P_T %unit s/pixel
%distance

D_Per_Pixel=Cali_Factor{PicNum,2}; %unit um/pixel
%calibration value
Cali=D_Per_Pixel/T_Per_Pixel %unit um/s

%manually calculate the velocity near the peak point
[theta,the_t,spread_radon32]=GetVelocityRadonFig_demo(normA,32);
[points,angle,velocity,V_avg,Theta_avg] = angle_velocity(normA);
T_points=size(the_t,1);
M_V_avg=V_avg;% manual velocity average
M_Theta_avg=Theta_avg.*ones(1,T_points);%manual angle average

% drew code calculation results
figure(1)
subplot(311)
imagesc(normA')%plots the artificial 'linescan'
nlines=size(normA,1)
npoints=size(normA,2)
colormap gray

D_velocity=abs(cotd(theta));
D_V_avg=mean(D_velocity);
D_Theta_avg=mean(theta);
subplot(312)%angle
plot(the_t,abs(theta),'r')% plots the angle at any given time point
xlim([0 nlines])
ylabel('angle')
ylim([0 80])
hold on
plot(the_t,abs(D_Theta_avg.*ones(size(the_t,1),1)),'g');
hold on
plot(the_t,abs(M_Theta_avg),'b'); %plot manual measure angle average 

legend('calculated angle','calculated angle average','manually measured angle average')

M_V=Cali*M_V_avg
subplot(313)%velocity with unit 
plot(the_t,Cali*D_velocity,'r')%plot velocity vs time
xlabel('time')
ylabel('|velocity| um/s')
hold on
plot(the_t,M_V*ones(size(the_t,1),1),'b');
hold on
plot(the_t,Cali*D_V_avg*ones(size(the_t,1),1),'g'); %plot manual measure velocity average
legend('calculated velocity','manually measured velocity average','calculated velocity average')
%calculate the angle and velocity manually




