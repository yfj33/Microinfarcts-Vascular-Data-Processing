function  [result] = regionfilter(regions)
n = length(regions);
vol_threshold = 500;
result = regions;
[temp,index]=sort([regions.Area],'descend');
result = result(index);
for i = 1: n
    if result(i).Area<= vol_threshold
        break;
    end
end
result = result(1:i);
% result = regions;
