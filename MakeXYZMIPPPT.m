%Make powerpoint slides given figures in the folder



animal_file='Z:\xl_stroke\yifu_2P\2021-09-05-aged-male\Processed\ProcessedStack';
folder=split(animal_file,'\');
animal_id=folder{3};


import mlreportgen.ppt.*
slides=Presentation(strcat(animal_id,'XYZ MIP'));

add(slides,'Title and Content');
add(slides,'Title and Content');

projpic=Picture('.jpg');
projpic.Width='';
projpic.Height='';
projpic.X= ;
projpic.Y= ;

replace(slides,'Content',projpic);







p=Picture