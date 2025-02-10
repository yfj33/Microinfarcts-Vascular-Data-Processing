% MinCEP is a function for thresholding using Minimum Cross Entropy 
% threshold selection of non-blank space of Image.
% 
% [ILow, IHigh, threshold] = minCEP(I)
% Inputs: I             2D grayscale image
%         minIntensity  
%         maxIntensity  
%
% Outputs: ILow       image with gray level bellow threshold
% Outputs: IHigh      image with gray level upper threshold
% Outputs: threshold  the threshold choosen by MinCE
%   
% Description: This code implements the paper: "Minimum cross-entropy
% threshold selection" by Brink and Pendock.c
% This implemetation is modified to calculate threshold of non-blank space
% of Image.
%
% Example:
% img = imread('mdb002_4.jpg');
% [ILow, IHigh, T] = minCEP(img);
% subplot(2,2,1), imshow(img);
% subplot(2,2,2), imshow(IHigh);
% [~, IHigh, T1] = minCEP(img, T);
% subplot(2,2,3), imshow(IHigh);
% [~, IHigh, T2] = minCEP(img, T2);
% subplot(2,2,4), imshow(IHigh);
%
%
% Coded by: Hoosein Dehghan (hd.dehghan@gmail.com)
%------------------------------------------------------------------------

function [ILow, IHigh, threshold] = minCEP(I, minIntensity, maxIntensity)
    if(~exist('maxIntensity','var'))
        maxIntensity = 256; 
    end
    if(~exist('minIntensity','var'))
        minIntensity = 0;
    end
    if nargin < 1
        disp('You must enter an Image');
    end
    I(I < minIntensity) = 0;
    I(I > maxIntensity) = 0;
    BW = I>0;
    h = imhist(I);

    %normalize the histogram ==>  hn(k)=h(k)/(n*m) ==> k  in [1 256]
    h(1) = [];
    hn = h/sum(sum(BW));

    sizeH = length(hn);
    imEntropy = sum((1:sizeH) .* hn' .* log(1:sizeH));

    for t = 1:sizeH
        %Low range image
        lowValue = 1;
        lowSum = sum(hn(1:t));
        if lowSum > 0
            lowValue = sum((1:t) .* hn(1:t)') / lowSum;
        end

        % High range image
        highValue = 1;
        highSum = sum(hn(t+1:sizeH));
        if highSum > 0
            highValue = sum((t+1:sizeH) .* hn(t+1:sizeH)') / highSum;
        end

        % Entropy of low range
        lowEntropy = sum((1:t) .* hn(1:t)' * log(lowValue));  

        % Entropy of high range 
        highEntropy = sum((t+1:sizeH) .* hn(t+1:sizeH)' ...
            * log(highValue));

        % Cross Entropy
        CE(t)= imEntropy - lowEntropy - highEntropy; 
    end

    [~, threshold] = min(CE);

    ILow = zeros(size(I));
    IHigh = zeros(size(I));
    ILow(I<threshold) = I(I<threshold);
    IHigh(I>threshold) = I(I>threshold);
    ILow = uint8(ILow);
    IHigh = uint8(IHigh);
end