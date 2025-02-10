function [points,angle,velocity,V_avg,Theta_avg] = angle_velocity(grayscale_name)
%load the linescan plot and calculate the angle of the selected vector
% points give the coordinate of the selected points
%angle calculates the angle between them 
figure
imagesc(grayscale_name)
colormap gray
brush('on')
[x y]=getpts;%
points=[x y];
hold on
scatter(x,y,'filled','b');
npoints=size(points,1);%number of points selected
nangles=npoints/2;
txy=zeros(nangles,1)
angle=zeros(nangles,1);
 for i=1:nangles
     txy(i)=1/((points(2*i,2)-points(2*i-1,2))/(points(2*i,1)-points(2*i-1,1))); %y/x
     angle(i)=90-atand(abs(txy(i))); %arctan in degree
 end
 
 Theta_avg=mean(angle)% avg angle
 velocity=abs(txy)
 V_avg=mean(velocity);%avg velocity value
 
end

