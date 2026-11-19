%resize the images
% folder_dir = dir('\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\All_videos_segmented_frames_and_masks\effusion_GAN\*.png');
folder_dir = dir('/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/Perforation_Gan/*.png');
destfolder_im = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/Perforation_Gan/';

for i=1:length(folder_dir)
    im = imread(fullfile(folder_dir(i).folder,folder_dir(i).name));
    [row,col,chn]=size(im);
    if (row~=512 & col~=512)
    %     im_new=im(25:end-16,260:2139,:);
    %     im_new = imresize(im_new,[1024,1024]);
    %     imwrite(im_new,fullfile(destfolder_im,folder_dir(i).name));
    %     if(i>=10017 & i<=11216)
%             im_new=im(230:850,440:1080,:);
%             im_new = imresize(im,[512,512]);
%             imwrite(im_new,fullfile(folder_dir(i).folder,folder_dir(i).name));
%         else
            im_new = imresize(im,[512,512]);
            imwrite(im_new,fullfile(destfolder_im,folder_dir(i).name));
        end
%     elseif (row<512 & col<512)
%         im_new = imresize(im,[512,512]);
%         imwrite(im_new,fullfile(folder_dir(i).folder,folder_dir(i).name));
    % end
    
end