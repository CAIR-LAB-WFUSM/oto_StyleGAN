% find the duration of the videos
% clear all
folder="D:\EH Biliary Tree\*.mp4";  %"\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Reader study\Some_Videos_for_key_frame_selection\*.MOV"
vid_source = dir(folder);

for i=137: length(vid_source)
    vid = VideoReader(fullfile(vid_source(i).folder,vid_source(i).name));
    file_duration(i)=vid.Duration/60; 
    file_gb_stor(i) = (vid_source(i).bytes)/(1024^3);
end
