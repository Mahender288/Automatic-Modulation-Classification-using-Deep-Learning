%% Data Preparation
XTrain = [askFrames dsbamFrames];   % [1024 x 2000], complex
XTrain = reshape(XTrain, [1024 1 1 2*numFrames]); % [1024 x 1 x 1 x 2000]
YTrain = categorical([askLabels; dsbamLabels]);   % [2000 x 1], categorical

% === Prepare CNN Input ===
XTrainCNN = permute(XTrain, [1 3 4 2]); % [1024 x 1 x 1 x N]
YTrain = categorical(YTrain);           % Convert labels to categorical

% Number of modulation classes
modulationTypes = unique(YTrain);
numClasses = numel(modulationTypes);

%% CNN Architecture
spf = 1024; % Samples per frame

layers = [
    imageInputLayer([1024 1 1], ...
        'Normalization','none', ...
        'Name','input', ...
        'SplitComplexInputs',true)

    convolution2dLayer([5 1], 32, 'Padding','same','Name','conv1')
    batchNormalizationLayer('Name','bn1')
    reluLayer('Name','relu1')
    averagePooling2dLayer([2 1], 'Stride',2,'Name','avgpool1')

    convolution2dLayer([3 1], 64, 'Padding','same','Name','conv2')
    batchNormalizationLayer('Name','bn2')
    reluLayer('Name','relu2')
    averagePooling2dLayer([2 1], 'Stride',2,'Name','avgpool2')

    convolution2dLayer([3 1], 128, 'Padding','same','Name','conv3')
    batchNormalizationLayer('Name','bn3')
    reluLayer('Name','relu3')
    averagePooling2dLayer([2 1], 'Stride',2,'Name','avgpool3')

    dropoutLayer(0.4,'Name','dropout1')
    fullyConnectedLayer(128,'Name','fc1')
    reluLayer('Name','relu4')
    dropoutLayer(0.3,'Name','dropout2')

    fullyConnectedLayer(numClasses,'Name','fc_out')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','output')
];

%% Training Options
doTraining = false; % Set true if retraining is required

if doTraining
    maxEpochs = 15;
    miniBatchSize = 1024;
    trainingPlots = "training-progress";
    validationFrequency = max(1, floor(numel(rxTrainLabels)/miniBatchSize));

    options = trainingOptions('sgdm', ...
        'InitialLearnRate', 3e-1, ...
        'MaxEpochs', maxEpochs, ...
        'MiniBatchSize', miniBatchSize, ...
        'Shuffle','every-epoch', ...
        'Plots',trainingPlots, ...
        'ValidationData',{rxValidFrames, rxValidLabels}, ...
        'ValidationFrequency',validationFrequency, ...
        'ValidationPatience',5, ...
        'LearnRateSchedule','piecewise', ...
        'LearnRateDropPeriod',6, ...
        'LearnRateDropFactor',0.75, ...
        'OutputNetwork','best-validation-loss');
else
    options = trainingOptions('adam', ...
        'MaxEpochs',15, ...
        'MiniBatchSize',128, ...
        'Verbose',false, ...
        'Plots','training-progress');
end

%% Train the Network
trainedNet = trainNetwork(XTrain, YTrain, layers, options);

%% Save & Load Trained Network
modulationTypes = categorical(sort(["ASK","DSB-AM"]));
save('trainedModulationClassificationNetwork.mat', 'trainedNet','modulationTypes');
load trainedModulationClassificationNetwork
