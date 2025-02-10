function [BW,maskedImage] = segmentImage(X,s)
%segmentImage Segment image using auto-generated code from imageSegmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the imageSegmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 10-Dec-2021
%----------------------------------------------------


% Adjust data to span data range.
X = imadjust(X);

% Threshold image - adaptive threshold
BW = imbinarize(X, 'adaptive', 'Sensitivity', s, 'ForegroundPolarity', 'bright');

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
end

