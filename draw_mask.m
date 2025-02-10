% the following paramters are used to set up the location of the probes or
% the stroke regions. It is the result directed read from the FIJI
% % Probe Poisition - 0413
% name = '04-13';
% n_scans = 5;
% number_of_probes = 3;
% poisition_probe = cell(n_scans,1);
% poisition_probe{1} = [469,624;693,585;918,573];
% poisition_probe{2} = [418,566;596,532;830,470];
% poisition_probe{3} = [418,562;652,534;861,486];
% poisition_probe{4} = [422,641;652,576;958,549];
% % poisition_probe{5} = [196,737;440,702;722,673];
% poisition_probe{5} = [180,742;416,669;734,661];
% % poisition_probe{7} = [240,461;506,402;793,396];
% 
% fov_all = [1400 1400 1400 1120 1120 1120 1120];
% number_of_site = 3;
% legend_a = {"Baseline","2 Ws","3 Ws","4 Ws","5 Ws","6 Ws","8 Ws"};

% % Probe Poisition - 0601
% name = '06-01';
% number_of_probes = 2;
% n_scans = 2;
% poisition_probe = cell(n_scans,1);
% poisition_probe{1} = [872,668;620,354];
% poisition_probe{2} = [793,605;738,157];
% 
% fov_all = [1120 1120];
% vessel_ratio = [1 1 1 1 1 1 1 1];
% number_of_site = 2;
% legend_a = {"Baseline","6 Ws"};

% Probe Poisition - 0531
% name = '05-31';
% number_of_probes = 4;
% n_scans = 4;
% poisition_probe = cell(n_scans,1);
% poisition_probe{1} = [402,598;709,641;840,533;278,176];
% poisition_probe{2} = [390,625;710,681;838,564;364,333];
% poisition_probe{3} = [406,620;698,668;800,545;300,196];
% poisition_probe{4} = [412,633;705,664;802,558;296,205];
% 
% fov_all = [1120 1120 1120 1120];
% vessel_ratio = [1 1 1 1 1 1 1 1];
% number_of_site = 4;
% legend_a = {"Baseline","1 W","2 Ws","3 Ws"};


% % Probe Poisition - 0507
% name = '05-07';
% number_of_probes = 2;
% poisition_probe = cell(n_scans,1);
% poisition_probe{1} = [236,400;702,385];
% poisition_probe{2} = [149,410;642,400];
% poisition_probe{3} = [121,352;603,385];
% poisition_probe{4} = [137,365;597,365];
% 
% fov_all = [1120 1120 1120 1120];
% vessel_ratio = [1 1 1 1 1 1 1 1];
% number_of_site = 2;
% legend_a = {"2 Ws","3 Ws","4 Ws","5 Ws"};

% % Probe Poisition - 0104
% name = '01-04';
% number_of_probes = 3;
% poisition_probe = cell(n_scans,1);
% poisition_probe{1} = [360,594;644,590;862,612];
% poisition_probe{2} = [350,536;598,522;820,568];
% poisition_probe{3} = [352,564;570,614;770,638];
% poisition_probe{4} = [326,606;510,656;710,702];
% poisition_probe{5} = [336,580;538,626;720,658];
% poisition_probe{6} = [287,569;507,629;701,670];
% 
% fov_all = [1120 1120 1400 1400 1400 1400];
% vessel_ratio = [1 1 1 1 1 1 1 1];
% number_of_site = 3;
% legend_a = {"Baseline","1 W","2 Ws","3 Ws","4 Ws","7 Ws"};

% % Probe Poisition - 0103
% name = '01-03';
% number_of_probes = 3;
% n_scans = 6;
% poisition_probe = cell(n_scans,1);
% poisition_probe{1} = [390,594;600,544;834,386];
% poisition_probe{2} = [370,624;600,564;872,380];
% poisition_probe{3} = [398,582;536,534;766,468];
% poisition_probe{4} = [388,654;502,620;742,540];
% poisition_probe{5} = [332,730;438,698;668,606];
% poisition_probe{6} = [309,649;436,622;654,553];
% 
% fov_all = [1120 933.3 1400 1400 1400 1400];
% vessel_ratio = [1 1 1 1 1 1 1 1];
% number_of_site = 3;
% legend_a = {"Baseline","1 W","2 Ws","3 Ws","4 Ws","6 Ws"};

% % Probe Poisition - 1231
% name = '12-31';
% number_of_probes = 3;
% poisition_probe = cell(n_scans,1);
% poisition_probe{1} = [358,560;570,566;730,436];
% poisition_probe{2} = [448,546;628,550;768,496];
% poisition_probe{3} = [354,566;480,578;788,478];
% poisition_probe{4} = [368,674;510,690;826,608];
% poisition_probe{5} = [360,780;504,798;814,712];
% poisition_probe{6} = [384,796;512,813;836,749];
% 
% fov_all = [1120 1120 1400 1400 1400 1400];
% % vessel_ratio = [1 1 1 1 1 1 1 1];
% number_of_site = 3;
% legend_a = {"Baseline","1 W","2 Ws","3 Ws","4 Ws","6 Ws"};


% localation information
% 0720
name = '09-05';
n_scans = 8;
number_of_probes = 2; % 2 probe poisitions and 1 outside probe poisitions
poisition_probe = cell(n_scans,1);
poisition_probe{1} = [903,340; 310,192];
poisition_probe{2} = [925,336;310,205];
poisition_probe{3} = [890,367;258,223];
poisition_probe{4} = [873,348;275,195];
poisition_probe{5} = [913,327;300,211];
poisition_probe{6} = [887,327;275,226];
poisition_probe{7} = [905,325;289,215];
poisition_probe{8} = [906,308;282,260];

fov_all = [1120 1120 1120 1120 1120 1120 1120 1120];
vessel_ratio = [1 1 1 1 1 1 1 1];
number_of_site = 2;
legend_a = {"Baseline","48hrs","96hrs","1 Wk","D 10","2 Wk","3 Ws","4 Wk"};
time_list = [0,1,2,3,4,5,6,7];

% % %07-07
% name = '07-07';
% number_of_probes = 5;
% n_scans = 7;
% poisition_probe = cell(7,1);
% poisition_probe{1} = [242 424;476 494;684 462;982 452;808,842];
% poisition_probe{2} = [170 460;422 488;640 428;922 434;820,825];
% poisition_probe{3} = [208 520;516 448;710 438;906 448;738,754];
% poisition_probe{4} = [236,506;520,450;730,444;938,452;784,752];
% poisition_probe{5} = [212 470;522 452;732 442;986 518;724,753];
% poisition_probe{6} = [150 518;436 434;608 434;794 452;745,758];
% poisition_probe{7} = [160 520;478 420;664 412;820 416;794,736];
% % （150,518）,(436,434),(608,434),(794,452)
% 
% fov_all = [1120 1120 1120 1120 1120 1120 1120];
% % vessel_ratio = [2 1.4 1.6 1.7 1.6 2.5 2.5];
% number_of_site = 5;
% legend_a = {"Baseline","1 w","2 Ws","3 Ws","4 Ws","5 Ws","6 Ws"};
% time_list = [0,1,2,3,4,5,6];
% n_scans = 7;
% 
% %07-28
% name = '07-28';
% poisition_probe = cell(7,1);
% n_scans = 7;
% poisition_probe{1} = [168 604; 474 596; 234,342];
% poisition_probe{2} = [156 558; 424 600; 337,296];
% poisition_probe{3} = [214 546; 486 592; 237,284];
% poisition_probe{4} = [172 562; 506 594; 229,292];
% poisition_probe{5} = [200 554; 432 572; 194,288];
% poisition_probe{6} = [170 542; 406 576; 237,292];
% poisition_probe{7} = [190 526; 428 566; 254,294];
% % 
% fov_all = [1120 1120 1120 1120 1120 1120 1120 1120];
% % vessel_ratio = [1.55 1.29 1.51 1.42 1.53 1.46 1.50]; % no need now
% number_of_site = 3;
% legend_a = {"Baseline","1 w","2 Ws","3 Ws","4 Ws","5 Ws","6 Ws"};
% time_list = [0,1,2,3,4,5,6];

% % % 03-30
% n_scans = 7;
% name = '03-30';
% number_of_probes = 4;
% poisition_probe = cell(n_scans,1);
% poisition_probe{1} = [208,605;602 598;770 616;744,321];
% poisition_probe{2} = [229,557;586 542;788 566;849,436];
% poisition_probe{3} = [236,534;594 534;778 566;861,466];
% poisition_probe{4} = [153,498;524 510;704 520;802,385];
% poisition_probe{5} = [197,526;556 490;764 478;800,289];
% poisition_probe{6} = [157,516;536 548;726 558;801,430];
% poisition_probe{7} = [192,448;502 484;698 510;738,364];
% % poisition_probe{1} = [202 582;602 598;770 616];
% % poisition_probe{2} = [220 536;586 542;788 566];
% % poisition_probe{3} = [232 526;594 534;778 566];
% % poisition_probe{4} = [158 510;524 510;704 520];
% % poisition_probe{5} = [134 520;556 490;764 478];
% % poisition_probe{6} = [114 520;536 548;726 558];
% % poisition_probe{7} = [82 440;502 484;698 510];
% % poisition_probe{8} = [92 434;518 486;712 494];
% 
% fov_all = [1400 1400 1400 1400 1400 1400 1400];
% number_of_site = 4;
% legend_a = {"Baseline","1 w","2 Ws","3 Ws","4 Ws","5 Ws","6 Ws","8 Ws"};
% time_list = [0,1,2,3,4,5,6];

% Set up the path of the input and output
% Set up directory
% select the folder contains 'C1','C2','Mask'
selpath = uigetdir('Select source directory containing scans');
% Output dir, it will generate the 'ProcessedStack', 'Figures' and 'BeforeBinary'
selpathOut = fullfile(selpath,'ProcessedStack');
selpathOut_figures = fullfile(selpath,'Figures');
selpathOut_BB = fullfile(selpath,'BeforeBinary');
selpathOut_Crop = fullfile(selpath,'CroppedResult');
selpathOut_Binary = fullfile(selpath,'BinarizedResult');
% input dir
C1_dir = fullfile(selpath,'C1');
C2_dir = fullfile(selpath,'C2');
mask_dir = fullfile(selpath,'Mask');
% create output folder, if such folder does not exist
if ~exist(selpathOut, 'dir')
   mkdir(selpathOut)
end
if ~exist(selpathOut_figures, 'dir')
   mkdir(selpathOut_figures)
end
if ~exist(selpathOut_BB, 'dir')
   mkdir(selpathOut_BB)
end
if ~exist("selpathOut_Crop", 'dir')
   mkdir(selpathOut_Crop)
end
if ~exist("selpathOut_Binary", 'dir')
   mkdir(selpathOut_Binary)
end
% find the file
C1_segListing = dir(C1_dir);   
C1_segListing(1:2) = []; % remove directory entries
C2_segListing = dir(C2_dir);   
C2_segListing(1:2) = []; % remove directory entries
mask_segListing = dir(mask_dir);   
mask_segListing(1:2) = []; % remove directory entries
% load mask
Ch_2_mask = cell(n_scans,1); % apply the previous mask to the channel 2
%[Xn,Yn] = meshgrid(1:512);
%dz = 511/1023;
[Xq,Yq] = meshgrid(1:dz:512);
for i = 1:n_scans
    % load mask 
    file_name = mask_segListing(i).name;
    filePath = fullfile(mask_dir,file_name);
    Data = bfOpen3DVolume(filePath);
    RawMask=255-double(Data{1,1}{1,1});
    [x y]=size(RawMask);
    
    temp_mask = RawMask;
    
    Ch_2_mask{i} = temp_mask;
    temp_mask = return_mask(temp_mask,poisition_probe{i},fov_all(i),number_of_probes); %return mask func
    final_mask{i} = temp_mask;
end
% output
for i = 1:n_scans
    outputFileName = [num2str(i) '.png'];%[selpathOut '\' num2str(i) '.png'];
    temp = final_mask{i};
    temp(temp<0)=0;
    temp = uint8(temp/max(temp(:))*255);
    figure_mask = ind2rgb(gray2ind(temp,255),jet(255)); 
    curfig = figure();
    imshow(figure_mask)
    saveas(gcf,outputFileName)
%     imwrite(temp(:, :), outputFileName);
end