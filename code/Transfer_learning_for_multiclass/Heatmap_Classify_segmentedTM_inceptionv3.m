% addpath('/isilon/datalake/cialab/scratch/cialab/scamalan/Oral Cancer/Transfer learning/Inception');
% addpath('/isilon/datalake/cialab/scratch/cialab/scamalan/Try/scriptsforcam');

% destination = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Codes/Transfer_learning_for_multiclass/Results/Segmented_TM/';
destination = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Codes\Transfer_learning_for_multiclass\Results\Segmented_TM\';

% location = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/All_videos_segmented_frames_and_masks/segmented/';
location = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\All_videos_segmented_frames_and_masks\segmented\'
imds = imageDatastore(location,'LabelSource','foldernames','IncludeSubfolders',true);

caseName     = extractBetween(imds.Files,"msk_","_");
mergeLabels = double(categorical(caseName));

nFold   = length(unique(mergeLabels));
% idx = crossvalind('Kfold',mergeLabels,nFold);
idx=mergeLabels;

all_scores = [];
all_YPred = [];
all_YTest = [];
all_YTname = [];
AllmaxScores = [];
All_labels = [];
k=nFold;
la=0;
netName = 'InceptionResnetv2';
% idx = crossvalind('Kfold', k, k);
for i = 1 :k

    test_idx = (idx == i);
    train_idx = ~test_idx;
    
    train_cells1 = imds.Files(train_idx);
    test_cells1  = imds.Files(test_idx);
    
    class_weight = length(test_cells1) / length(mergeLabels);
    fprintf('Fold - : %d; class weight: %2.4f \n', i, class_weight);
    
    imdsTest = imageDatastore(test_cells1 , 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    net = load(strcat('/isilon/datalake/cialab/scratch/cialab/scamalan/Oral Cancer/Transfer learning/Normal_Abnomal_codes_results/OnePatient_res_with_overlap/net',string(i),'.mat'));
    inputSize = net.net.Layers(1).InputSize
    augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
    [YPred scores]= classify(net.net,augimdsTest);
    YTest = imdsTest.Labels;
    match={'/isilon/datalake/cialab/scratch/cialab/scamalan/Oral Cancer/Brazil Cohort/Annotation/Normal_Abnormal/All_patches_nol/Abnormal/',...
        '/isilon/datalake/cialab/scratch/cialab/scamalan/Oral Cancer/Brazil Cohort/Annotation/Normal_Abnormal/All_patches_nol/Normal/','.png'}
    YTname = erase(imdsTest.Files,match);
    for im_num=1:length(imdsTest.Files)
        img     = imread(char(imdsTest.Files(im_num)));
        gt_label = imdsTest.Labels(im_num);
        im_name = YTname(im_num);
        img     = imresize(img,inputSize(1:2));
        imgSize = size(img);
        imgSize = imgSize(1:2);


    % CAM
        layer   = 819;
        name    = net.net.Layers(layer).Name;
        classes = net.net.Layers(end).Classes;

        activationsM = activations(net.net,img,name);
        act1         = mat2gray(activationsM(:,:,1));

        scores = squeeze(mean(activationsM,[1 2]));

        if netName ~= "squeezenet"
            fcWeights = net.net.Layers(end-2).Weights;
            fcBias    = net.net.Layers(end-2).Bias;
            scores    =  fcWeights*scores + fcBias;

            [~,classIds] = maxk(scores,3);

            weightVector       = shiftdim(fcWeights(classIds(1),:),-1);
            classActivationMap = sum(activationsM.*weightVector,3);
        else
            [~,classIds] = maxk(scores,3);
            classActivationMap = activationsM(:,:,classIds(1));
        end

        % Calculate the top class labels and the final normalized class scores.
        scores    = exp(scores)/sum(exp(scores));     
        maxScores = scores(classIds);
        labels    = classes(classIds);
        AllmaxScores = [AllmaxScores, maxScores];
        All_labels = [All_labels, labels];
        
    %     fig=figure
    %     subplot(1,2,1)
    %     imshow(img)
    %     title('True Label:'+string(gt_label));
    %     
    %     subplot(1,2,2)
            true_label=string(gt_label);
            patchName = im_name;
            outImg = CAMshow(img,classActivationMap);
            imwrite(outImg,strcat(destination,'Images/',string(im_name),'.png'));
    %         draw_patchandheatmap_figure(patchName,true_label,labels,maxScores,destination)
    %         draw_Whole_imheatmap_figure(imageName,true_label,pred_labels,maxScores,destination)

    %     title(string(labels) + ", " + string(maxScores));


    %     saveas(fig,strcat(destination,'Figures/',string(im_name),'.fig'));
    %     saveas(fig,strcat(destination,'Figures/',string(im_name),'.png'));
        close all
    end
    
    
    test_accuracy(i) = sum(YPred == YTest)/numel(YTest) %image accuracy
    
    % lesion area accuracy
    p_list = find(contains(YTname,"__"));
    if(numel(p_list)<length(YTname))
        for x=1:length(YTname)
            if ~(any(p_list==x))
                plc =find(char(YTname(x)) == '_', 1, 'last');
                YTname(x)=cellstr(insertAfter(char(YTname(x)),plc,'_'));
            end
        end
    end
    les_name = extractBetween(YTname,"C","__");
    lun = unique(les_name);
    for l=1:length(lun)
        la=la+1;
        les_names(la)=strcat('C',string(lun(l)));
        imageName = les_names(la);
        les_list=find(contains(YTname,imageName));
        pred_labels=YPred(les_list);
        true_label = YTest(les_list);
        s_maxScores = AllmaxScores(:,les_list);
        s_labels = All_labels(:,les_list);
        draw_Whole_imheatmap_figure(imageName,true_label,pred_labels,s_maxScores,s_labels,destination)
        
        correct_l(la) = sum(YPred(les_list) == YTest(les_list));
        incorrect_l(la)= numel(YTest(les_list))-correct_l(la);
        if(correct_l(la)>=incorrect_l(la))
            les_accuracy(la)=1;
        else
            les_accuracy(la)=0;
        end
    end
    lession_acc(i)=sum(les_accuracy(end-length(lun)+1:end))/length(lun);

     C_test(:,:,i)=confusionmat(YPred,YTest);
%      save(strcat(destination,'test_acc_conf_3','.mat'),'test_accuracy','C_test','YTest','YPred','YTname');
     all_scores = [all_scores; scores];
     all_YPred=[all_YPred; YPred];
     all_YTest=[all_YTest;YTest];
     all_YTname = [all_YTname;YTname];
end