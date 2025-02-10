function  [result] = MIP(data)
[x y z] = size(data);
result = max(data,[],3);
end
