function [Drew_velocity,VA,Cali_Factor,K] = LSV_V2(foldername,savefolder,capnum,trialnum)
% Calculate LS CBFV with input foldername and picture number
% Output mean velocity and angle and plots of each graph; VA: mean angle,
% mean velocity, depth; K is if there is extreme large angle occurs
%folder='C:\Users\Yifu Jin\Desktop\JYF PPT\Project\Stroke\data\1.4 aged\4.17.2021 Linescan\4.17 Linescan Analysis'

%Num=43 %number of the pictures in the folder

%Call calibration factor function column 1: FP, column 2: MP, column 3:
%depth column 4: processing sequence
folder=foldername;
%cd(folder)
filepattern=dir(fullfile(folder,'*_Ch3_*.ome.tif'));
tifFiles={filepattern.name};
%Num=length(tifFiles);
[Cali_Factor] = CF_read_V2(folder);

%Deviation Count
K=0;
%CF=xlsread('CF') %read calibration factor Time from CF excel file, T_Per Pixel, Distance (um), D_T(pixels for distance)
VA=zeros(1,3);%angle and velocity, first number is the number of the pics in the folder

%for k=1:Num
   % tiffFilename=sprintf('%d.tif',k);
    tiffFilename=tifFiles;
    fullFilename=fullfile(folder,tiffFilename);
    fullFilename=fullFilename{1};
    % if exist(fullFilename,'file')
        A=imread(fullFilename);
    % else
    %     warningMessage = sprintf('Warning: image file does not exist:\n%s', fullFilename);
    %     uiwait(warndlg(warningMessage));
    %  end

A=double(A);
normA=A; %normA is same as original figure
%normA = A - min(A(:));
%normA = normA ./ max(normA(:));
%it was found that no diff between normalized intensity and original data
%calibration of xy axis on the graph
%time 
Time=Cali_Factor(1,1);%unit s
P_T= 256; % pixels for time interval
T_Per_Pixel= Time/P_T; %unit s/pixel
%distance

D_Per_Pixel=Cali_Factor(1,2); %unit um/pixel
%calibration value
Cali=D_Per_Pixel/T_Per_Pixel; %unit um/s

%manually calculate the velocity near the peak point
[theta,the_t,spread_radon32]=GetVelocityRadonFig_demo(normA,32);
%theta=medfilt1(theta,7)
%[points,angle,velocity,V_avg,Theta_avg] = angle_velocity(normA);
T_points=linspace(0,Time,length(the_t));
%M_V_avg=V_avg.*ones(1,T_points);% manual velocity average
%M_Theta_avg=Theta_avg.*ones(1,T_points);%manual angle average
Drew_velocity=double(abs(cotd(theta)).*Cali);%drew velocity after calibration
Drew_velocity(Drew_velocity==Inf)=nan;
%Drew_velocity=medfilt1(Drew_velocity,5)
Drew_Angle=abs(theta);
D_Theta_avg=mean(theta);%drew angle
Drew_Angle_m=abs(D_Theta_avg); % angle average


Drew_CBFV_m=nanmean(Drew_velocity); % CBFV average
Drew_Angle_std=std(theta); %angle std
Drew_CBFV_std=nanstd(Drew_velocity); % CBF Velocity std



%If Velocity > 3 std then use larger window for calculation 64 lines
if  max(abs(Drew_velocity-Drew_CBFV_m))>2*Drew_CBFV_std;
   [theta,the_t,spread_radon64]=GetVelocityRadonFig_demo(normA,64);
   K=K+1;
   %theta=medfilt1(theta,3)
T_points=linspace(0,Time,length(theta));
%recalculate the mean std of angle and CBFV
Drew_velocity=double(abs(cotd(theta)).*Cali);%drew velocity after calibration
Drew_velocity(Drew_velocity==Inf)=nan; % get rid of infinity angle
Drew_velocity(Drew_velocity<0.1)=nan;
s=nanstd(Drew_velocity);
m=nanmean(Drew_velocity);
Drew_velocity(abs(Drew_velocity-m)>2*s)=nan;
%Drew_velocity=medfilt1(Drew_velocity,5)
Drew_Angle=abs(theta);
D_Theta_avg=mean(theta);%drew angle
Drew_Angle_m=abs(D_Theta_avg); % angle average


Drew_CBFV_m=nanmean(Drew_velocity); % CBFV average
Drew_Angle_std=std(theta); %angle std
Drew_CBFV_std=nanstd(Drew_velocity); % CBF Velocity std
%CBFV=Drew_velocity;
%CBFV_avg=Drew_CBFV_m;
%Drew_CBFV_m=mean(Drew_velocity); % CBFV average
%Drew_Angle_std=std(the_t); %angle std
%Drew_CBFV_std=std(Drew_velocity); % CBF Velocity std

%filter of large noise
%if max(abs(Drew_velocity-Drew_CBFV_m))>2*Drew_CBFV_std;
%[pt,ag,velocity,V_avg,Theta_avg] = angle_velocity(normA)
%Drew_CBFV_m=V_avg*Cali
%end

end
%store angle and velocity average in the VA matrix
VA(1,1)=Drew_Angle_m;VA(1,2)=Drew_CBFV_m;


% drew code calculation results
fig=figure
subplot(311);
imagesc(normA')%plots the artificial 'linescan';
nlines=size(normA,1);
npoints=size(normA,2);
colormap gray

subplot(312)%angle
plot(T_points,Drew_Angle,'r');% plots the angle at any given time point
xlim([0 Time]);
ylabel('angle');
ylim([0 80]);
hold on
plot(T_points,abs(Drew_Angle_m.*ones(size(the_t,1),1)),'g');
%hold on
%plot(the_t,abs(M_Theta_avg),'b'); %plot manual measure angle average 
legend('calculated angle','calculated angle average');
%legend('calculated angle','calculated angle average','manually measured angle average')


subplot(313)%velocity with unit 
plot(T_points,Drew_velocity,'r');%plot velocity vs time
xlabel('time');
ylabel('|velocity| um/s');
xlim([0 Time]);
hold on
plot(T_points,Drew_CBFV_m*ones(size(the_t,1),1),'g');
%hold on
%plot(the_t,Cali*M_V_avg,'b'); %plot manual measure velocity average
legend('calculated velocity','calculated velocity average');
%legend('calculated velocity','calculated velocity average','manually measured velocity average')
%calculate the angle and velocity manually



%save figure 

%saveas(fig,fullfile(savefolder,sprintf('capillary%d.fig',capnum)));
figname=['capillary',num2str(capnum),' ','trial',num2str(trialnum),' ','CBFV'];
%saveas(fig,fullfile(savefolder,sprintf('capillary %d.jpg',capnum)));
saveas(fig,fullfile(savefolder,figname));
%close figure
close all

%end
VA(:,3)=[Cali_Factor(:,3)]; %depth where capillaries lie
%write angle and velocity to a excel file
%xlswrite('drew angle and velocity',VA);

%save('Angle Velocity','VA');
%Plot Depth vs CBFV
% fig2=figure
% scatter([Cali_Factor{:,3}],VA(:,2));
% title('Depth vs CBFV');
% xlabel('Depth(μm)');
% ylabel('CBFV(μm/s)');
% saveas(fig2,sprintf('Depth vs CBFV'));

end

