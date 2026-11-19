source = dir("\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\New_Videos_frames\**\*.png");
% destfolder = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\WBT_Composite_Fusion\Dataset\Videos\";
destfolder = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\Debashis\Normal_Abnormal\";
name_list = NormalAbnormalv2.Name;
filenames =string({source.name});
foldernames =string({source.folder});
nfiles = length(filenames);
list_added=[0];
% tdy = today('datetime');
% frm_dt = {source.date};

for i=1:nfiles  %
%     if hours(tdy-frm_dt(i))<1000
        thisfile = filenames{i};
        for j=1:58
            abc(j)=contains(thisfile,name_list(j));
            the_case = find((abc));
            if any(the_case) & ~(any(list_added,the_case))
                list_added = [list_added;the_case];
            end
    
        end
        if (any(abc))
            inputFullFileName = fullfile(foldernames{i},thisfile);
            if contains(thisfile,'-')
                thisfile=strrep(thisfile,'-','Normal');
            end
    %         inputFullFileName = string(fullfile({source(i).folder},thisfile));
    %         vid_name = erase(string(source(i).folder),'\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\New_Videos_frames\');
    %         vid_name = extractBetween(vid_name,'\','.avi');
    %         outputBaseFileName = strcat(vid_name,sprintf('%s', thisfile));
            outputFullFileName = fullfile(destfolder, strrep(thisfile,'_','/'));
            outputFullFolderName = fullfile(destfolder, strcat(extractBefore(thisfile,'_'),'/',extractBetween(thisfile,'_','_'),'/'));
            if size(outputFullFolderName,1) ==2
                outputFullFolderName = outputFullFolderName(2,:);
                outputFullFileName = fullfile(outputFullFolderName,extractAfter(thisfile,'R_'),extractAfter(thisfile,'L_'));
            end
            if (exist(outputFullFolderName)==0 ||exist(outputFullFolderName)==2)
                mkdir(outputFullFolderName);
            end
            copyfile(inputFullFileName, outputFullFileName);
        end
%     end
end