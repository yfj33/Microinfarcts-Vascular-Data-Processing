function  [result] = adaptiveThresholding(data,s)
% use minCEP to binarize the image, and also apply region filter to remove
% isolated points (volume < 500)
[x y z] = size(data);
segMask = false(size(data));
for j = 1:z
    temp_slice = data(:,:,j);
    [temp_result mask]=segmentImage(temp_slice,s);
    temp_Mask = false(size(temp_slice));
    temp_Mask(temp_result>0)=1;
    segMask(:,:,j)=temp_Mask;
end
regions = regionprops(segMask,'Area','PixelList');
regions = regionfilter(regions);
%
curResult = zeros(size(data));
n = length(regions);
volume = [];
for j = 1:n
    temp_list = regions(j).PixelList;
    temp_len = length(temp_list);
    volume = [volume temp_len];
    for m = 1:size(temp_list,1)
        curResult(temp_list(m,2),temp_list(m,1),temp_list(m,3)) = 1;
    end
end
%
result =uint8(255*curResult);

end
