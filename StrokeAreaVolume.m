%Compute the stroke area from MIP images and times by depth 200um to get
%stroke volume based on 2D area 

%project damaged region with geometry center from middle MIP layer to surface layer and speckle
%image 

%output MIP at 0-100um and 200-300um with stroke damage region

clc;clear;close all
cali_factor=1.09 %um/pixel
save_path=fullfile(pwd,'Stroke Area and Volume');
animal_file=split(pwd,"\");
animal_id=string(animal_file(end-1,:));


if ~exist(save_path);
    mkdir(save_path);
end

Fourty_Eight='12_21';
Processed=fullfile(pwd,'ProcessedStack');
PStack=dir(Processed);
PStack(1:2)=[];
PStack_BL=PStack(1).name;
PStack_BL_path=fullfile(Processed,PStack_BL);
Baseline_Ref=bfOpen3DVolume(PStack_BL_path); 
Baseline_Ref=double(Baseline_Ref{1,1}{1,1});
Baseline_Ref_MIP=max(Baseline_Ref(:,:,100:150),[],3); %Reference Baseline MIP of depth 200-300um
Baseline_Ref_MIP=ind2gray(Baseline_Ref_MIP,gray(800));
%Stack name of first day without dye leakage, fourtyeight given before
PStack_48hrs_file=strcat('Processed_',Fourty_Eight,'.tif','.tif');
%PStack_48hrs_file=strcat('Processed_',Fourty_Eight,'.tif');
PStack_48hrs_path=fullfile(Processed,PStack_48hrs_file);
PStack_48hrs=bfOpen3DVolume(PStack_48hrs_path);

PStack_48hrs=double(PStack_48hrs{1,1}{1,1});
PStack_48hrs_MIP=max(PStack_48hrs(:,:,100:150),[],3); %48hrs MIP of depth 200-300um
PStack_48hrs_MIP_surface=max(PStack_48hrs(:,:,1:50),[],3); %48hrs MIP of depth 200-300um
PStack_48hrs_MIP=ind2gray(PStack_48hrs_MIP,gray(800));
PStack_48hrs_MIP_surface=ind2gray(PStack_48hrs_MIP_surface,gray(800));
%Mask folder 
mask_path=fullfile(pwd,'Mask',strcat(Fourty_Eight,'.tif'));
mask=imread(mask_path);

%size of the resize image
sz=size(PStack_48hrs_MIP_surface);
%plot mask reference and 48hrs stack together
f0=figure
imshow(mask);
title('Mask');

f1=figure
imshow(Baseline_Ref_MIP);
title('Baseline Reference Images','FontSize',24);

f2=figure

imshow(PStack_48hrs_MIP);
%title('48hrs* Stroke Images ','FontSize',24);
hold on
Stroke_ROI=drawpolygon('Color','r');
coords=Stroke_ROI.Position;
polyin=polyshape(coords(:,1),coords(:,2));
[geo_x,geo_y]=centroid(polyin);
plot(geo_x,geo_y,'g*');

Area_pixel=polyarea(coords(:,1),coords(:,2)); %Area in Pixels
Area_micron=Area_pixel*cali_factor; %Area in um^2
Damaged_Volume=Area_micron*200; %Damaged volume of 200 um column
%set(gca,'Units','pixels');
%set(gca,'Position',[1 1 sz+1]);
results=struct('Area_in_pixel',Area_pixel,'Area_in_micron',Area_micron,'Damaged_Volume_in_micron',Damaged_Volume);

exportgraphics(f2,fullfile(save_path,strcat(animal_id ,'48hrs ROI 200-300 MIP','.tiff')),"Resolution",600);
%exportgraphics(f2,fullfile(save_path,strcat(animal_id ,'48hrs ROI 200-300 MIP','.tiff')));
%saveas(f2,fullfile(save_path,strcat(animal_id ,'48hrs ROI 200-300 MIP','.tiff')));
save(fullfile(save_path,'Area Volume Results.mat'),'results');

f3=figure

imshow(PStack_48hrs_MIP_surface);
hold on
plot(polyin,'FaceColor','red','FaceAlpha',0.1);
plot(geo_x,geo_y,'g*');

exportgraphics(f3,fullfile(save_path,strcat(animal_id ,'48hrs ROI 0-100 MIP','.tiff')),'Resolution',600);
%exportgraphics(f3,fullfile(save_path,strcat(animal_id ,'48hrs ROI 0-100 MIP','.tiff')));
%saveas(f3,fullfile(save_path,strcat(animal_id ,'48hrs ROI 0-100 MIP','.tiff')));
close all







