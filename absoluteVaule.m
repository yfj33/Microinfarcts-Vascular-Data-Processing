function  [result] = absoluteVaule(data)
% use minCEP to binarize the image, and also apply region filter to remove
% isolated points (volume < 500)
[x y z] = size(data);
segMask = false(size(data));
for j = 1:z
    temp_slice = data(:,:,j);
    exp = uint8(round(255*(temp_slice/max(max(temp_slice)))));
    [ILow, IHigh, T] = minCEP(exp);
    temp_Mask = false(size(temp_slice));
%         expectation = zhongshu2(exp);
%         if(length(expectation)>1)
%             expectation=expectation(1);
%         end
%         min_value = min(min(exp));
%         thr_mode = expectation + expectation -min_value;%+uint8(1);
    temp_Mask(IHigh>0)=1;
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
