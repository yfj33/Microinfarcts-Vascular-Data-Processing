function  [result] = blurImage(data,radius)
[x y z] = size(data);
if z>200
    MIP_slice = MIP(data(:,:,51:200));
else
    MIP_slice = MIP(data(:,:,51:z));
end
sigma = radius*1;
result = imgaussfilt(MIP_slice,sigma);

end
