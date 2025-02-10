%read data in a cell


clc;clear all; close all;
scbf=cell(8,3);
Filename=dir;
xls_name = {Filename.name};
xls_name= xls_name(3:10);

for n=1:size(xls_name,2)
  Depth=xlsread(char(xls_name(n)),'R:R');
  CBF=xlsread(char(xls_name(n)),'S:S');
  D_C=[Depth CBF];
  Shallow=[D_C(D_C(:,1)>0&D_C(:,1)<200,2)];
  Middle=[D_C(D_C(:,1)>200&D_C(:,1)<360,2)];
  Deep=[D_C(D_C(:,1)>=360,2)];
 
     
         scbf{n,1}=double(Shallow);
     
         scbf{n,2}=double(Middle);
     
         scbf{n,3}=double(Deep);
  
 
 
end
xlab={'pre-stroke','stroke','2 days','1 week','2 weeks','3 weeks','4 weeks','6 weeks'}
Mlab={'shallow ','middle','deep'}
Position=[1.2 1.5 1.8];
color={'r','g','b'};
figure
set(gca,'DefaultTextFontSize',18)
hold on
for i=1:8
    for j=1:3
    
    
    BOX=boxplot(scbf{i,j},'position',Position(j)+(2*i-1),'color',char(color(j)))
    
    end
    
end
xticklabels(xlab);
xticks([2.5:2:2.5+2*7]);
% findall is used to find all the graphics objects with tag "box", i.e. the box plot
hLegend = legend(findall(gca,'Tag','Box'), {'shallow 0-200μm','middle 200-360μm','deep 360um and above'});
xlabel('days','FontSize',18);
ylabel('CBF (μm/s)','FontSize',18);
title('CBF boxplot','FontSize',18);
set(BOX,'linew',2)
ax = gca
ax.XAxis.FontSize = 18;
ax.YAxis.FontSize = 18;
boxes=findobj(gca,'Tag','Box');
%sort by xposition
[~, ind] = sort(cellfun(@mean, get(boxes, 'XData')));
%// Apply legends to three.
legend(boxes(ind(1:3)), 'shallow 0-200μm', 'middle 200-360μm','deep 360um and above','FontSize',18);
ylim([0 2400]);
xlim([2 17]);
%'shallow 0-200μm','middle 200-360μm','deep 360um and above')
 % Among the children of the legend, find the line elements
 %hChildren = findall(get(hLegend,'Children'), 'Type','Line');
% Set the horizontal lines to the right colors
%set(hChildren(1),'Color',color{1});
%set(hChildren(2),'Color',color{2});
%set(hChildren(3),'Color',color{3});
savefig('grouped boxplot.fig')