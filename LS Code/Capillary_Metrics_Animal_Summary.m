% capillary metrics summary for each mice and combining of all mice 
% 
clc;clear;close all
%go to animal folder of all mice of interest
cd('Z:\xl_stroke\yifu_2P\capillary metrics');
%make one folder to save all mice data
folder2save=fullfile(pwd,'results');
if ~exist(folder2save)
    mkdir(folder2save);
end

animals=dir;
animal_name={animals.name};
oi_id=cellfun(@(y) y(1)=='2',animal_name) ;
animal_oi={animal_name{oi_id}};
%preallocate matrix for all mice to use
%capmet_all_mice=cell{4,7,numel(animal_oi)};%1st row session time; 2nd row capillary metrics CBFV 3rd row RBCV 4th row HCT; 7 sessions across 2 weeks;different layer rep different animals
capmet_all_mice=cell(4,7,2);%1st row session time; 2nd row capillary metrics CBFV 3rd row RBCV 4th row HCT; 7 sessions across 2 weeks;different layers rep different distances. Meant to save information of all mice
Week_Info={'baseline','stroke day','day3','day5','day7','day10','day14'};
week_code=[1 1 1 1 1 0 1;1 1 1 1 1 1 1;1 1 1 1 1 1 1;1 1 1 1 1 1 1;1 1 1 1 1 0 0];
week_seq=[1:1:7];

for a=1:numel(animal_oi)
session_folder_main=fullfile(animal_oi{a},'preprocessed','processed');
%make folder to save
session_folder_main_2save=fullfile(animal_oi{a},'preprocessed','processed','results each mouse');
if ~exist(session_folder_main_2save)
    mkdir(session_folder_main_2save);
end

sessions=dir(session_folder_main);
sessions_name={sessions.name};
soi_id=cellfun(@(y) y(1)=='2',sessions_name);
session_oi={sessions_name{soi_id}}; %number of capillary * 4*3 metrics % RC, 1-5, ai number, ai flux, manual number, manual flux,frameperiod of this image %HCT 1-5 median3 mean3 gauss1 wiener7 total pixel count of the image
        %find if there is missing session, if there is advance one 
        wk_code=week_code(a,:);
        wk_num=wk_code.*week_seq;   
        wk_num=wk_num(~wk_num==0);
        %preallocate for each mouse
        capmet_one_mouse=cell(3,8,3); %Z LAYER for 3 RBCV Flux HCT
        for x=1:3
        capmet_one_mouse{2,1,x}={'Close Capillaries'};
        capmet_one_mouse{3,1,x}={'Far Capillaries'};
        end
        for b=1:numel(session_oi) %column 1234: raw avg std depth;1st layer CBF with raw depth, 2ND Flux with mean depth  ai number, ai flux, manual number, manual flux,frameperiod, 3RD hct with std of depth median3 mean3 gauss1 wiener7 total pixel
        close_cap_metrics=fullfile(session_folder_main,session_oi{b},'Close Capillaries',strcat(session_oi{b},' capillary_metrics.mat'));
        far_cap_metrics=fullfile(session_folder_main,session_oi{b},'Far Capillaries',strcat(session_oi{b},' capillary_metrics.mat'));        
        %HCT 1-5 median3 mean3 gauss1 wiener7 total pixel count of the image
        close_capmet=load(close_cap_metrics);
        far_capmet=load(far_cap_metrics);
        %preallocate for storing at each session
        close_cap_RBCV=[];
        far_cap_RBCV=[]; %n by one
        close_cap_Flux=[];
        far_cap_Flux=[]; %n by one 
        close_cap_HCT=[];
        far_cap_HCT=[]; %n by two
        wk_seq=wk_num(b);


        %capillary metrics
        for c=1:size(close_capmet.capillary_metrics,1)
            %for d=1:size(close_capmet,2)
               % for e=1:size(close_capmet,3)
                    close_met_rbcv=close_capmet.capillary_metrics{c,2,1};  %trial avg
                    %far_met_rbcv=far_capmet.capillary_metrics{c,2,1};
                    %rbcv
                    close_cap_RBCV=[close_cap_RBCV;close_met_rbcv];%RBCV mean of each capillary across trials
                    %far_cap_RBCV=[far_cap_RBCV;far_met_rbcv];
                    %flux
                    close_met_Flux=close_capmet.capillary_metrics{c,2,2};  %Flux mean trial avg  
                    %far_met_Flux=far_capmet.capillary_metrics{c,2,2}; 
                    close_cap_Flux=[close_cap_Flux;close_met_Flux];
                    %far_cap_Flux=[far_cap_Flux;far_met_Flux];
                    %hct take mean3 and gaussian1 from row 2 and 3
                    close_met_hct=close_capmet.capillary_metrics{c,2,3};  %trial avg
                    %far_met_hct=far_capmet.capillary_metrics{c,2,3};
                    close_cap_HCT=[close_cap_HCT;close_met_hct(1,2:3)];
                    %far_cap_HCT=[far_cap_HCT;far_met_hct(1,2:3)];

        end

        for c=1:size(far_capmet.capillary_metrics,1)
                    %for d=1:size(close_capmet,2)
                       % for e=1:size(close_capmet,3)
                            %close_met_rbcv=close_capmet.capillary_metrics{c,2,1};  %trial avg
                            far_met_rbcv=far_capmet.capillary_metrics{c,2,1};
                            %rbcv
                            %close_cap_RBCV=[close_cap_RBCV;close_met_rbcv];%RBCV mean of each capillary across trials
                            far_cap_RBCV=[far_cap_RBCV;far_met_rbcv];
                            %flux
                            %close_met_Flux=close_capmet.capillary_metrics{c,2,2};  %Flux mean trial avg  
                            far_met_Flux=far_capmet.capillary_metrics{c,2,2}; 
                            %close_cap_Flux=[close_cap_Flux;close_met_Flux];
                            far_cap_Flux=[far_cap_Flux;far_met_Flux];
                            %hct take mean3 and gaussian1 from row 2 and 3
                            %close_met_hct=close_capmet.capillary_metrics{c,2,3};  %trial avg
                            far_met_hct=far_capmet.capillary_metrics{c,2,3};
                            %close_cap_HCT=[close_cap_HCT;close_met_hct(1,2:3)];
                            far_cap_HCT=[far_cap_HCT;far_met_hct(1,2:3)];
        
                end



                    %for each mice 
                    for x=1:3
                        capmet_one_mouse{1,wk_seq+1,x}=Week_Info{wk_seq};
                    end
                    capmet_one_mouse{2,wk_seq+1,1}=[capmet_one_mouse{2,wk_seq+1,1};close_cap_RBCV];%RBCV
                    capmet_one_mouse{3,wk_seq+1,1}=[capmet_one_mouse{3,wk_seq+1,1};far_cap_RBCV];
                    capmet_one_mouse{2,wk_seq+1,2}=[capmet_one_mouse{2,wk_seq+1,2};close_cap_Flux];%Flux
                    capmet_one_mouse{3,wk_seq+1,2}=[capmet_one_mouse{3,wk_seq+1,2};far_cap_Flux];
                    capmet_one_mouse{2,wk_seq+1,3}=[capmet_one_mouse{2,wk_seq+1,3};close_cap_HCT];%HCT
                    capmet_one_mouse{3,wk_seq+1,3}=[capmet_one_mouse{3,wk_seq+1,3};far_cap_HCT];
                    
                    %capmet_all_mice{1,b,1}=session_oi{b};
                    %capmet_all_mice{1,b,2}=session_oi{b};
                    capmet_all_mice{1,wk_seq,1}=Week_Info{wk_seq};
                    capmet_all_mice{1,wk_seq,2}=Week_Info{wk_seq};               
                    capmet_all_mice{2,wk_seq,1}=[capmet_all_mice{2,wk_seq,1};close_cap_RBCV];
                    capmet_all_mice{2,wk_seq,2}=[capmet_all_mice{2,wk_seq,2};far_cap_RBCV];
                    capmet_all_mice{3,wk_seq,1}=[capmet_all_mice{3,wk_seq,1};close_cap_Flux];
                    capmet_all_mice{3,wk_seq,2}=[capmet_all_mice{3,wk_seq,2};far_cap_Flux];
                    capmet_all_mice{4,wk_seq,1}=[capmet_all_mice{4,wk_seq,1};close_cap_HCT];
                    capmet_all_mice{4,wk_seq,2}=[capmet_all_mice{4,wk_seq,2};far_cap_HCT];
                    
    end
                    
%save capmet for each mouse under the folder
save(fullfile(session_folder_main_2save,'capillary metrics of one mouse.mat'),'capmet_one_mouse','-mat');
                    
end
save(fullfile(folder2save,'capillary metrics of all mice.mat'),"capmet_all_mice",'-mat');


