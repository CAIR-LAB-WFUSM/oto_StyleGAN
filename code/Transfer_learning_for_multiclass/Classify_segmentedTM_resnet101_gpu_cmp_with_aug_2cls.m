% Check if the Parallel Computing Toolbox is installed
%if ~license('test', 'Parallel_Computing_Toolbox')
 %   error('Parallel Computing Toolbox is not installed.');
% end
clear all;
rng(1)

% Check if a compatible GPU is available
gpuDeviceCount = gpuDeviceCount();
if gpuDeviceCount == 0
    error('No compatible GPU available.');
end

destination = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Codes/Transfer_learning_for_multiclass/Results/com_2cls/with_aug_resnet101/';
%destination = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Codes/Transfer_learning_for_multiclass/Results/com_4cls/resnet101/';
%  destination = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\scamalan\Autoscope_2\Codes\Transfer_learning_for_multiclass\Results\com_4cls\';

location = '/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Dataset_for_transfer_learning/Composite_create_aug/Testing/';
% location = '/isilon/datalake/cialab/scratch/cialab/binol/Projects/Eardrum/datasets/alpha_composites_2_thr_multi_rfn_v4_aug/';
%  location = '\\medctr.ad.wfubmc.edu\dfs\cialab$\scratch\cialab\binol\Projects\Eardrum\datasets\alpha_composites_2_thr_multi_rfn_v4_aug\';
imds = imageDatastore(location,'LabelSource','foldernames','IncludeSubfolders',true);

caseName = extractBefore(extractBetween(imds.Files,'_8_','.png'),'_');

mergeLabels = double(categorical(caseName));
un_merge=unique(mergeLabels);

nFold   = 8;
idx1 = crossvalind('Kfold',un_merge,nFold);
for a=1:8
    [val num]=find(idx1==a);
    for b=1:length(val)
        idx(mergeLabels==val(b),1)=a;
    end
end
all_scores = [];
all_YPred = [];
all_YTest = [];
all_YTname = [];
All_caseNames = [];
All_caseNamesClass = [];
k=8;
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
    
    net = resnet101;  
    % Assuming 'net' is your pre-trained network
    % net = vl_simplenn_move(net, 'gpu');
    lgraph = layerGraph(net);
    % figure('Units','normalized','Position',[0.1 0.1 0.8 0.8]);
    % plot(lgraph)
    inputSize = net.Layers(1).InputSize
    lgraph = removeLayers(lgraph, {'fc1000','prob','ClassificationLayer_predictions'});

    numClasses = numel(categories(imdsTrain.Labels));
    newLayers = [
        dropoutLayer(0.5,'Name','dp')
        fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10),
        softmaxLayer('Name','softmax')
        classificationLayer('Name','classoutput')];
    lgraph = addLayers(lgraph,newLayers);

    lgraph = connectLayers(lgraph,'pool5','dp');
    layers = lgraph.Layers;
    connections = lgraph.Connections;

    layers(1:291) = freezeWeights(layers(1:291));
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
    'MiniBatchSize',32, ...
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
match={'/isilon/datalake/cialab/scratch/cialab/scamalan/Autoscope_2/Dataset_for_transfer_learning/Composite_create_aug/Testing/';...
        'Normal/';'Abnormal'};
% 'Effusion/';'Perforation/';'Normal/';'Tympanosclerosis/'};
    YTname = erase(imdsTest.Files,match);

    caseName_test = extractBefore(extractBetween(imdsTest.Files,'_8_','.png'),'_');
    un_merge_test=unique(caseName_test);

    for l=1:length(un_merge_test)
        la=la+1;

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
        All_caseNames = [All_caseNames; un_merge_test(l)];
        All_caseNamesClass = [All_caseNamesClass;YTest(les_list(1))];
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
     'all_YTest','all_YTname','All_caseNamesClass','All_caseNames');


end
accuracy = mean(test_accuracy);
std_dev = std(test_accuracy);

save(strcat(destination,'all_data_fold',string(i),'.mat'),'net','accuracy','std_dev','all_scores','all_YPred');

 