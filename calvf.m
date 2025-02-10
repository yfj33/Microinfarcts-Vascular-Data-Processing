function  [result] = calvf(data,x_size,fov,window_size)
% temp_c2data(n,m,p) = -100;% m -> 700,n->100
% delete <0 element
[x y z]= size(data);
data(data>0)=1;
% size_result = ceil(y/x_size);
size_result = round(fov/window_size);
result = zeros(size_result,1);
for i = 1:size_result
    index_start = (i-1)*x_size+1;
    index_end = i*x_size;
    if index_end >y
        index_end = i;
    end
    temp_data = data(:,index_start:index_end,:);
    temp_list = temp_data(:);
    temp_list(temp_list < 0) = [];
    if length(temp_list) == 0
        result(i)= -100;
    else
        result(i)=100*mean(temp_list);
    end
end
end

