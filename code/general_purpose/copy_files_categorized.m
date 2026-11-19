source = dir("\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\New_Videos\*.avi");
destfolder = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\All_new_videos_catagoriezed\";
justnameabnormality = DatacollectionformProspectivevideocollection61824;
names = justnameabnormality.ID;  % import data from excell sheet
all_dig_list = [justnameabnormality.WhyAbnormal,justnameabnormality.WhyAbnormal1];

fileID=fopen('No file.txt','w');
cd(destfolder);

for i=113:125%length(source)
   lst = find(contains(names,extractBefore(source(i).name,'.avi')));
   if all_dig_list(lst,2)~=categorical(string('-'))
        if(exist('Multiple','file')==7)
            cd("Multiple\");
            cat_vid = strcat(string(all_dig_list(lst,1)),'_',string(all_dig_list(lst,2)));
            if(exist(cat_vid))
                copyfile (fullfile(source(i).folder,source(i).name),strcat(destfolder,'Multiple\',cat_vid,'\',source(i).name));
            else
                mkdir(cat_vid);
                copyfile (fullfile(source(i).folder,source(i).name),strcat(destfolder,'Multiple\',cat_vid,'\',source(i).name));
            end
        else
            mkdir('Multiple');
            cd("Multiple\");
            cat_vid = strcat(string(all_dig_list(lst,1)),'_',string(all_dig_list(lst,2)));
            mkdir(cat_vid)
            copyfile (fullfile(source(i).folder,source(i).name),strcat(destfolder,'Multiple\',cat_vid,'\',source(i).name));
        end
        cd ..
   else
       if(exist(string(all_dig_list(lst,1)),'file')==2||exist(string(all_dig_list(lst,1)),'file')==0)
           mkdir(string(all_dig_list(lst,1)));
           cd(string(all_dig_list(lst,1)))
           copyfile (fullfile(source(i).folder,source(i).name),strcat(destfolder,string(all_dig_list(lst,1)),'\',source(i).name));
       else
           cd(string(all_dig_list(lst,1)))
           copyfile (fullfile(source(i).folder,source(i).name),strcat(destfolder,string(all_dig_list(lst,1)),'\',source(i).name));
       end
       cd ..
   end
end