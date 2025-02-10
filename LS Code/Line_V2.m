clc;
clear;
close all;
folder='C:\Users\Yifu Jin\Desktop\JYF PPT\Project\Stroke\data\1.4 aged\4.17.2021 Linescan\4.17 Linescan Analysis'

Num=43 %number of the pictures in the folder
CF=xlsread('CF') %read calibration factor Time from CF excel file, T_Per Pixel, Distance (um), D_T(pixels for distance)
VA=zeros(Num,2)%angle and velocity, first number is the number of the pics in the folder

for k=1:Num
    tiffFilename=sprintf('%d.tif',k);
    fullFilename=fullfile(folder,tiffFilename);
    if exist(fullFilename,'file')
        A=imread(fullFilename);
    else
        warningMessage = sprintf('Warning: image file does not exist:\n%s', fullFilename);
        uiwait(warndlg(warningMessage));
     end

A=double(A);
normA = A - min(A(:));
normA = normA ./ max(normA(:));
%calibration of xy axis on the graph
%time 
Time=CF(k,1);%unit s
P_T= 256; % pixels for time interval
T_Per_Pixel= Time/P_T %unit s/pixel
%distance

D_Per_Pixel=CF(k,2); %unit um/pixel
%calibration value
Cali=D_Per_Pixel/T_Per_Pixel %unit um/s

%manually calculate the velocity near the peak point
[theta,the_t,spread_radon32]=GetVelocityRadonFig_demo(normA,32);
%[points,angle,velocity,V_avg,Theta_avg] = angle_velocity(normA);
T_points=size(the_t,1);
%M_V_avg=V_avg.*ones(1,T_points);% manual velocity average
%M_Theta_avg=Theta_avg.*ones(1,T_points);%manual angle average
D_velocity=abs(cotd(theta));%drew velocity before calibration
D_V_avg=mean(D_velocity);%drew velocity average before calibration
D_Theta_avg=mean(theta);%drew angle
%store angle and velocity average in the VA matrix
VA(k,1)=abs(D_Theta_avg);
VA(k,2)=D_V_avg*Cali;


% drew code calculation results
fig=figure
subplot(311)
imagesc(normA')%plots the artificial 'linescan'
nlines=size(normA,1)
npoints=size(normA,2)
colormap gray



subplot(312)%angle
plot(the_t,abs(theta),'r')% plots the angle at any given time point
xlim([0 nlines])
ylabel('angle')
ylim([0 80])
hold on
plot(the_t,abs(D_Theta_avg.*ones(size(the_t,1),1)),'g');
%hold on
%plot(the_t,abs(M_Theta_avg),'b'); %plot manual measure angle average 
legend('calculated angle','calculated angle average')
%legend('calculated angle','calculated angle average','manually measured angle average')


subplot(313)%velocity with unit 
plot(the_t,Cali*D_velocity,'r')%plot velocity vs time
xlabel('time')
ylabel('|velocity| um/s')
hold on
plot(the_t,Cali*D_V_avg*ones(size(the_t,1),1),'g');
%hold on
%plot(the_t,Cali*M_V_avg,'b'); %plot manual measure velocity average
legend('calculated velocity','calculated velocity average')
%legend('calculated velocity','calculated velocity average','manually measured velocity average')
%calculate the angle and velocity manually



%save figure 
saveas(fig,sprintf('fig%d.fig',k));
saveas(fig,sprintf('fig%d.jpg',k));
%close figure
close(fig)
end
%write angle and velocity to a excel file
xlswrite('drew angle and velocity',VA)