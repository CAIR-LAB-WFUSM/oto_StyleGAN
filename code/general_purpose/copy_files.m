source = dir("\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\All_video_frames\Effusion\**\*.png");
destfolder = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Codes\SAMA_test_forVideoFrames\load\test";

filenames =({source.name});
nfiles = length(filenames);

for i=1:20056%nfiles  % effusion start at 20056
    thisfile = filenames{i};
    inputFullFileName = string(fullfile({source(i).folder},thisfile));
    vid_name = erase(string(source(i).folder),'\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\All_video_frames\');
    vid_name = extractBetween(vid_name,'\','.MOV');
    outputBaseFileName = strcat(vid_name,sprintf('%s', thisfile));
    outputFullFileName = fullfile(destfolder, outputBaseFileName);
    copyfile(inputFullFileName, outputFullFileName);
end