% Check if the Parallel Computing Toolbox is installed
%if ~license('test', 'Parallel_Computing_Toolbox')
 %   error('Parallel Computing Toolbox is not installed.');
% end


% Check if a compatible GPU is available
gpuDeviceCount = gpuDeviceCount();
if gpuDeviceCount == 0
    error('No compatible GPU available.');
end

destination = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Codes/Transfer_learning_for_multiclass/Results/com_4cls_batch64/';
%  destination = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Codes\Transfer_learning_for_multiclass\Results\com_4cls\';

location = '/isilon/datalake/cialab/scratch/cialab/binol/Projects/Eardrum/datasets/alpha_composites_2_thr_multi_rfn_v4_aug/';
%  location = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\binol\Projects\Eardrum\datasets\alpha_composites_2_thr_multi_rfn_v4_aug\';
imds = imageDatastore(location,'LabelSource','foldernames','IncludeSubfolders',true);

caseName     = extractBefore(extractBetween(imds.Files,'_8_','.png'),'_');

mergeLabels = double(categorical(caseName));
un_merge=unique(mergeLabels);

nFold   = 5;
idx1 = crossvalind('Kfold',un_merge,nFold);
for a=1:5
    [val num]=find(idx1==a);
    for b=1:length(val)
        idx(mergeLabels==val(b),1)=a;
    end
end
all_scores = [];
all_YPred = [];
all_YTest = [];
all_YTname = [];
k=5;
la=0;
% idx = crossvalind('Kfold', k, k);
for i = 1 :k

    test_idx = (idx == i);
    train_idx = ~test_idx;
    
    train_cells1 = imds.Files(train_idx);
    test_cells1  = imds.Files(test_idx);
    
    class_weight = length(test_cells1) / length(mergeLabels);
    fprintf('Fold - : %d; class weight: %2.4f \n', i, class_weight);
    
    imdsTest = imageDatastore(test_cells1 , 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    imdsTrain = imageDatastore(train_cells1, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    [imdsTrain,imdsValidation] = splitEachLabel(imdsTrain,0.85,0.15,'randomized');

    % Move data to GPU
    % imdsTrain = gpuArray(imdsTrain);
    % imdsValidation = gpuArray(imdsValidation);
    
    net = inceptionv3;  
    % Assuming 'net' is your pre-trained network
    % net = vl_simplenn_move(net, 'gpu');
    lgraph = layerGraph(net);
    % figure('Units','normalized','Position',[0.1 0.1 0.8 0.8]);
    % plot(lgraph)
    inputSize = net.Layers(1).InputSize
    lgraph = removeLayers(lgraph, {'predictions','predictions_softmax','ClassificationLayer_predictions'});

    numClasses = numel(categories(imdsTrain.Labels));
    newLayers = [
        fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
        softmaxLayer('Name','softmax')
        classificationLayer('Name','classoutput')];
    lgraph = addLayers(lgraph,newLayers);

    lgraph = connectLayers(lgraph,'avg_pool','fc');
    layers = lgraph.Layers;
    connections = lgraph.Connections;

    layers(1:307) = freezeWeights(layers(1:307));
    lgraph = createLgraphUsingConnections(layers,connections);
    
    pixelRange = [-30 30];
    imageAugmenter = imageDataAugmenter( ...
        'RandXReflection',true, ...
        'RandYReflection',true, ...
        'RandRotation',[0 360],...
        'RandScale',[0.7 2], ...
        'RandXShear', [0 45], ...
        'RandXShear', [0 45],...
        'RandXTranslation',pixelRange, ...
        'RandYTranslation',pixelRange);
    augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
        'DataAugmentation',imageAugmenter);
    augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

options = trainingOptions('sgdm', ...
    'MiniBatchSize',64, ...
    'MaxEpochs',100, ...
    'InitialLearnRate',3e-4, ...%     'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',200, ...
    'ValidationPatience',20, ...
    'ExecutionEnvironment', 'gpu');  % Specify GPU execution
%);%, ...%'Verbose',false, ...
    %'Plots','training-progress');
            % lgraph = layerGraph(net);
            % figure('Units','normalized','Position',[0.1 0.1 0.8 0.8]);
%             plot(lgraph)
            % netTransfer = trainNetwork(augimdsTrain,layers,options);
net = trainNetwork(augimdsTrain,lgraph,options);
 
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
YPred_val = classify(net,augimdsValidation);
YVal = imdsValidation.Labels;
val_accuracy(i) = sum(YPred_val == YVal)/numel(YVal)
C_val(:,:,i)=confusionmat(YPred_val,YVal);
save(strcat(destination,'val_acc_conf','.mat'),'val_accuracy','C_val');
 
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
YPred_train = classify(net,augimdsTrain);
YTrain = imdsTrain.Labels;
train_accuracy(i) = sum(YPred_train == YTrain)/numel(YTrain)
C_train(:,:,i)=confusionmat(YPred_train,YTrain);
save(strcat(destination,'train_acc_conf','.mat'),'train_accuracy','C_train');

save(strcat(destination,'net',string(i),'.mat'),'net');
augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
[YPred scores]= classify(net,augimdsTest);
YTest = imdsTest.Labels;
test_accuracy(i) = sum(YPred == YTest)/numel(YTest)
match={'/isilon/datalake/cialab/scratch/cialab/binol/Projects/Eardrum/datasets/alpha_composites_2_thr_multi_rfn_v4_aug/';...
     'Effusion/';'Perforation/';'Normal/';'Tympanosclerosis/'};
    YTname = erase(imdsTest.Files,match);
% lesion area accuracy
%     p_list = find(contains(YTname,"__"));
%     if(numel(p_list)<length(YTname))
%         for x=1:length(YTname)
%             if ~(any(p_list==x))
%                 plc =find(char(YTname(x)) == '_', 1, 'last');
%                 YTname(x)=cellstr(insertAfter(char(YTname(x)),plc,'_'));
%             end
%         end
%     end
%     les_name = extractBetween(YTname,"msk_","_");
%     lun = unique(les_name);

    caseName_test = extractBefore(extractBetween(imdsTest.Files,'_8_','.png'),'_');

%     mergeLabels_test = double(categorical(caseName_test));
    un_merge_test=unique(caseName_test);

    for l=1:length(un_merge_test)
        la=la+1;
%         les_names(la)=strcat('C',string(lun(l)));
        les_list=find(contains(YTname,string(un_merge_test(l))));
        correct_l(la) = sum(YPred(les_list) == YTest(les_list));
        incorrect_l(la)= numel(YTest(les_list))-correct_l(la);
        if(correct_l(la)>=incorrect_l(la))
            case_accuracy(la,1)=1;
            case_accuracy(la,2)=l;
        else
            case_accuracy(la,1)=0;
            case_accuracy(la,2)=l;
        end
    end
    case_acc(i)=sum(case_accuracy(end-length(un_merge_test)+1:end,1))/length(un_merge_test);


 C_test(:,:,i)=confusionmat(YPred,YTest);
 all_scores = [all_scores; scores];
all_YPred=[all_YPred; YPred];
all_YTest = [all_YTest; YTest];
all_YTname = [all_YTname;YTname];

 save(strcat(destination,'test_acc_conf','.mat'),'test_accuracy','C_test');
 save(strcat(destination,'all_data_fold',string(i),'.mat'),...
     'all_scores','all_YPred','case_accuracy','case_acc',...
     'all_YTest','all_YTname');



%     [Xmi,Ymi,Tmi,AUCmi,OPTROCPTmi] = perfcurve(YPred,scores(:,1),'Abnormal');
%     [Xno,Yno,Tno,AUCno,OPTROCPTno] = perfcurve(YPred,scores(:,2),'Normal');
%     
%     plt = plot(Xmi,Ymi), hold on
%     plt = plot(Xno,Yno), hold on
%     plt = plot(OPTROCPTmi(1),OPTROCPTmi(2),'ro')
%     plt = plot(OPTROCPTno(1),OPTROCPTno(2),'go')
%     xlabel('False positive rate') 
%     ylabel('True positive rate')
%     legend('Abnormal','Normal','Location','Best');
%     title(strcat('ROC for Fold -',string(i)));
%     saveas(plt,strcat(destination,'fold-',string(i),'_ROC.fig'));
%     saveas(plt,strcat(destination,'fold-',string(i),'_ROC.png'));

end
accuracy = mean(test_accuracy);
std_dev = std(test_accuracy);

save(strcat(destination,'all_data_fold',string(i),'.mat'),'net','accuracy','std_dev','all_scores','all_YPred');
%     [Xmi,Ymi,Tmi,AUCmi,OPTROCPTmi] = perfcurve(all_YPred,all_scores(:,1),'Abnormal');
%     [Xno,Yno,Tno,AUCno,OPTROCPTno] = perfcurve(all_YPred,all_scores(:,2),'Normal');
%     
%     plt = plot(Xmi,Ymi), hold on
%     plt = plot(Xno,Yno), hold on
%     
%     plt = plot(OPTROCPTmi(1),OPTROCPTmi(2),'ro')
%     plt = plot(OPTROCPTno(1),OPTROCPTno(2),'go')
%     xlabel('False positive rate') 
%     ylabel('True positive rate')
%     legend('Abnormal','Normal','Location','Best');
%     title(strcat('ROC for Fold -',string(i)));
% saveas(plt,strcat(destination,'ALL_ROC.fig'));
% saveas(plt,strcat(destination,'ALL_ROC.png'));
   