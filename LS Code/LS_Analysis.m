%% Organize data in the structure: date under  each mouse folder eg. 7.7 aged\2021-07-12; Date folder start with year 2021; Start under each mouse folder

%%close all, clear variables, add processing code path
clc;clear;close all
addpath 'E:\2Pscript\LS Code'
%lsfolder='D:\2P 2021\9.2 aged Linescan\PV_4'
%savefolder='D:\2P 2021\9.2 aged Linescan\PV_4'
sessionList=dir;
sessionName={sessionList.name};

sessionInUse=cellfun(@(y) y(1)=='2',sessionName);%list of session in use, true false ve4ctor
sessionList=sessionList(sessionInUse);% structure with date start with 2
%%
for i=1:numel(sessionList)
date_folder=[pwd '/' sessionList(i).name];
%count the number of pics in the folder
%filepattern=dir('*.tif');
%tifFiles={filepattern.name};
%read data in a cell
%PicNum=length(tifFiles);
%Calculate RBCV HCT and Flux by calling the function

[RBCV Num K] = LSV(date_folder);
[RC HCT] = RBC_HCT(date_folder,Num);

%Write the three matrix in a stucture and name/save after its folder name
LS_info=struct('RBCV',RBCV,'RC',RC,'HCT',HCT);
%folders_name=regexp(date_folder,filesep,'split');
struct_name=char(sessionList(i).name);
%cd(savefolder), structure saved in the folder of each session
save(strcat(struct_name,'.mat'),'-struct','LS_info')
%display the current session has finished
fprintf('session %s has finished',struct_name);
cd ..
end
%%
%BOX plot Statistics, load savefolder name 
savefolder='C:\Users\Yifu Jin\Desktop\JYF PPT\Project\Stroke\data\5.7 aged\5.7 aged Linescan Info'
week_info={'Week2','Week4'}
Depth_Criteria=360
[scbf,hct,rbc_flux]  = LS_Stat_Plot(savefolder,week_info,Depth_Criteria)