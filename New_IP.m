function  [result variance] = New_IP(data)
[x y z] = size(data);
min_thr = 2;
high_thr = 9;
result = zeros(y,1);
variance = zeros(y,1);
for i = 1:y
    temp_data = data(:,i,:);
    temp_data(temp_data<min_thr) = -100;
    temp_data(temp_data>high_thr) = -100;
    temp_a = temp_data(:);
    temp_a(temp_a < 0) = []; 
%     if length(temp_a)== 0
%         result(i) = 0;
%         variance(i)
%     else
    result(i) = mean(temp_a);
    variance(i) = std(temp_a);
%     end
end