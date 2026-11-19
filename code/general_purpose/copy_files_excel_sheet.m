clear
clc
source = dir("\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\WBT_Composite_Fusion\Dataset\Videos\**\*.png");
destfolder = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Composite image generation program\Composite_Images_from_CLAM\";
% destfolder = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\Debashis\Normal_Abnormal\";

baseFileName = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Composite image generation program\attention_scores.xlsx';        % using a fully-qualified filename here would be good practice
tblAllSheetData = [];
% opt=detectImportOptions(baseFileName);
% wanted/need options code/fixup here...
sheetNames = sheetnames(baseFileName)
for k = 8 : numel(sheetNames)
	thisTable = readtable(baseFileName,'Sheet',sheetNames{k});
% 	fprintf('Read a table of %d rows and %d columns from a sheet names %s.\n',...
% 		height(thisTable), width(thisTable), sheetNames{k});
	% Stitch onto the end
	tblAllSheetData = vertcat(tblAllSheetData, thisTable);
    %first find the video name and the indexes on the source
    idx = find(contains(string({source.name}),extractAfter(sheetNames{k},'_A')));
    %find how many numer of important frames should be used 
    noif = height(thisTable)*0.2; 
%     take the first 20% noif from the list and save them
    for i=1:noif
        frm_nm = thisTable.Frame_No(i);
        input_file_name = fullfile(source(idx(1)).folder,strcat(source(idx(i)).name));%,"_",string(i+1),'.png'
        output_file_name = fullfile(destfolder,sheetNames{k},strcat(sheetNames{k},"_",string(i+1),'.png'));
        output_folder = fullfile(destfolder,sheetNames{k});
        if (exist(output_folder)==0 ||exist(output_folder)==2)
                mkdir(output_folder);
        end
       copyfile(input_file_name, output_file_name);
    end

end