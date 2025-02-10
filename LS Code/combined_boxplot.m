
function [weeks_combined] = combined_boxplot(foldername,week_info,week_total,plot_num)
%plot linescan velocity flux HCT of all the animals from all sessions
%same week data are combined and boxplot are made for RBCV,Flux and HCT


%plot linescan velocity flux HCT of all the animals from all sessions
%same week data are combined and boxplot are made for RBCV,Flux and HCT
cd(foldername)
%load file directory name of all files 
subfolders=dir(foldername);%general folder with data from all animals
subfolders(ismember({subfolders.name},{'.','..'}))=[];%remove . and ..
dirFlags=[subfolders.isdir];
subfolder_names=subfolders(dirFlags);%name of folders of each date

%create a cell with dimension: 8*1, 8 weeks, each week  all data combined,
%first row:RBCV,2nd row: Flux,3rd row: HCT median, 4th row:HCT mean
weeks_combined=cell(8,4);
%in one column
%go to each subfolder（each animal） and read RBCV, Flux and HCT of each week from each file
for n=1:length(subfolder_names)
    cd(subfolder_names(n).name);
    filepattern=dir('*.mat');
    matFiles={filepattern.name};
    filenum=length(matFiles);%matfiles number in each folder
    for m=1:filenum %go to each week's data and extract RBCV,Flux,HCT
        struct_name=matFiles{1,m};%each week's data
        LS_info=load(struct_name);
        
        %extract the week num from filename
        expression=['(?<weeknum>\d+)-(?<year>\d+)-(?<months>\d+)-(?<day>\d+)-(?<LS>\w+)'];
        tokenNames=regexp(struct_name,expression,'names')
        weeknum=extractfield(tokenNames,'weeknum')%week number information extratced, decidea which column it goes to
        weeknum=str2double(weeknum)
       %extract three information       
        HCT=LS_info.HCT;
        RC=LS_info.RC;
        RBCV=LS_info.RBCV;
        
        %RBCV
        CBFV=RBCV(:,2);
        %Flux
        Flux=RC(4,:)';
        %HCT
        Hema_median=HCT(:,1)%use median ilter
        Hema_mean=HCT(:,2)%use mean filter
        
        %store it in the matrix
        weeks_combined{weeknum,1}=[weeks_combined{weeknum,1};CBFV]; %update the information after going through each file
        weeks_combined{weeknum,2}=[weeks_combined{weeknum,2};Flux]; %update flux
        weeks_combined{weeknum,3}=[weeks_combined{weeknum,3};Hema_median];%update HCT median
        weeks_combined{weeknum,4}=[weeks_combined{weeknum,4};Hema_mean];%update HCT mean
    end
    cd(foldername)
end
cd(foldername)
%extarct week 1 2 4 6 8
weeks_combined=weeks_combined([1,2,4,6,8],:)
%After getting the combined data plot 4 figures 
y_lab={'CBFV (μm/s)','Flux (#/s)','HCT','HCT'}
savename={'CBFV Boxplot.fig','Flux Boxplot.fig','HCT Median Filter Boxplot.fig','HCT Mean Filter Boxplot.fig'}
for i=1:plot_num
    figure(i)
    for j=1:week_total %5 weeks
        
        position=2*j-1
        boxp=boxplot(weeks_combined{j,i},'position',position,'color','k','widths',1,'symbol','');
        hold on
        x_pos=ones(size(weeks_combined{j,i})).*(position-0.01+(rand(size(weeks_combined{j,i}))-0.5)/2);
        scatter(x_pos(:),weeks_combined{j,i},'r','filled')
        set(boxp,'LineWidth',4)
    end
%ylim([0 max(weeks_combined{:,i})]);
%xlim([0 position+2]);
axis auto
xlab=[week_info];
xticklabels(xlab);
lbr=[1:2:position];
xticks(lbr);
xlabel('days','FontSize',18);
ylabel(char(y_lab{1,i}),'FontSize',18);
title(strcat(y_lab{1,i},' boxplot'),'FontSize',18);
ax=gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
savefig(figure(i),savename{i});

save('weeks_combined.mat','weeks_combined')
end
