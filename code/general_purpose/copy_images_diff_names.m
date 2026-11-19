clear all
source = dir("\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\binol\Projects\Eardrum\datasets\keyframe_multi_v4\**\*.png");
% lookup_type = dir('/isilon/datalake/cialab/scratch/cialab/binol/Projects/Projects/Eardrum/datasets/keyframe_multi_v4/**/*.png');
% source_dir = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\All_video_frames\';
destfolder_im = dir("\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Dataset_for_transfer_learning\Still\**\*.png");
% source = dir('/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All Selected Still Frames/All Selected Still Frames/*.bmp');
% destfolder_im1 = "/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Dataset_for_transfer_learning/Still/";
% destfolder_im2 = "/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Dataset_for_transfer_learning/Still_two/";
% select_folder = dir("/isilon/datalake/cialab/scratch/cialab/binol/Projects/Eardrum/datasets/alpha_composites_2_thr_multi_rfn_v4_aug/**/*.png");
dest_main="\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Dataset_for_transfer_learning\Still\";
foldername_im = string({source.folder});
filenames =string({destfolder_im.name});
uni_source=unique(extractBetween(foldername_im,'V-','.MOV'));
uni_dest = unique(extractBefore(filenames,'.Still'));

for i=306:length(uni_source)
    if any(~cellfun(@isempty,strfind(uni_dest,uni_source(i))))
        i
    else
        j=find(contains(foldername_im,uni_source(i)));
        I=imread(fullfile(source(j).folder,source(j).name));
        name=strcat(dest_main,extractBetween(source(j).folder,'i_v4\','\V'),'\',uni_source(i),'.Still001.png')
        imwrite(I,name);
    end
end


% select_files = filenames(~contains(filenames,'.png_'));
% case_name = extractBefore(extractBetween(select_files,'_8_','.png'),'_');
% select_folder = foldername_im(~contains(filenames,'.png_'));
% select_folder_type = extractAfter(select_folder,'v4_aug/');
% name_type=[case_name',select_folder_type'];