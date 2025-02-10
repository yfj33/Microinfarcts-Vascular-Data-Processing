%regions = regionprops(segMask,'Area','PixelList');
%    regions = regionfilter(regions);
    %
 %   curResult = zeros(size(RawData));
%    n = length(regions);
  %  x = [1:1:n];
%    volume = [];
 %   for j = 1:n
 %       temp_list = regions(j).PixelList;
  %      temp_len = length(temp_list);
 %       volume = [volume temp_len];
  %      for m = 1:size(temp_list,1)
  %          curResult(temp_list(m,2),temp_list(m,1),temp_list(m,3)) = 1;
 %       end
 %   end
    %
%    curResult =uint8(255*curResult);
 %   n_slices = length(RawData(1,1,:));
 %   for j = 1: n_slices
  %      filename =  [selpathOut '\a' num2str(j) '.tif'];
 %       imwrite(curResult(:,:,j), filename )
 %   end
 clc;clear;close all
 I=imread('1.tif');
 I=im2uint16(I);
 %I=im2gray(I);
 %I=I-min(I(:));
 %I=I./max(I(:));
 f=fspecial('average',[3 3]);
 fn=filter2(f,I)
  %MCE and Huang
 I=uint8(fn)
[ILow, IHigh, threshold] = minCEP(I);

I(I<threshold)=0;
I(I>threshold)=255;
figure

colormap gray
imagesc(I) 
 
 figure
 colormap gray
imagesc(fn)
 figure;
colormap gray
 imagesc(I);
 Gauss_1=imgaussfilt(I,1);
 figure;
 imshow(Gauss_1);
 colormap gray
 W=wiener2(I,[7 7]);
 f=figure;
 imshow(W);
 T=graythresh(W);
 Ib=imbinarize(W,T);
 T2=graythresh(Gauss_1);
 Ig=imbinarize(Gauss_1,T2);
 figure
 imshow(Ib)
 saveas(f,'wiener1','tiffn')
 figure
 imshow(Ig)
 %binarize
 regions=regionprops(Ig,'Area','PixelList','FilledArea','BoundingBox')
 bd={regions.PixelList};
 for n=1:numel(bd)
     bd1=cell2mat(bd(1,n));
 x=bd1(:,1)
 y=bd1(:,2)
 hold on
 plot(x,y,'r')
 end
 %Test direct bi+region props
 T3=graythresh(I);
 bi=imbinarize(I,T3);
 regionb=regionprops(bi,'Area','PixelList','FilledArea','BoundingBox')
 figure
 imshow(bi)
 hold on
 b={regions.PixelList};
 for n=1:numel(b)
     b1=cell2mat(b(1,n));
 x=b1(:,1)
 y=b1(:,2)
 hold on
 plot(x,y,'r')
 end
 %MCE and Huang
 I=uint8(Gauss_1)
[ILow, IHigh, threshold] = minCEP(I);
Igb=I
Igb(I<threshold)=0;
Igb(I>threshold)=255;
figure
imshow(Igb,[min(Igb(:))  max(Igb(:))])
colormap gray


 

 