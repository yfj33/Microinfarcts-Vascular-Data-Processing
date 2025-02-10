function [scbf,hct,rbc_flux] = LS_Stat_Plot(foldername,week_info,Depth_Criteria)
%Depth_Criteria: the depth that seperates middle and deep layers
%output the layers dependent graphs and also the non layer dependent graphs
cd(foldername);
myfolder=foldername;
filepattern=dir('*.mat');

matFiles={filepattern.name};
%read data in a cell
filenum=length(matFiles);
scbf=cell(filenum,3); % seperate cbf values into 3 ranges
CBFV_C=cell(filenum,1);%  combined CBFs
rbc_flux=cell(filenum,3); % read flux value from structure
Flux_C=cell(filenum,1);%  combined flux
hct=cell(filenum,3,2); % read hct values calculated by two methods: median 5*5 and mean 3 3
HCT_C=cell(filenum,2);%combined HCT for mean and median method
for n=1:filenum
        struct_name=matFiles{1,n};
    LS_info=load(struct_name);
    HCT=LS_info.HCT;
    RC=LS_info.RC;
    RBCV=LS_info.RBCV;
  %RBCV
   Depth=RBCV(:,3);
   CBF=RBCV(:,2);%CBF is velocity number
   CBFV_C{n,1}=double(CBF)

  D_C=[Depth CBF];
  Shallow_CBFV=[D_C(D_C(:,1)>0&D_C(:,1)<=200,2)];
  Middle_CBFV=[D_C(D_C(:,1)>200&D_C(:,1)<Depth_Criteria,2)];
  Deep_CBFV=[D_C(D_C(:,1)>=Depth_Criteria,2)];
 
     
         scbf{n,1}=double(Shallow_CBFV);
     
         scbf{n,2}=double(Middle_CBFV);
     
         scbf{n,3}=double(Deep_CBFV);
         
         
%Flux
Flux=RC(4,:)';%Flux number
Flux_C{n,1}=double(Flux);
D_F=[Depth Flux];
Shallow_Flux=[D_F(D_F(:,1)>0&D_F(:,1)<=200,2)];
Middle_Flux=[D_F(D_F(:,1)>200&D_F(:,1)<Depth_Criteria,2)];
Deep_Flux=[D_F(D_F(:,1)>=Depth_Criteria,2)];
 %Store in the cell
rbc_flux{n,1}=double(Shallow_Flux);
rbc_flux{n,2}=double(Middle_Flux);
rbc_flux{n,3}=double(Deep_Flux);

% HCT
Hema_median=HCT(:,1)%use median ilter
Hema_mean=HCT(:,2)%use mean filter
HCT_C{n,1}=Hema_median;
HCT_C{n,2}=Hema_mean;
D_H=[Depth Hema_median Hema_mean];
Shallow_Hema=[D_H(D_H(:,1)>0&D_H(:,1)<=200,2:3)];
Middle_Hema=[D_H(D_H(:,1)>200&D_H(:,1)<Depth_Criteria,2:3)];
Deep_Hema=[D_H(D_H(:,1)>=Depth_Criteria,2:3)];

hct{n,1,1}=double(Shallow_Hema(:,1));%median 5*5 binarization
hct{n,2,1}=double(Middle_Hema(:,1));
hct{n,3,1}=double(Deep_Hema(:,1));

hct{n,1,2}=double(Shallow_Hema(:,2));%mean 3*3 binarization
hct{n,2,2}=double(Middle_Hema(:,2));
hct{n,3,2}=double(Deep_Hema(:,2));

end
  
 
 xlab=week_info; % string cell
%RBC V grouped blox plot

Mlab={'shallow ','middle','deep'}
Position=[1.2 1.5 1.8];
color={'y','g','b'};

figure
%lumped CBFV graphs
for i=1:length(week_info)
    PS=2*i-1;
    boxp=boxplot(CBFV_C{i,1},'position',PS,'color','k');
    hold on
    x_pos=ones(size(CBFV_C{i,1})).*(PS-0.01+(rand(size(CBFV_C{i,1}))-0.5)/3);
    scatter(x_pos(:),CBFV_C{i,1},'r','filled')
set(boxp,'LineWidth',4)
end

ylim([0 max(cell2mat(CBFV_C))+250])
xticklabels(xlab);
lbr=[1:2:PS]
xticks(lbr);
xlabel('days','FontSize',18);
ylabel('CBFV (μm/s)','FontSize',18);
title('CBFV boxplot','FontSize',18);
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
xlim([0 PS+2]);

savefig('RBC Velocity boxplot.fig');

figure
%set(gca,'DefaultTextFontSize',18)
%hold on
for i=1:length(week_info)
    for j=1:3
    
    position=Position(j)+(2*i-1)
    BOX_LSV=boxplot(scbf{i,j},'position',position,'color',char(color(j)));
    hold on
    SCBF=scbf{i,j}
    x=ones(size(SCBF)).*(position-0.01+(rand(size(SCBF))-0.5)/10);
    scatter(x(:),scbf{i,j},'r','filled')
    set(BOX_LSV,'LineWidth',4)
    end
end

xticklabels(xlab);
lbrange=[2.5:2:2.5+2*length(week_info)-1];
xticks(lbrange);
% findall is used to find all the graphics objects with tag "box", i.e. the box plot
%hLegend = legend(findall(gca,'Tag','Box'), {'shallow 0-200μm','middle 200-360μm','deep 360um and above'});
xlabel('days','FontSize',18);
ylabel('CBFV (μm/s)','FontSize',18);
title('CBFV boxplot','FontSize',18);
%set(BOX_LSV,'linew',3)
ax = gca
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
boxes=findobj(gca,'Tag','Box');
%sort by xposition
[~, ind] = sort(cellfun(@mean, get(boxes, 'XData')));
%// Apply legends to three.
le_middle=sprintf('middle 200-%dum',Depth_Criteria);
le_deep=sprintf('deep %dum and above',Depth_Criteria);
legend(boxes(ind(1:3)), 'shallow 0-200μm', le_middle,le_deep,'FontSize',18);
ylim([0 2400]);
xlim([lbrange(1,1)-0.5 lbrange(1,end)+0.5]);
%set(BOX_LSV,'LineWidth',4)

%'shallow 0-200μm','middle 200-360μm','deep 360um and above')
 % Among the children of the legend, find the line elements
 %hChildren = findall(get(hLegend,'Children'), 'Type','Line');
% Set the horizontal lines to the right colors
%set(hChildren(1),'Color',color{1});
%set(hChildren(2),'Color',color{2});
%set(hChildren(3),'Color',color{3});
savefig('RBCV grouped boxplot.fig')

%Flux plot
figure
for i=1:length(week_info)
    PS=2*i-1;
    boxp=boxplot(Flux_C{i,1},'position',PS,'color','k');
    hold on
    x_pos=ones(size(Flux_C{i,1})).*(PS-0.01+(rand(size(Flux_C{i,1}))-0.5)/10);
    scatter(x_pos(:),Flux_C{i,1},'r','filled')
set(boxp,'LineWidth',4)
end
xticklabels(xlab);
lbr=[1:2:PS]
xticks(lbr);
xlim([0 PS+2]);
ylim([0 max(cell2mat(Flux_C))*1.2]);
xlabel('days','FontSize',18);
ylabel('RBC Flux (#/s)','FontSize',18);
title('RBC Flux boxplot','FontSize',18);
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
savefig('RBC Flux boxplot.fig');

figure
for a=1:length(week_info)
    for b=1:3
    
    RBC_FLUX=rbc_flux{a,b};
    position=Position(b)+(2*a-1);
    BOX_Flux=boxplot(RBC_FLUX,'position',position,'color',char(color(b)));
    hold on
   x=ones(size(RBC_FLUX)).*(position-0.01+(rand(size(RBC_FLUX))-0.5)/10);
    scatter(x(:),RBC_FLUX,'r','filled');
    set(BOX_Flux,'linew',4)
    end
    
end
xticklabels(xlab);
%xticks([Position(1)+1:2:Position(1)+1+2*length(week_info)-1]);
xticks(lbrange);
xlabel('days','FontSize',18);
ylabel('RBC Flux (#/s)','FontSize',18);
title('RBC Flux boxplot','FontSize',18);
%set(BOX_Flux,'linew',4)

%xlim([Position(1) Position(1)+2*length(week_info)]);
%xlim([lbrange(1,1)-0.5 lbrange(1,end)+0.5]);
ax = gca
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
boxes=findobj(gca,'Tag','Box');
%sort by xposition
[~, ind] = sort(cellfun(@mean, get(boxes, 'XData')));
%// Apply legends to three.
le_middle=sprintf('middle 200-%dum',Depth_Criteria);
le_deep=sprintf('deep %dum and above',Depth_Criteria);
legend(boxes(ind(1:3)), 'shallow 0-200μm', le_middle,le_deep,'FontSize',18);

xlim([lbrange(1,1)-0.5 lbrange(1,end)+0.5]);
savefig('RBC Flux grouped boxplot.fig')

%RBC HCT

%fig3=figure %median filter HCT 
%for m=1:length(week_info)
   % HCT=hct{m,1}
  %  position=Position(1)+(2*m-1)
 %   BOX_HCT=boxplot(HCT,'position',position,'color','c')
 %   hold on
 %  x=ones(size(HCT)).*(position-0.01+(rand(size(HCT))-0.5)/10);
  %  scatter(x(:),HCT,'r','filled','jitter','on','jitteramount',0.15)
  %  set(BOX_HCT,'linew',4)
%end
%xticklabels(xlab);
%xticks([Position(1)+1:2:Position(1)+1+2*length(week_info)-1]);
%xlabel('days','FontSize',18);
%ylabel('RBC HCT %','FontSize',18);
%title('RBC HCT boxplot median filter','FontSize',18);
%xlim([Position(1) Position(1)+2*length(week_info)]);
%savefig('RBC HCT median filter grouped boxplot.fig');
%ax = gca
%ax.XAxis.FontSize = 18;
%ax.YAxis.FontSize = 18;
figure
for i=1:length(week_info)
    PS=2*i-1;
    boxp=boxplot(HCT_C{i,1},'position',PS,'color','k');
    hold on
    x_pos=ones(size(HCT_C{i,1})).*(PS-0.01+(rand(size(HCT_C{i,1}))-0.5)/10);
    scatter(x_pos(:),HCT_C{i,1},'r','filled')
set(boxp,'LineWidth',4)
end
xticklabels(xlab);
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
xlim([0 PS+2]);
ylim([0 0.1+max(max(cell2mat(HCT_C)))]);

lbr=[1:2:PS];
xticks(lbr);
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
xlabel('days','FontSize',18);
ylabel('RBC HCT (#/s)','FontSize',18);
title('RBC HCT boxplot','FontSize',18);
savefig('RBC HCT boxplot median.fig');

figure %mean filter HCT 
for m=1:length(week_info)
     for n=1:3
    HCT=hct{m,n,2}
    position=Position(n)+(2*m-1)
    BOX_HCT=boxplot(HCT,'position',position,'color',char(color(n)))
    hold on
    x=ones(size(HCT)).*(position-0.01+(rand(size(HCT))-0.5)/10);
    scatter(x(:),HCT,'r','filled')
    set(BOX_HCT,'linew',4)
     end
end
xticklabels(xlab);
xticks(lbrange);
xlabel('days','FontSize',18);
ylabel('RBC HCT %','FontSize',18);
title('RBC HCT boxplot median filter','FontSize',18);
%set(BOX_Flux,'linew',3)

%xlim([Position(1) Position(1)+2*length(week_info)]);
%xlim([lbrange(1,1)-0.5 lbrange(1,end)+0.5]);
ax = gca
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
boxes=findobj(gca,'Tag','Box');
%sort by xposition
[~, ind] = sort(cellfun(@mean, get(boxes, 'XData')));
%// Apply legends to three.
le_middle=sprintf('middle 200-%dum',Depth_Criteria);
le_deep=sprintf('deep %dum and above',Depth_Criteria);
legend(boxes(ind(1:3)), 'shallow 0-200μm', le_middle,le_deep,'FontSize',18);

xlim([lbrange(1,1)-0.5 lbrange(1,end)+0.5]);
savefig('RBC HCT median filter grouped boxplot.fig');

figure %mean filter HCT 
for k=1:length(week_info)
     for s=1:3
    HCT=hct{k,s,2}
    position=Position(s)+(2*k-1)
    BOX_HCT=boxplot(HCT,'position',position,'color',char(color(s)))
    hold on
    x=ones(size(HCT)).*(position-0.01+(rand(size(HCT))-0.5)/10);
    scatter(x(:),HCT,'r','filled')
    set(BOX_HCT,'linew',4)
     end
end
xticklabels(xlab);
xticks(lbrange);
xlabel('days','FontSize',18);
ylabel('RBC HCT %','FontSize',18);
title('RBC HCT boxplot mean filter','FontSize',18);
%set(BOX_Flux,'linew',3)

%xlim([Position(1) Position(1)+2*length(week_info)]);

ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
boxes=findobj(gca,'Tag','Box');
%sort by xposition
[~, ind] = sort(cellfun(@mean, get(boxes, 'XData')));
%// Apply legends to three.
le_middle=sprintf('middle 200-%dum',Depth_Criteria);
le_deep=sprintf('deep %dum and above',Depth_Criteria);
legend(boxes(ind(1:3)), 'shallow 0-200μm', le_middle,le_deep,'FontSize',18);

xlim([lbrange(1,1)-0.5 lbrange(1,end)+0.5]);
savefig('RBC HCT mean filter grouped boxplot.fig');

figure
for i=1:length(week_info)
    PS=2*i-1;
    boxp=boxplot(HCT_C{i,2},'position',PS,'color','k');
    hold on
    x_pos=ones(size(HCT_C{i,2})).*(PS-0.01+(rand(size(HCT_C{i,2}))-0.5)/10);
    scatter(x_pos(:),HCT_C{i,2},'r','filled')
set(boxp,'LineWidth',4)
end
xticklabels(xlab);
lbr=[1:2:PS];
xticks(lbr);
xlim([0 PS+2]);
ylim([0 0.1+max(max(cell2mat(HCT_C)))]);
xticklabels(xlab);
ax = gca;
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
xlabel('days','FontSize',18);
ylabel('RBC HCT','FontSize',18);
title('RBC HCT boxplot','FontSize',18);
savefig('RBC HCT boxplot mean filter.fig');
end