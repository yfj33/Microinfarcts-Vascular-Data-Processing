function  [result]= cal_time_mean(data)
[x y] = size(data);
result = zeros(y,1);
for i = 1:y
    temp_data = data(:,i);
    temp_data(temp_data<0) = [];
    result(i) = mean(temp_data);
end
end
