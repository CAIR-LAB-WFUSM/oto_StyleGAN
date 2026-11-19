% clear
% clc
% source = dir("\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Codes\DatasetGAN\**\*");
destfolder = "E:\secamala\Codes\";
sourcefolder = "\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Codes\";
names = string({source.name});
match = {'.txt','.m','.py','.MD','.pdf','.pptx','.ipynb','.ptx','.xlsx','.docx'};
select = (contains(names,match));

for i=82450:length(source)
    if select(i)
        inputfile = fullfile(source(i).folder,source(i).name);
        outputfiile = fullfile(strrep(source(i).folder,sourcefolder,destfolder));
        copyfile(inputfile,outputfiile);
    end

end