function [f f1 f2] = xyzMIP(depth)
%Generate MIP images of fullframe XY and side view as well
%Define the depth based on depth information, depth has z step of 2um
close all
savepath=fullfile(pwd,'XYZ MIP');
if ~ exist(savepath)
    mkdir(savepath);
end

dataname=dir('*.tif');
%dataname(1:2)=[];

for i=1:numel(dataname)
datapath=fullfile(pwd,dataname(i).name);
data=bfOpen3DVolume(datapath);
data=double(data{1,1}{1,1});
data=data(:,:,1:depth);
xlen=size(data,1);
ylen=size(data,2);
zlen=size(data,3);

%%define damage region, centroid and radius
%Reference Image MIP of 150 to 300 um to identify the damaged region
RefImage=max(data(:,:,100:150),[],3);
RefImage=ind2gray(RefImage,gray(800));
f=figure;
imshow(RefImage,[]);
hold on
roi=drawpolygon('Color','r');
pause(20);
xb=roi.Position(:,1);
yb=roi.Position(:,2);
polyin=polyshape(xb,yb);
[xc yc]=centroid(polyin); %centeroid of the roi
%[xb yb]=boundary(roi); %boundary of the rois



%find the largest distance in xy direction and set that as the thickness to squeeze
dx=abs(xb-xc);
dy=abs(yb-yc);
%D=dx^2+dy^2; %distnace from boundary to centroid
[Mdx Ix]=max(dx);
[Mdy Iy]=max(dy);
%find the thickness to squeeze in: from center to x or y coordinates as half the
%coordx=[round(xc-Mdx):round(xc+Mdx)];
%coordy=[round(yc-Mdy):round(yc+Mdy)];

%coordx=1025-round([min(xb):1:max(xb)]);
coordx=round([min(xb):1:max(xb)]);
%coordy=1025-round([min(yb):1:max(yb)]);
coordy=round([min(yb):1:max(yb)]);
%data_MIP_XZ=max(data(coordx,:,:),[],1); % squeeze x dimension
data_MIP_XZ=max(data(coordy,:,:),[],1); % squeeze x dimension
data_MIP_XZ_t=permute(data_MIP_XZ,[3 2 1]); %transpose and display
%data_MIP_XZ_t=squeeze(data_MIP_XZ);

%data_MIP_YZ=max(data(:,coordy,:),[],2); % squeeze y dimension
data_MIP_YZ=max(data(:,coordx,:),[],2); % squeeze y dimension
data_MIP_YZ_t=permute(data_MIP_YZ,[3 1 2]); %transpose and display
%data_MIP_YZ_t=squeeze(data_MIP_YZ);

plot(xc,yc,'.g','MarkerSize',50);
%rectangle('Position',[0,yc-Mdy,xlen,2*Mdy],'FaceColor',[0,0,1,0.3]);
%rectangle('Position',[xc-Mdx,0,2*Mdx,ylen],'FaceColor',[0,1,1,0.3]);
rectangle('Position',[0,min(yb),xlen,abs(max(yb)-min(yb))],'FaceColor',[0,0,1,0.3]);

rectangle('Position',[min(xb),0,abs(max(xb)-min(xb)),ylen],'FaceColor',[0,1,1,0.3]);
%rectangle('Position',[min(xb),min(yb),abs(max(xb)-min(xb)),abs(max(yb)-min(yb))],'FaceColor',[0,1,1,0.3]);

hold off

%data_MIP_XZ_ad=imadjust(data_MIP_XZ_t,[0.1 0.9],[]);
data_MIP_XZ_ad=ind2gray(data_MIP_XZ_t,gray(10000)); % squeeze x dimension
%data_MIP_YZ_ad=imadjust(data_MIP_YZ_t,[0.1 0.9],[]);
data_MIP_YZ_ad=ind2gray(data_MIP_YZ_t,gray(10000));% squeeze y dimension


f1=figure;
imshow(data_MIP_XZ_ad,[]);
title('XZ Plane MIP','FontSize',25); % XZ plane MIP

f2=figure;
imshow(data_MIP_YZ_ad,[]);
title('YZ Plane MIP','FontSize',25); % YZ plane MIP


% save side projection in orginal size and tiff format
saveas(f,fullfile(savepath,strcat('Damage Region','',dataname(i).name)),'tiff');

%saveas(f,strcat('Damage Region','',dataname(i).name))
imwrite(data_MIP_XZ_ad,fullfile(savepath,strcat('XZ MIP',' ',dataname(i).name)),'tiff');
imwrite(data_MIP_YZ_ad,fullfile(savepath,strcat('YZ MIP',' ',dataname(i).name)),'tiff');

close all
end

end