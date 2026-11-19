
clear all
% source = dir("\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\binol\Projects\Eardrum\datasets\alpha_composites_2_thr_multi_rfn_v4_aug\**\*.png");
lookup_type = dir('/isilon/datalake/cialab/scratch/cialab/binol/Projects/Eardrum/datasets/alpha_composites_2_thr_multi_rfn_v4_aug/**/*.png');
% source_dir = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\All_video_frames\';
% destfolder_im = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Dataset_for transfer learning\Composite_linear_aug\";
source = dir('/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All Selected Still Frames/All Selected Still Frames/*.bmp');
destfolder_im1 = "/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Dataset_for_transfer_learning/Still/";
destfolder_im2 = "/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Dataset_for_transfer_learning/Still_two/";
% select_folder = dir("/isilon/datalake/cialab/scratch/cialab/binol/Projects/Eardrum/datasets/alpha_composites_2_thr_multi_rfn_v4_aug/**/*.png");

foldername_im = string({lookup_type.folder});
filenames =string({lookup_type.name});
select_files = filenames(~contains(filenames,'.png_'));
case_name = extractBefore(extractBetween(select_files,'_8_','.png'),'_');
select_folder = foldername_im(~contains(filenames,'.png_'));
select_folder_type = extractAfter(select_folder,'v4_aug/');
name_type=[case_name',select_folder_type'];
% match = {'_stitch.png_s1_','_stitch.png_s0.9','_stitch.png_s1.05','_stitch.png_s1.1'};%'Normal','Abnormal'};%'Effusion','Perforation','Tympanosclerosis'};

% caseNames = unique(select_folder_type);%unique(extractBefore(extractBetween(filenames,'_8_','.png'),'_'));
foldername_im = string({source.folder});
filenames =string({source.name});
fold_list = contains(filenames,case_name);

fold_list_names = strcat(foldername_im(fold_list),'/',filenames(fold_list));
% for i = 2:length(caseNames)%match)%jst_eff_list)
%     fold_list = contains(select_folder,caseNames(i));
%     fold_list_allnames=strcat(select_folder(fold_list),'/',select_files(fold_list));
%     fold_list_names=select_files(fold_list);
    for j=426:length(fold_list_names)
        case_name_i=extractBetween(fold_list_names(j),'s/All Selected Still Frames/','.Still');
        im_name = strrep(extractAfter(fold_list_names(j),'s/All Selected Still Frames/'),'.bmp','.png');
        idx = find(contains(case_name,case_name_i));
        inputFullFileName = fold_list_names(j);
        I = imread(inputFullFileName);
        outputFullFileName = strcat(destfolder_im1,name_type(idx(1),2),'/',im_name);
        imwrite(I,outputFullFileName);
        % copyfile(inputFullFileName, outputFullFileName);
        if ~contains(name_type(idx(1),2),'Normal')
            outputFullFileName = strcat(destfolder_im2,'Abnormal/',im_name);
            imwrite(I,outputFullFileName);
            % copyfile(inputFullFileName, outputFullFileName);
        else
            outputFullFileName = strcat(destfolder_im2,name_type(idx(1),2),'/',im_name);
            imwrite(I,outputFullFileName);
            % copyfile(inputFullFileName, outputFullFileName);
        end

    end
% end

% for i=3:6%length(filenames)
%     folder_list = dir(fullfile(foldername_im,filenames(i)));
%     parfor j=3:length(folder_list)
% %         folder_list(j)
%         inputFullFileName = fullfile(folder_list(j).folder,folder_list(j).name);
%         outputFullFileName = fullfile(destfolder_im,strcat(strrep(extractAfter(folder_list(j).folder,source_dir),'\','_'),'_',folder_list(j).name));
%         copyfile(inputFullFileName, outputFullFileName);
%     end'
% end