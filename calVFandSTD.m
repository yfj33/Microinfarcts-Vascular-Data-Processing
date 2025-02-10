function  [vf,vf_std]= calVFandSTD(data)
x_num = length(data);
dx = 3;
x_min = ceil(x_num/2);
temp_data = data(x_min - dx : x_min + dx);
temp_data(temp_data<0) = [];
vf = mean(temp_data);
vf_std = std(temp_data);
end