%Read image
%foldername=''
cd('C:\Users\Yifu Jin\Desktop\JYF PPT\Project\Stroke\data\3.30 aged\2021-05-25 2P\2021-05-25 Linescan Analysis')
I=imread('2.tif')
%Mean Filter
I=double(I);
normI = I - min(I(:));
normI = normI ./ max(normI(:));

%Medn=medfilt2(normI) %Median Filter
Meaf = conv2(normI, ones(3)/9); %Mean Filter
%I=rgb2gray('I')
[T EM]=graythresh(Meaf)
BI=imbinarize(Meaf,T);
%another median filter
BI_Med=medfilt2(BI)
figure
subplot(1,4,1)
imshow(normI)
subplot(1,4,2)
imshow(Meaf)
subplot(1,4,3)
imshow(BI)
subplot(1,4,4)
imshow(BI_Med)