function  [result] =  AverageActVaule(data)
[x y z] = size(data);
result = zeros(z,1);
for i = 1:z
    temp_data = squeeze(data(:,:,i));
    thr = mean(temp_data(:));
    temp_a = temp_data(:);
    temp_a(temp_a<thr)=[];
    result(i)=mean(temp_a);
end
end

