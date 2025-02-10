function  [result] = regionfilter(regions)
n = length(regions);
vol_threshold = 30;
result = regions;
for i = 1: n
    if regions(n-i+1).Area<= vol_threshold
        result(n-i+1)=[];
    end
end
% result = regions;
