clear all
clc
foldername = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\All_new_videos_catagoriezed\';
Alllist = dir(strcat(foldername,'**\*.avi'));
destination = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\New_Videos_frames\';
names =string({Alllist(:).name});
directory = string({Alllist(:).folder});
type = string(erase(directory,foldername));
video_list = [names,directory,type];

looking_list=['AM1098R';'AM1098L';'AM1102R';'AM1102L';...
'AM1105R';'AM1105L';'AM1106R';'AM1106L';'AM1107R';'AM1107L'];

videos = dir(strcat(foldername,'**\*.avi'));
tdy = today('datetime');

for i=1:length(Alllist)

    vdt = videos(i).date;
    if find(contains(string(looking_list),(erase(names(i),'.avi'))))%(hours(tdy - vdt)<4300)
%         vid = VideoReader(strcat(foldername,'\',videos(i).name));
        vid = VideoReader((fullfile(directory(i),names(i))));
        numFrames = vid.NumberOfFrames;
        n=numFrames;
         if (exist(strcat(foldername,'_frames\V-', videos(i).name))==0 ||exist(strcat(foldername,'\', videos(i).name))==2)
%             if ~(exist(strcat(destination, extractBefore(names(i),'.')))) ||~(exist(strcat(destination, extractBefore(names(i),'.')))==2)
                mkdir(strcat(destination,type(i),'\', names(i)));%extractBefore(names(i),'.')));
%             mkdir(strcat(destination, extractBefore(names(i),'.')));
        end
        for j = 1:1:n           
            frames = read(vid,j);
            imwrite(frames,strcat(destination,type(i),'\',names(i),'\',strrep(type(i),'\','_'),'_', extractBefore(names(i),'.avi'), '_', int2str(j), '.png'));            
%             imwrite(frames,strcat(destination,extractBefore(names(i),'.'),'\',extractBefore(names(i),'.'), '_', int2str(j),'.png'));            
        end 
    end
end
% foldername = 'X:\Autoscope\Database\Charlie and Stephany\All Videos';
% name='GE117L.MOV';
% vid = VideoReader(strcat(foldername,'\',name));
% 
%     numFrames = vid.NumberOfFrames;
%     n=numFrames;
%     for j = 1:1:n
%         if (exist(strcat(foldername,'\frames\V-', name))==0 ||exist(strcat(foldername,'\', name))==2)
%             mkdir(strcat(foldername,'\frames\V-', name));
%         end
%         frames = read(vid,j);
%         imwrite(frames,strcat(foldername,'\frames\V-',name, '\', int2str(j), '.jpg'));
%     end 