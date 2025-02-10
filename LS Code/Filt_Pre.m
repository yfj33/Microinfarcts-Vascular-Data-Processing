function [Med_3,Mn_3,Gauss_1,Wie_7] = Filt_Pre(normI)
%PreProcess images using gaussian median mean filter, radius 1(3*3)

%median filter 3*3 window
Med_3 = medfilt2(normI, [3 3]);

%Mean filter 3*3
Mn_3=conv2(normI, ones(3)/9);
%[T_1,EM_1]=graythresh(Med_3)
%BI_Mn_3=imbinarize(Mn_3,T_1);

%Gaussian filter 1 sigma, give the best result according to literature at
%small kernal size 3*3 (1 sigma)
Gauss_1=imgaussfilt(normI,1);

%Wiener 7*7 filter 
Wie_7=wiener2(normI,[7 7]);


end

