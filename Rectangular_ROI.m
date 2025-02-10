function [ModMask] = Rectangular_ROI(mask,ref_image,ROIs,d)
% Generate rectangular mask based on where center coordinates are
% Output modified mask  
%Input: mask file, reference image for chooseing ROI,ROIs number

%show reference MIP image


k=0;

box_size=[d d];
cords=cell(1,ROIs);

I=imshow(ref_image)
I.ButtonDownFcn= @(~,~) buttonPressedCallback(I.Parent); %control axis properties

    function buttonPressedCallback(hAx)
        cp=hAx.CurrentPoint;
        cords{k+1}=[cp(1,1) cp(1,2)];
        ROI=images.roi.Rectangle('Parent',hAx,'Color',rand([1,3]),'Position',[cords{k+1}(1),cords{k+1}(2),box_size(1),box_size(2)]);
        %label=sprintf('ROI%d',k+1);
        BW=createMask(ROI);
        mask(BW==1)=0;
        
        k=k+1;
         if k==ROIs
             fprintf('Selection Complete')
             pause(10)
             close all
         end
     return    
    end
        
ModMask=mask
end

 