clc;
clear ;
close all;
folder='C:\Users\Yifu Jin\Desktop\JYF PPT\Project\Stroke\data\1.4 aged\4.23.2021 Linescan\4.23.2021 Linescan Analysis'
PicNum=43; %number of the pictures in the folder
% Prelocate zeros to store RBC number and Flux by algorithm and manually
RC=zeros(4,PicNum);
HCT=zeros(PicNum,1);
for k=1:PicNum
CF=xlsread('CF') %read calibration factor Time from CF excel file, T_Per Pixel, Distance (um), D_T(pixels for distance)

frameperiod=CF(k,1);
%read image files from folder
tiffFilename=sprintf('%d.tif',k);
A=imread(tiffFilename);
A=double(A)
%%Normalizatio A=im2gray(A)
I=imfinfo(tiffFilename)
normA = A - min(A(:));
normA = normA ./ max(normA(:));
figure(1)
colormap gray
imagesc(normA')

%Binarization of Image 0.3 as threshold
Threshold=0.3;
normA(normA>=Threshold)=255;
normA(normA<Threshold)=0;
normA=normA' %convert to x-t plot

%HCT calculation
Pixel_Count=size(normA,1)*size(normA,2);
% intensity with 0 are dark RBC
RBC_Pixel=sum(normA(:,:)==0);
%HCT=RBC_Pixel/Pixel Count
HCT(k,1)=RBC_Pixel/Pixel_Count;

figure(2)
colormap gray
imagesc(normA)
%invert image to make RBC 255 bright and lumen 0 IM: inverted image
for b=1:size(normA,1)
     IM(b,(find(normA(b,:)==0))) = 1;
     IM(b,(find(normA(b,:)==255))) = 0;
     IM(b,(find(IM(b,:)==1))) = 255;
end %end of loop linescan rows

figure(3)
colormap gray
imagesc(IM)
%Window Size has to do with frameperiod 256 lines/frame, here just take one
%frame (300ms) as a window then divide by frameperiod to get # of RBC Flux

%Take the middle a few (4) rows of LS to average to get a row vector 1*width of
%each column
imIntensityCurve=mean(IM(round(size(IM,1))/2-2:round(size(IM,1)/2)+2,:),1);


%Creat a threshold line to intersect with the set threshold
%threshold >0, there is RBC signal, each threshold intersect with intensity
%curve twice and the RBC should be divided by 2
IntensityCurve_threshold=175;
thresholdPlot=ones(size(imIntensityCurve))*IntensityCurve_threshold;

%Find where intensity curve intersects with the threshold plot
L1(1,:)=[1:size(imIntensityCurve,2)];%intensity curve data point
L1(2,:)=imIntensityCurve; %Intensity Curve
L2(1,:)=[1:size(imIntensityCurve,2)];
L2(2,:) = thresholdPlot;
[lineIntersects] = InterX(L1,L2);
rbcNum=round(size(lineIntersects,2)/2);
rbcFlux=rbcNum/frameperiod;

figure(4)
colormap gray
imagesc(imIntensityCurve)

figure(5)
plot(L1(1,:),L1(2,:),'r')
hold on
plot(L2(1,:),L2(2,:),'b')
legend('intensity curve','threshold line')
title([num2str(rbcFlux),'RBC/s']);

%Manually count the RBC/s
[M_RBC_Flux,M_RBC_Num]=RBC_Manually_Counter(A',frameperiod)
Word=sprintf('There are %d RBCs in this picture and the flux is %d RBC/s',M_RBC_Num,M_RBC_Flux)
%store RBC count and flux by two methods in RC for this Pic
RC(1,k)=rbcNum; %RBCnumber by AI
RC(2,k)=rbcFlux;%RBC FLUX by AI
RC(3,k)=M_RBC_Num;%RBCnumber by hand
RC(4,k)=M_RBC_Flux;%RBCflux by hand

close all
clear IM lineintersect normA A
end

%save variable RC
xlswrite('RBC number and flux',RC)
%save HCT values
xlswrite('Hematocrit',HC)

%Statistics and Plot of RBC Count and HCT
%M_RBC_Num=RC(3,:);%RBCnumber by hand
%M_RBC_Flux=RC(4,:);%RBCflux by hand



