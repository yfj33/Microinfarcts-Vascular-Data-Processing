%%The code aims to create circular and rectangular shape(user defined)
%%binary mask and calculate VF wihtin the defined mask region
clc;clear;close all
%mask_type='circular'; 
mask_type=2;%circular 1, polygon/circular 2
R=40; %radius of circle
n_scan=5;%number of z stack
n_site=2;%number of ROIs7
stroke_position=[800 300;400 400]%position of the center
z_step=50; %z-step slice number 50 slices=100um
%depth=[0:2*z_step:400];%depth
depth=[0:2*z_step:500];%depth up to 500um, add 400-500um depth

Flag=0;%Flag=0 load previous ROI file for VF calculation, Flag=1 redraw ROI


%select input source file
%week_info={'Baseline','Stroke','Day 3','Day 5','Day 7','Day 10','Week 2','Week 3'};
%week_info={'Baseline','Stroke','Day 3','Day 5','Day 7','Day 10','Week 2','Week 3','Week 4','Week 6','Week 8'};
%week_info={'Baseline','Stroke','Day 3','Day 5','Day 7'};

%week_info={'Baseline','Stroke','Day 3','Day 7','Week 2'};
%week_info={'Baseline','Stroke','Day 3','Day 5','Day 7','Day 10','Week 2'};
week_info={'Baseline','Stroke','Day 3','Day 5','Day 7'};
selpath=uigetdir('Select source directory containing scans');
%output filename for all the files
selpath_Processed=fullfile(selpath,'ProcessedStack');
%selpath_Figures=fullfile(selpath,'Figures');
selpath_Masks=fullfile(selpath,'Masks');
%selpath_Binary=fullfile(selpath,'BinarizedResult');
selpath_BiAmris=fullfile(selpath,'Binarized_v2');
%make output directory
selpath_MIP=fullfile(selpath,'MIP across depth');
mkdir(selpath_MIP);
selpath_MD=fullfile(selpath,'Mask Demo');
mkdir(selpath_MD);
selpath_VF=fullfile(selpath,'VF');
mkdir(selpath_VF);




%file name 
 %C1_dir=fullfile(selpath,'C1');
% C2_dir=fullfile(selpath,'C2');
 mask_dir=fullfile(selpath,'Mask');
%filename channel and mask
%C1_file=dir(C1_dir);
%C1_file(1:2)=[];

%C2_file=dir(C2_dir);
%C2_file(1:2)=[];
%processed stack name
P_Stack=dir(fullfile(selpath_Processed,'*.tif'));
%P_Stack(1:2)=[];

mask_file=dir(fullfile(mask_dir,'*.tif'));
%mask_file(1:2)=[];

%Binarized
%Bi_file=dir(selpath_Binary);
%Bi_file(1:2)=[];

Bi2_file=dir(fullfile(selpath_BiAmris,'*.tif'));
%Bi2_file(1:2)=[];

%pre-allocate mask vectors
FinalMask=cell(n_scan,1);

%Generate MIP of multiple depth every 100um (50 slices) for processed stack
%and masked stack using imageJ
for k=1:n_scan
    %processed stack
    P_Stack_name=P_Stack(k).name;
    P_Stack_path=fullfile(selpath_Processed,P_Stack_name);
    P_S=bfOpen3DVolume(P_Stack_path);
    P_S=double(P_S{1,1}{1,1});
    %Imaris masked stack
    A_Stack_name=Bi2_file(k).name;
    A_Stack_path=fullfile(selpath_BiAmris,A_Stack_name);
    A_S=bfOpen3DVolume(A_Stack_path);
    A_S=double(A_S{1,1}{1,1});
    
    
    MIP_folder=fullfile(selpath_MIP,P_Stack_name);
    
    mkdir(MIP_folder);

     for j=1:numel(depth)-1
         if j==numel(depth)-1

        % P_S_MIP=max(P_S(:,:,1+depth(j)/2:end),[],3);
        P_S_size=size(P_S,3);
        TT=1:1:P_S_size;
        Indx=ismember(TT,1+depth(j)/2:depth(j+1)/2);
        dpth=TT(Indx);
        P_S_MIP=max(P_S(:,:,dpth),[],3);
         
         P_S_MIP=ind2gray(P_S_MIP,gray(800));
         
         A_S_MIP=max(A_S(:,:,1+depth(j)/2:end),[],3);
         
         A_S_MIP=ind2gray(A_S_MIP,gray(800));
             
         % p=figure
         % imshow(P_S_MIP);
         % saveas(p,fullfile(MIP_folder,strcat('Processed Stack MIP Depth ',num2str(1+depth(j)/2),' to ',num2str(depth(j+1)/2))),'tiffn');
         % 
         % a=figure
         % imshow(A_S_MIP);
         %  saveas(a,fullfile(MIP_folder,strcat('Amaris Processed MIP Depth ',num2str(1+depth(j)/2),' to ',num2str(depth(j+1)/2))),'tiffn');
        else
         P_S_MIP=max(P_S(:,:,1+depth(j)/2:depth(j+1)/2),[],3);
         
         P_S_MIP=ind2gray(P_S_MIP,gray(800));
         
         A_S_MIP=max(A_S(:,:,1+depth(j)/2:depth(j+1)/2),[],3);
         
         A_S_MIP=ind2gray(A_S_MIP,gray(800));
         end       
         p=figure
         imshow(P_S_MIP);
         saveas(p,fullfile(MIP_folder,strcat('Processed Stack MIP Depth ',num2str(1+depth(j)/2),' to ',num2str(depth(j+1)/2))),'tiffn');
         
         a=figure
         imshow(A_S_MIP);
          saveas(a,fullfile(MIP_folder,strcat('Amaris Processed MIP Depth ',num2str(1+depth(j)/2),' to ',num2str(depth(j+1)/2))),'tiffn');
        

     close all;
    
end


%load pre-drawn masks from ImagJ
color_pool={'r','g','b','y','m'};
ROI_D=cell(n_site,n_scan);

if Flag==1
for i=1:n_scan
    mask_name=mask_file(i).name;
    mask_path=fullfile(mask_dir,mask_name);
    RawMask=bfOpen3DVolume(mask_path);
    RawMask=double(RawMask{1,1}{1,1});
    RawMask=255-RawMask;%invert mask, 0 is the selected region in fiji 255 nonselected region
    %RawMask(RawMask==255)=1;
    
    RefImage_name=P_Stack(i).name;
    RefImage_path=fullfile(selpath_Processed,RefImage_name);
    RefImage=bfOpen3DVolume(RefImage_path);
    RefImage=double(RefImage{1,1}{1,1});
    
    RefImage_MIP=max(RefImage,[],3);
    RefImage_MIP=ind2gray(RefImage_MIP,gray(800));
    
    RefImage_mid=RefImage(:,:,101:150);
    RefImage_mid_MIP=max(RefImage_mid,[],3);
    RefImage_mid_MIP=ind2gray(RefImage_mid_MIP,gray(800));
    
    [r c]=size(RawMask);
    ROI=false(size(RawMask));
   
    %add region to original mask
    
    if mask_type==1;
        for j=1:n_site;
        
            center_x=stroke_position(j,2);
            center_y=stroke_position(j,1);
            
            for x=1:c;
               for y=1:r;
                 if (x-center_x)^2+(y-center_y)^2<R^2 | (x-center_x)^2+(y-center_y)^2==R^2;
                     RawMask(x,y)=j*8+1;
                                  
                end
                end
              end
       end
        
    elseif mask_type==2;
       fig=figure;
       imshow(RefImage_mid_MIP,[]);
       for k=1:n_site
       drawpolygon('Color',color_pool{k}); %draw polygon mask
       
       end
       pause(30) ;
       saveas(fig,fullfile(selpath_MD,strcat('Mask MIP mid',mask_name)),'tiffn'); %save ROI on MIP for display
       
       %convert ROI to masks
       hfd=findobj(gca,'Type','images.roi.Polygon');
       
       for ind=1:numel(hfd)
           ROI_D{ind,i}=hfd(ind).createMask();
           ROI=ROI|hfd(ind).createMask(); %overlay mask 
          % boundaryLocation=hfd(ind).Position; %boundary coordinates
          % bInds=sub2ind(size(ROI),boundaryLocation(:,2),boundaryLocation(:,1)); %linear coordinates
           %ROI(bInds)=true;
          
           RawMask(ROI_D{ind,i}==1)=ind*5+1;
           
           %RawMask(ROI==1)=ind*5+1; %color not correct
       end
    end
       FinalMask{i}=RawMask;
       %display mask in RGB and save as tiff
       %RawMask=RawMask./max(RawMask(:)).*255
       temp_mask=ind2rgb(RawMask,jet(32));
       h=figure;
       imshow(temp_mask,[]);
       saveas(h,fullfile(selpath_MD,strcat('Mask ',mask_name)),'tiffn');
       close all
end
save(fullfile(selpath,'ROI masks.mat'),'ROI_D');
%Apply free hand Mask on binarized and calculate VF at different depth up
%to 500um evry 100um

elseif Flag==0 
    ROI_D=load(fullfile(selpath,'ROI masks.mat'));
    ROI_D=ROI_D.ROI_D;
end
    
    
%Precolate VF matrix, 5VF of different depth up to 500um
VF_ROI=zeros(n_site,n_scan,numel(depth)-1);
label={'Far Region','Stroke Region'};
for i=1:n_scan;
    B_S=Bi2_file(i).name;
        B_S_path=fullfile(selpath,'Binarized_v2',B_S);
        B_Stack=bfOpen3DVolume(B_S_path);
        B_Stack=double(B_Stack{1,1}{1,1});
        
    mask_name=mask_file(i).name;
    mask_path=fullfile(mask_dir,mask_name);
    RM=bfOpen3DVolume(mask_path);
    RM=double(RM{1,1}{1,1});
    RM=255-RM; %ZERO is probe and big vessel part
    for j=1:n_site;
        
        for k=1:numel(depth)-1;

        if k==numel(depth)-1
        %depth diff
        ma=double(ROI_D{j,i});
        ma(ma==0)=nan;
        %overlay regional mask with probe mask
        B_Stack_size=size(B_Stack,3);
        TT=1:1:B_Stack_size;
        Indx=ismember(TT,1+depth(k)/2:depth(k+1)/2);
        dpth=TT(Indx);
        BS_MIP=max(B_Stack(:,:,dpth),[],3);
        Im=B_Stack(:,:,1+depth(k)/2:end);  
        MA=ma.*RM;%Combine regional mask and probe ma
        MA(MA>0)=1;
        % VF_ROI(j,i,k)=nansum(Im_mask,[1 2 3])/(nansum(MA,[1 2])*size(Im,3));
        % Im_show=Im_mask(:,:,size(Im,3));
        % Im_mask=Im.*MA;%masked out region: REGIONAL mask first then probe mask
        else
        %depth diff
        ma=double(ROI_D{j,i});
        ma(ma==0)=nan;
        %overlay regional mask with probe mask
        Im=B_Stack(:,:,1+depth(k)/2:depth(k+1)/2);   
        MA=ma.*RM;%Combine regional mask and probe ma
        MA(MA>0)=1;
        % VF_ROI(j,i,k)=nansum(Im_mask,[1 2 3])/(nansum(MA,[1 2])*z_step);
        % Im_show=Im_mask(:,:,size(Im,3));
        end
        Im_mask=Im.*MA;%masked out region: REGIONAL mask first then probe mask  
        
        a=figure
        %Im_show=Im_mask(:,:,z_step);
        Im_show=Im_mask(:,:,ceil(size(Im_mask,3)/2));
        imshow(Im_show)
        Im_save=fullfile(selpath,'Mask of ROI',B_S,strcat('Mask ROI ',num2str(j)));
        mkdir(Im_save); 
        saveas(a,fullfile(Im_save,strcat(num2str(1+depth(k)/2),'to',num2str(depth(k+1)/2))),'tiffn');
        Im_mask(Im_mask>0)=1;
        VF_ROI(j,i,k)=nansum(Im_mask,[1 2 3])/(nansum(MA,[1 2])*size(Im_mask,3));
         %VF_ROI(j,i,k)=sum(Im_mask,[1 2 3])/(sum(ma,[1 2])*z_step);
        close all
         end
        end
        
    end
end
        
%save the VF across ROI at different depth
save(fullfile(selpath,'VF','VF_ROI.mat'),'VF_ROI');
%save mask as tif
save(fullfile(selpath,'FinalMask.mat'),'FinalMask');
        
%Plot across depth
t={'ROI 1','ROI 2','ROI 3'};
%c={'b','g','r'};
v=figure
for i=1:n_site   
        for k=1:numel(depth)-1
subplot(n_site,1,i)
plot([1:1:numel(week_info)],VF_ROI(i,:,k));
%legend('0-50','50-100','100-150','150-200','200-250','250-300','300-350','350-400','400-450','450-500')
legend('0-100um','100-200um','200-300um','300-400um','400-500um');
title(t{i});
xticks([1:1:numel(week_info)]);

hold on

xticklabels(week_info)
ylabel('volume fraction')
ylim([0 0.1])
        end
set(gca, 'fontsize', 20,'linewidth', 2);  
set(gca,'DataAspectRatio',[18 1 1]);
end


saveas(v,fullfile(selpath_VF,'VF'),'fig');
        
%plot average in the 
m=zeros(n_site,numel(week_info)); %mean vf of each day


    for i=1:n_site
        %subplot(1,n_site,i)
    %dep=VF_ROI(i,:,2:end-1);
    fg=figure
    dep=VF_ROI(i,:,2:end);
    m(i,:)=mean(dep,3);
    plot(1:1:numel(week_info),m(i,:),color_pool{n_site+1-i},'Linewidth',8);
    title(t{i});
    xticks([1:1:numel(week_info)]);
    
    %hold on
    xticklabels(week_info)
    ylabel('volume fraction')
      ylim([0.9*min(m(i,:)) 1.05*max(m(i,:))])
        set(gca, 'fontsize', 28,'linewidth', 1);  
        set(gca,'DataAspectRatio',[18 1 1]);
        axis normal
        saveas(fg,fullfile(selpath_VF,strcat('VF average across depth ',t{i})),'fig');
        close all
    end

%saveas(fg,fullfile(selpath_VF,'VF average across depth'),'fig');
save(fullfile(selpath_VF,'VF.mat'),'m');



                    
        
    
    
    






    
    


      
                    
        
    
    
    






    
    

