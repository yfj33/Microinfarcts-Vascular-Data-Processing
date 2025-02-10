function  [result] =  return_mask(Shadow_Mask,position,fov,nprobes)
[x y]= size(Shadow_Mask); %fiji 1024*1024 FOV 1120um
dx = fov/x; %um/pixel
temp_mask = zeros(x,y);
temp_mask = temp_mask+1;
[n d] = size(position);
x1_width = 700;
y1_width = 120;
x2_width = 180; %x2_width=700um
x1 = round(x1_width/(2*dx));%700um/(2*dx) pixels# 350um +/- center
y1 = round(y1_width/(2*dx));%60um
x2 = round(x2_width/(2*dx));

for m = 1:n-1
    center_x = position(m,2);
    center_y = position(m,1);
    start_x = center_x - x1;%half
    x_end = center_x + x1;
    start_y = center_y - y1;
    y_end = center_y+y1;
    if start_x < 1
        start_x = 1;%position outside of image
    end
    if start_y < 1
        start_y = 1;
    end
    if x_end >x
        x_end = x;
    end
    if y_end >y
        y_end = y;
    end

    for i = start_x:x_end
        for j = start_y:y_end
            temp_mask(i,j)=3+(m-1)*2;
        end
    end

    start_x = center_x - y1;
    x_end = center_x + y1;
    start_y = center_y - x1;
    y_end = center_y+x1;
    if start_x < 1
        start_x = 1;
    end
    if start_y < 1
        start_y = 1;
    end
    if x_end >x
        x_end = x;
    end
    if y_end >y
        y_end = y;
    end

    for i = start_x:x_end
        for j = start_y:y_end
            temp_mask(i,j)=3+(m-1)*2;
        end
    end
end
x1 = x2;
for m = n:n
    center_x = position(m,2);
    center_y = position(m,1);
    start_x = center_x - x1;
    x_end = center_x + x1;
    start_y = center_y - y1;
    y_end = center_y+y1;
    if start_x < 1
        start_x = 1;
    end
    if start_y < 1
        start_y = 1;
    end
    if x_end >x
        x_end = x;
    end
    if y_end >y
        y_end = y;
    end

    for i = start_x:x_end
        for j = start_y:y_end
            temp_mask(i,j)=3+(m-1)*2;
        end
    end

    start_x = center_x - y1;
    x_end = center_x + y1;
    start_y = center_y - x1;
    y_end = center_y+x1;
    if start_x < 1
        start_x = 1;
    end
    if start_y < 1
        start_y = 1;
    end
    if x_end >x
        x_end = x;
    end
    if y_end >y
        y_end = y;
    end

    for i = start_x:x_end
        for j = start_y:y_end
            temp_mask(i,j)=3+(m-1)*2;
        end
    end
end
% 
% % r1_width = 50;
% % r2_width = 225;
% % r1 = round((r1_width/dx));
% % r2 = round((r2_width/dx));
% % r3 = 30;
% for i = 1:x
%     for j = 1:y
%         distance = [];
%         for m = 1:n-1
%             center_x = poisition(m,2);
%             center_y = poisition(m,1);
%             temp_distance = power(((i-center_x)^2+(j-center_y)^2),0.5);
% %             if center_x <0
% %                 temp_distance = 1000000;
% %             end
%             distance = [distance temp_distance];
%         end
%         min_distance = min(distance);
%         a=find(distance == min_distance);
%         if length(a)>1
%             a = min(a);
%         end
%         if min_distance < r1
%             temp_mask(i,j)=3+(a-1)*4;
%         elseif min_distance <r2
%             temp_mask(i,j)=5+(a-1)*4;
%             %         elseif min_distance <r3
%             %             temp_mask(i,j)=6;
%         end
%     end
% end
result = temp_mask;
result(Shadow_Mask>0)=3+n*2;

end