function  [result]= cal_mean(data_outside)
[x y] = size(data_outside);
dy = 3;
y_min = ceil(y/2);
temp_data = data_outside(:, y_min - dy : y_min + dy);
temp_data2 = temp_data(:);
temp_data2(temp_data2<1) = [];
if length(temp_data2) == 0
    result = -100;
else
    result = mean(temp_data2);
end

end
