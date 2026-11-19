%apply random nonlinear augmentation on images in the folder

function apply_nonlinear(folder_source,folder_destination)

source = dir(strcat(folder_source,'/*.png'));

for i =1:length(source)
    org_im_name = fullfile(source(i).folder,source(i).name);
    originalImage = imread(org_im_name);
    augmentedImage1 = uint8(advancedNonlinearAugmentation(originalImage));
    [row, col, chn] = size(augmentedImage1);
    if (row~=512 & col~=512)
        augmentedImage1 = imresize(augmentedImage1,[512,512]);
    end
    % figure,imshowpair(originalImage, augmentedImage1, 'montage');
    imwrite(augmentedImage1,strrep(org_im_name,'.png','_aug_1.png'));
    augmentedImage2 = uint8(advancedNonlinearAugmentation(originalImage));
    % figure,imshowpair(originalImage, augmentedImage1, 'montage');
    [row, col, chn] = size(augmentedImage2);
    if (row~=512 & col~=512)
        augmentedImage2 = imresize(augmentedImage2,[512,512]);
    end
    imwrite(augmentedImage2,strrep(org_im_name,'.png','_aug_2.png'));

end
%%
% run the code
% source = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/Tympanosclerosis_Gan/';
% destination = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/Tympanosclerosis_Gan/';
% apply_nonlinear(source,destination)
