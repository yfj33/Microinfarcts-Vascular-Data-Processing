function [Cali_Factor] = CF_read(foldername)
%
%  
%xml read Calibration Factor

%go through the file and find all xml file in the foldername folder
cd(foldername)

subfoldername=dir(foldername); %Read the name of subfolders
dirFlags=[subfoldername.isdir]; %a logical vector tells which one is a directory
subfoldername=subfoldername(dirFlags); %list those are directory
subfoldername = subfoldername(~ismember({subfoldername(:).name},{'.','..'})); %get rid of the .,..
%loop through subfolder and find xml files
sfn=struct2cell(subfoldername);
sfn=sfn(1,:); %name of all the files
sfn=natsortfiles(sfn);%file name in sequence
num=length(sfn);
%Creat a matrix to store all the Cali factor, depth info and sequence info
Cali_Factor=cell(num,4);
%Create expression to  extract the substrings using named
%tokens
expression=['(?<labelnum>\d+)-(?<LSinfo>\w+)-(?<depth>\d+)-(?<ProbeN>\w+)'];
%expression=['(?<labelnum>\d+)-(?<LSinfo>\w+)-(?<numone>\d+)-(?<numtwo>\d+)-(?<depth>\d+)-(?<ProbeN>\w+)'];
%expression=['(?<labelnum>\d+)-(?<LSinfo>\w+)-(?<first>\d+)-(?<depth>\d+)-(?<seq>\d+)'];
%expression=['(?<labelnum>\d+)-(?<LSinfo>\w+)-(?<first>\d+)-(?<depth>\w+)-(?<seq>\d+)'];
for i=1:num
    
    subfolder=sfn{1,i};
    cd(subfolder);%go to subfolder iinescan data
    XML=dir('*.xml') %read xml file name
%call xml2struct function to convert to structure
CF=xml2struct(XML.name); %read xml file and convert to structure CF

%Get the micron/pixel value from structure CF
MP=CF.PVScan.PVStateShard.PVStateValue{1,12}.IndexedValue{1,2}.Attributes.value;
MP=str2double(MP);
% Get the frameperiod value from CF
try
FP=CF.PVScan.Sequence.Frame.PVStateShard.PVStateValue{1,1}.Attributes.value;
catch
    warning('wrong execution')
end

try
FP=CF.PVScan.Sequence{1,1}.Frame.PVStateShard.PVStateValue{1,1}.Attributes.value
catch
    warning('wrong execution')
end
FP=str2double(FP);
%Store Califactor in matrix
Cali_Factor{i,1}=FP;
Cali_Factor{i,2}=MP;
cd('..');
%Capture Substring, sequence and depth information
tokenNames=regexp(subfolder,expression,'names')
lbn=extractfield(tokenNames,'labelnum');%capture label number and extract from field
dpth=extractfield(tokenNames,'depth');%capture depth and extract from field
proben=extractfield(tokenNames,'ProbeN');%probe number

lbn=str2double(lbn);
dpth=str2double(dpth);
%dpth=str2double(dpth{2:end});
Cali_Factor{i,3}=dpth;
Cali_Factor{i,4}=proben;
end

%Lastly arrange based on the label number using sortrows
%Cali_Factor_Sort=sortrows(Cali_Factor,4);

%xlswrite('CF',Cali_Factor_Sort);
xlswrite('CF',Cali_Factor);



