function [modelAccuracy, blockModelAccuracy, lmCoefficients]= calc_model_accuracy_map(EEG,surpriseModels, eegFeatureSignal,sequenceData,useTrial,useWeights)

maxPastLength = EEG.ibsurprise.ibModel.params.maxPastLength;
betaVec       = EEG.ibsurprise.ibModel.params.betaVec;

if ~exist( 'useTrial', 'var') || isempty(useTrial)
    useTrial = true( size( surpriseModels,3), 1)';
end

if ~exist('useWeights', 'var')
    useWeights = 1;
end

modelAccuracy = zeros(maxPastLength, size(surpriseModels,2));
rangeS = -1*ones(maxPastLength,size(surpriseModels,2));
rangeResponse = -1*ones(maxPastLength,size(surpriseModels,2));
betaMat = -1*ones(maxPastLength,size(surpriseModels,2));
NMat = -1*ones(maxPastLength,size(surpriseModels,2));
lmCoefficients = cell(maxPastLength,size(surpriseModels,2));

for pastLength = 1:maxPastLength
    for betaInd = 1:size(surpriseModels,2)
        [lm, s, responses,valid, fullS] = get_surprise_lm(surpriseModels, eegFeatureSignal, sequenceData, pastLength, betaInd, useTrial,useWeights);
        if length(unique(s))==1
            modelAccuracy(pastLength,betaInd)=0;
        else
            modelAccuracy(pastLength,betaInd) = lm.Rsquared.Ordinary;
        end
        [uniqueS, meanResponse] = plot_scatter_mean(s,responses,0);
        rangeS(pastLength,betaInd) = max(uniqueS)-min(uniqueS);
        rangeResponse(pastLength,betaInd) = max(meanResponse)-min(meanResponse);
        betaMat(pastLength,betaInd) = betaVec(betaInd);
        NMat(pastLength,betaInd) = pastLength;
        lmCoefficients{pastLength,betaInd} = lm.Coefficients;

    end
end

%{
figure('position',[65         568        1315         360]);
subplot(1,3,1)
scatter(rangeS(:),rangeResponse(:));
xlabel('Surprise range')
ylabel('AUC range')
title('Single subject, all surprise models')

subplot(1,3,2)
scatter(betaMat(:),rangeResponse(:));
xlabel('beta')
ylabel('AUC range')
title('Single subject, all surprise models')

subplot(1,3,3)
scatter(NMat(:),rangeResponse(:));
xlabel('N')
ylabel('AUC range')
title('Single subject, all surprise models')
%}

%{
figure;
scatter(betaMat(:),rangeS(:));
xlabel('beta')
ylabel('surprise range')
title('Single subject, all surprise models')

figure;
scatter(NMat(:),rangeS(:));
xlabel('N')
ylabel('surprise range')
title('Single subject, all surprise models')
%}

if 0 %calcBlockModelAccuracy
    nBlocks = length(sequenceData.q1);
    blockModelAccuracy =  zeros(maxPastLength, size(surpriseModels,2), nBlocks);
    for i = 1: nBlocks
        useTrialBlock = useTrial & (sequenceData.probPerTrial==sequenceData.q1(i));
        sum(useTrialBlock)

        for pastLength = 1:maxPastLength
            for betaInd = 1:size(surpriseModels,2)
                [lm, s, responses,valid, fullS] = get_surprise_lm(surpriseModels, eegFeatureSignal, sequenceData, pastLength, betaInd, useTrialBlock,useWeights);
                blockModelAccuracy(pastLength,betaInd,i) = lm.Rsquared.Ordinary;
            end
        end
    end
else
    blockModelAccuracy = [];
end