function  [result] = backg_sub(data)
[x y z] = size(data);
result = zeros(x,y,z);
% se = strel('disk',3);
se = offsetstrel('ball',30,30);
for i = 1:z
    I = squeeze(data(:,:,i));
    J = imtophat(I,se);
%     dilatedI = imdilate(originalI,se);
%     J = imsubtract(imadd(I,imtophat(I,se)),imbothat(I,se));
    result(:,:,i)=J;
end
end
