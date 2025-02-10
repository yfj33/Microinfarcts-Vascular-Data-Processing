folder=foldername;
cd(foldername)
colormap gray
A=imread('20.tif');
A=double(A)
%%Normalizatio A=im2gray(A)

normA = A - min(A(:));
normA = normA ./ max(normA(:));

Med_5=medfilt2(normA,[5 5])
Med_3=medfilt2(normA)
Med_5_bi=imbinarize(Med_5)
Med_3_bi=imbinarize(Med_3)
Mea_5=conv2(normA, ones(5)/25);
Mea_5_bi=imbinarize(Mea_5)
figure
colormap gray
subplot(1,7,1)
imagesc(Med_5)
subplot(1,7,2)
imagesc(Med_5_bi)
subplot(1,7,3)
imagesc(Med_3)
subplot(1,7,4)
imagesc(Med_3_bi)
subplot(1,7,5)
imagesc(normA)
subplot(1,7,6)
imagesc(Mea_5)
subplot(1,7,7)
imagesc(Mea_5_bi)