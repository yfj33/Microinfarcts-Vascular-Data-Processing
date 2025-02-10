function [thetas,the_t,spread_matrix]=GetVelocityRadonFig_demo(data,windowsize);
%OUTPUTS
%thetas - the time varying agle of the space-time image
%the_t - time pointsof the angle estimates (in lines)
%spreadmatrix - matix of variances as a function of angles at each time point
%INPUTS
%data - the matrix of time X space data 
%windowsize - number of lines to use in estimating velocity. factor of y
%axis pixels 

stepsize=1/4*windowsize;
nlines=size(data,1);
npoints=size(data,2);
nsteps=(nlines-windowsize)/stepsize+1;
%nsteps=floor(nlines/stepsize)-3;
%find the edges
angles=(0:179);
angles_fine=-2:.25:2;

spread_matrix=zeros(nsteps,length(angles));
spread_matrix_fine=zeros(nsteps,length(angles_fine));
thetas=zeros(nsteps,1);

hold_matrix=ones(windowsize,npoints);
blank_matrix=ones(nsteps,length(angles));
the_t=NaN*ones(nsteps,1);

for k=1:nsteps
    the_t(k)=1+(k-1)*stepsize+windowsize/2;
    data_hold=data(1+(k-1)*stepsize:(k-1)*stepsize+windowsize,:);
    data_hold=data_hold-mean(data_hold(:))*hold_matrix;%subtract the mean for filtering 
    radon_hold=radon(data_hold,angles);%radon transform
    spread_matrix(k,:)=var(radon_hold);%take variance
    [m the_theta]=max(spread_matrix(k,:));%find max variace
    thetas(k)=angles(the_theta);     
    radon_hold_fine=radon(data_hold,thetas(k)+angles_fine);%re-do radon with finer increments around first estiamte of the maximum
    spread_matrix_fine(k,:)=var(radon_hold_fine);
    [m the_theta]=max(spread_matrix_fine(k,:));
    thetas(k)=thetas(k)+angles_fine(the_theta);
end
thetas=thetas-90; %rotate

