clear all

source_dir = dir('/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Codes/DatasetGAN/datasetGAN/datasetGAN/model_dir/TM_tympo/samples/*.png');
destination = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Codes/Image_Segmentation-master/GAN_dataset/';

r = randi([0,512],1,90);
u=unique(r);

num_im=512;
for i=1:num_im
    inputFullFileName = fullfile(source_dir(i).folder,source_dir(i).name);
    [val num] = find(contains(string({source_dir.name}),strcat(source_dir(i).name)));
    inputFullFileName_label = fullfile(source_dir(num).folder,source_dir(num).name);
    if any(u==i)
        outputFullFileName = fullfile(destination,'validation',strcat('im_',source_dir(i).name));
        copyfile(inputFullFileName, outputFullFileName);
        outputFullFileName_label = fullfile(destination,'validation_GT',strcat('im_',source_dir(num).name));
        copyfile(inputFullFileName_label, outputFullFileName_label);
    else
        outputFullFileName = fullfile(destination,'train',strcat('im_',source_dir(i).name));
        copyfile(inputFullFileName, outputFullFileName);
        outputFullFileName_label = fullfile(destination,'train_GT',strcat('im_',source_dir(num).name));
        copyfile(inputFullFileName_label, outputFullFileName_label);
    end
end