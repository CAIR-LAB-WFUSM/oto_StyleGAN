source = dir("\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\deniz\aug_images_new\*.png");
destfolder_im = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\deniz\aug_images_folds\";
destfolder_ms = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\deniz\aug_masks_folds\";

foldername_im = source.folder;
foldername_ms = replace(foldername_im,'images','masks');
filenames =string({source.name});
nfiles = length(filenames);

cv = cvpartition(n_unique_files,'Kfold',5,'Stratify',false);
numFolds = cv.NumTestSets;

for i = 1:numFolds
    testClasses = n_unique_files(cv.test(i));
    fold_list = contains(filenames,testClasses);
    fold_list_names = strcat(string({source(fold_list).folder}),'\',string({source(fold_list).name}));
    parfor j=1:length(fold_list_names)
        inputFullFileName = fold_list_names{j};
        outputFullFileName = strcat(replace(inputFullFileName,'new',strcat('folds','\fold',num2str(i),'\')));
        copyfile(inputFullFileName, outputFullFileName);
        inputFullFileName_msk = replace(fold_list_names{j},'images','masks');
        outputFullFileName_msk = replace(outputFullFileName,'images','masks');
        copyfile(inputFullFileName_msk, outputFullFileName_msk);
    end
end
% 
% for i=1:20056%nfiles  % effusion start at 20056
%     thisfile = filenames{i};
%     inputFullFileName = string(fullfile({source(i).folder},thisfile));
%     vid_name = erase(string(source(i).folder),'\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\All_video_frames\');
%     vid_name = extractBetween(vid_name,'\','.MOV');
%     outputBaseFileName = strcat(vid_name,sprintf('%s', thisfile));
%     outputFullFileName = fullfile(destfolder, outputBaseFileName);
%     copyfile(inputFullFileName, outputFullFileName);
% end