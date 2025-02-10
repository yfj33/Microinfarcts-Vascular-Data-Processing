function [RC,HCT] = RBC_HCT(foldername,PicNum)
%Calculate RBC Count and HC, input are foldername and Picture Number in the
%folder
%ImageJ result shows mean （1 window）+huang BINARIZATION gives best result
cd(foldername);
folder=foldername;
%mkdir()
%PicNum=43; %number of the pictures in the folder
% Prelocate zeros to store RBC number and Flux by algorithm and manually
RC=zeros(4,PicNum);
HCT=zeros(PicNum,3);
CF=CF_read(folder);
for k=1:PicNum
%CF=xlsread('CF') %read calibration factor Time from CF excel file, T_Per Pixel, Distance (um), D_T(pixels for distance)

frameperiod=[CF{k,1}];
%read image files from folder
tiffFilename=sprintf('%d.tif',k);
A=imread(tiffFilename);
A=uint16(A)
normA=A%normA is orginal figure
%%Normalizatio A=im2gray(A)
%I=imfinfo(tiffFilename)
%normA = A - min(A(:));
%normA = normA ./ max(normA(:));
figure(1)
colormap gray
imagesc(normA');

%Binarization of Image 0.3 as threshold
%Threshold=0.3;
%normA(normA>=Threshold)=255;
%normA(normA<Threshold)=0;
%normA=normA' %convert to x-t plot

%Mean Filter Median Filter and Gaussian 1 D filter window size 



%Pre-Process using filter
[Med_3,Mn_3,Gauss_1,Wie_7] = Filt_Pre(normA);

%Using 2 different binarization methods 8 bit
Med_3=uint8(Med_3);
Mn_3=uint8(Mn_3);
Gauss_1=uint8(Gauss_1);
Wie_7=uint8(Wie_7);
%Otsu

%MCE
[lo_med3, hi_med3, th_med3] = minCEP(Med_3);
[lo_mn3, hi_mn3, th_mn3] = minCEP(Mn_3);
[lo_gs3, hi_gs3, th_gs1] = minCEP(Gauss_1);
[lo_wn3, hi_wn3, th_wn7] = minCEP(Wie_7);

%Huang


%Rgional filter using regionprops overfilter-try it out later


%Binarization
Med_3B=Med_3;Mn_3B=Mn_3;Gauss_1B=Gauss_1;Wie_7B=Wie_7;

Med_3B(Med_3>th_med3)=255; Med_3B(Med_3<th_med3)=0;
Mn_3B(Mn_3>th_mn3)=255; Mn_3B(Mn_3<th_mn3)=0;
Gauss_1B(Gauss_1>th_gs1)=255; Gauss_1B(Gauss_1<th_gs1)=0;
Wie_7B(Wie_7>th_wn7)=255; Wie_7B(Wie_7<th_wn7)=0;


%HCT calculation
Pixel_Count=size(normA,1)*size(normA,2);
%Count the pixel intensity of 0
RBC_Pixel_Med=sum(sum(Med_3B==0));%Median 3
RBC_Pixel_Mn=sum(sum(Mn_3B==0));%Mean 3
RBC_Pixel_Gn=sum(sum(Gauss_1B==0));%Mean 3
RBC_Pixel_Wn=sum(sum(Wie_7B==0));%Wiener filter 7

%HCT=RBC_Pixel/Pixel Count
HCT(k,1)=RBC_Pixel_Med/Pixel_Count%median filter 3*3
HCT(k,2)=RBC_Pixel_Mn/Pixel_Count;%hct after mean 3*3 filter
HCT(k,3)=RBC_Pixel_Gn/Pixel_Count;%gaussian filter 1std
HCT(k,4)=RBC_Pixel_Wn/Pixel_Count;;%wiener filter 7

fig=figure(2);
subplot(1,5,1);
imagesc(normA);
subplot(1,5,2);
imshow(Med_3B);
subplot(1,5,3);
imshow(Mn_3B);
subplot(1,5,4);
imshow(Gauss_1B);
subplot(1,5,5);
imshow(Wie_7B);

saveas(fig,sprintf('Binarized and Filtered Image%d.fig',k));

%invert image to make RBC 255 bright and lumen 0 IM: inverted image
for b=1:size(Gauss_1B,1)
     IM(b,(find(Gauss_1B(b,:)==0))) = 1;
     IM(b,(find(Gauss_1B(b,:)==1))) = 0;
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
clear IM lineintersect normA A L1 L2
end

%save variable RC
xlswrite('RBC number and flux',RC)
%save HCT values
xlswrite('Hematocrit',HCT)

%Statistics and Plot of RBC Count and HCT
%M_RBC_Num=RC(3,:);%RBCnumber by hand
%M_RBC_Flux=RC(4,:);%RBCflux by hand
end

