%%update 2023-09-26: involve of more trials for each capillary 
%% Organize data in the structure: 
%%close all, clear variables, add processing code path
clc;clear;close all
addpath(genpath('Z:\xl_stroke\yifu_2P\Processing Script\LS Code'));
%lsfolder='D:\2P 2021\9.2 aged Linescan\PV_4'
%savefolder='D:\2P 2021\9.2 aged Linescan\PV_4'
sessionList=dir;
sessionName={sessionList.name};
sessionInUse=cellfun(@(y) y(1)=='2',sessionName);%list of session in use, true false ve4ctor
sessionList=sessionList(sessionInUse);% structure with date start with 2

%make folder for save figures and processed data
%save as: processed > session > close & far capillaries 
processed_folder=fullfile(pwd,'processed');
if ~exist(processed_folder)
mkdir(processed_folder);
end
%%
for i=1:numel(sessionList)
date_folder=[pwd '\' sessionList(i).name];
dis_type=dir(date_folder);
dis_type_name={dis_type.name};% distance far and close
dis_type_name(1:2)=[];
for dis=1:numel(dis_type_name)
disfolder=fullfile(date_folder,dis_type_name{dis}); %far and close capillaries
capi_list=dir(disfolder);
capi_name={capi_list.name};
capi_name(1:2)=[];
strcol=size(strsplit(capi_name{1},'-'),2);
capi_name_list=cell(numel(capi_name),strcol);
capi_elenum=zeros(1,strcol); %capillary number
capi_group=zeros(numel(capi_name),strcol); %capillary grouping
%depth preallo
%cali_info=[];
%sort all data to different capillary in different trials
%make folder for save: session > distance type
savefolder=fullfile(processed_folder,sessionList(i).name,dis_type_name{dis});
if~exist(savefolder)
mkdir(savefolder);
end

for k=1:numel(capi_name)
capi_name_list(k,:)=strsplit(capi_name{k},'-'); %all split string
end

%locate the first column containing different elements
for c=1:strcol
[d,id]=findgroups(capi_name_list(:,c));
capi_elenum(1,c)=numel(id);
capi_group(:,c)=d;
end
[chrow,chcol]=find(capi_elenum>1);

%1st colomn >2 elements
coloi=chcol(1);
capi_elenumoi=[1:1:capi_elenum(coloi)];
capi_grpoi=capi_group(:,coloi);%save grouping index of each capillary and group index
capi_grpinfo.capinum=capi_elenumoi;
capi_grpinfo.groupindex=capi_grpoi;
save(fullfile(savefolder,strcat(sessionList(i).name,'capi_grpinfo.mat')),'capi_grpinfo');
%process based on each capillary each trial
%preallocate cell for each capillary to store raw avg and std values
capillary_metrics=cell(numel(capi_elenumoi),4,3); %column 1234: raw avg std depth;1st layer CBF with raw depth, 2ND Flux with mean depth, 3RD hct with std of depth 

for n=1:numel(capi_elenumoi)
    %identify each capillary and their trials
    gp=capi_elenumoi(n);
    [rr cc]=find(gp==capi_grpoi);
   %preallocate cell for trials of this capillary
    RBCV_temp=[];
    RBCV_save=cell(numel(rr),1); %to save raw data of different sizes
    RC_temp=[];
    HCT_temp=[];
    depth_temp=[];

    for m=1:numel(rr) %number of trials
    foldername=capi_name{rr(m)}; %folder to access of each trial
    foldername_full=fullfile(disfolder,foldername);
    %calculate metrics
    [CBFV,VA,Cali_Factor,K] = LSV_V2(foldername_full,savefolder,gp,m);
    [RC HCT] = RBC_HCT_V2(foldername_full,savefolder,gp,m);
    RBCV_temp=[RBCV_temp;CBFV];
    RBCV_save{m,1}=CBFV; 
    RC_temp=[RC_temp;RC]; % RC, 1-5, ai number, ai flux, manual number, manual flux,frameperiod of this image
    HCT_temp=[HCT_temp;HCT]; %HCT 1-5 median3 mean3 gauss1 wiener7 total pixel count of the image
    depth_temp=[depth_temp;Cali_Factor(1,3)]; %third row is depth 
    end
    capillary_metrics{n,1,1}=RBCV_temp;capillary_metrics{n,2,1}=nanmean(RBCV_temp,'all');capillary_metrics{n,3,1}=nanstd(RBCV_temp,0,'all'); %mean and std of all velocity 
    capillary_metrics{n,1,2}=RC_temp;capillary_metrics{n,2,2}=nansum(RC_temp(:,3))/nansum(RC_temp(:,5));%capillary_metrics{n,3,2}=std(RC_temp); % Sum all manual divided by frame time sum
    capillary_metrics{n,1,3}=HCT_temp; capillary_metrics{n,2,3}=nansum(HCT_temp(:,1:4),1)./nansum(HCT_temp(:,5));%capillary_metrics{n,3,3}=std(HCT_temp); % Sum all pixels divided by frame size sum
    capillary_metrics{n,4,1}=depth_temp;capillary_metrics{n,4,2}=round(nanmean(depth_temp));capillary_metrics{n,4,3}=round(nanstd(depth_temp));
    %display this capillary is done
    fprintf('capillary %d is done',gp)

end

save(fullfile(savefolder,strcat(sessionList(i).name,' capillary_metrics.mat')),'capillary_metrics');
%save(fullfile(savefolder,'calibration information'),'cali_info');
%count the number of pics in the folder
%filepattern=dir('*.tif');
%tifFiles={filepattern.name};
%read data in a cell
%PicNum=length(tifFiles);
%Calculate RBCV HCT and Flux by calling the function

%[RBCV Num K] = LSV_V2(date_folder);

%[RC HCT] = RBC_HCT_V2(date_folder,Num);

%Write the three matrix in a stucture and name/save after its folder name
% LS_info=struct('RBCV',RBCV,'RC',RC,'HCT',HCT);
% %folders_name=regexp(date_folder,filesep,'split');
% struct_name=char(sessionList(i).name);
% %cd(savefolder), structure saved in the folder of each session
% save(strcat(struct_name,'.mat'),'-struct','LS_info')
%display the current session has finished

%cd ..
end
fprintf('session %s has finished',sessionList(i).name);
end
%%
% %BOX plot Statistics, load savefolder name 
% savefolder='C:\Users\Yifu Jin\Desktop\JYF PPT\Project\Stroke\data\5.7 aged\5.7 aged Linescan Info'
% week_info={'Week2','Week4'}
% Depth_Criteria=360
% [scbf,hct,rbc_flux]  = LS_Stat_Plot(savefolder,week_info,Depth_Criteria)