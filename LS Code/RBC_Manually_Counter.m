function [M_RBC_Flux,M_RBC_Num]=RBC_Manually_Counter(grayscale_name,frameperiod)
%load grayscale linescan plot and manually count the dark stripes, then
%calculate the RBC/s
%input:image name, frameperiod
%output:flux (RBC/s)
figure
imagesc(grayscale_name)
colormap gray
brush('on')%interactively select data points 
[x y]=getpts;%select xy coordinate
points=[x y];
hold on
scatter(x,y,'filled','b')
M_RBC_Num=size(points,1)%number of point selected is how many RBCs 
M_RBC_Flux=M_RBC_Num/frameperiod;

end

