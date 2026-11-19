source_name ="\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Codes\Image_Segmentation-master\result\U_Net\test_images\";

source_folder = dir(strcat(source_name,"SR*.png"));

for i=1:100%(length(source_folder)/2)
    I = imread(fullfile(source_folder(i).folder,strcat("im_",string(i-1),".png")));
    label = imread(fullfile(source_folder(i).folder,strcat("SR_",string(i-1),".png")));
    label_im = labeloverlay(I,im2bw(label)); 
    fuse_lim = imfuse(I,label_im,'montage');
    figure, imshow(fuse_lim);
    imwrite(fuse_lim,strcat(source_name,'combined_',source_folder(i).name));
    close all
end