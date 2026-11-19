clear all
source = dir('/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Codes/Image_Segmentation-master/GAN_dataset/valid_GT/*.png');

list = contains(string({source.name}),'_label');
list_name = source(list);
for i=1:length(list)
    inputname = fullfile(source(i).folder,list_name(i).name);
    outputname = fullfile(source(i).folder,erase(list_name(i).name,'_label'));
    movefile(inputname,outputname);
end
