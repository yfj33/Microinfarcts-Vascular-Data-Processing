%xml read CF
clc;
clear;
%go through the file and find all xml file
cd 

%call xml2struct function to convert to structure
CF=xml2struct('LineScan-04232021-1753-16-122.xml');
CF=STR2DOUBLE(CF);
%Get the micron/pixel value from structure CF
MP=CF.PVScan.PVStateShard.PVStateValue{1,12}.IndexedValue{1,2}.Attributes.value;
MP=STR2DOUBLE(MP);
% Get the frameperiod value from CF
FP=CF.PVScan.Sequence{1,3}.Frame.PVStateShard.PVStateValue{1,1}.Attributes.value;
%

