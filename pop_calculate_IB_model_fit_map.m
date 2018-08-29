function EEG = pop_calculate_IB_model_fit_map(EEG) %

% if nargin < 2
%     % pop up window if less than 2 arguments
%     result       = inputdlg({ 'Enter max past length:' , 'Enter beta values:', 'Enter predictors file:'}, 'Title of window', 1, { '0', '0', ' '});
%     if isempty( result )
%         return;
%     end
%     maxPastLength = str2double(result{1});
%     betaVec = eval(result{2}); % logspace(0,2,20);
%     ibPredictorsFile = result{3};
% end

args1 = {EEG, EEG.ibsurprise.ibModel.predictors, rand(1,length(EEG.ibsurprise.sequenceData.seq1Full))*100, EEG.ibsurprise.sequenceData};
[modelAccuracy, blockModelAccuracy] = calc_model_accuracy_map(args1{:});

EEG.ibsurprise.ibModel.modelFit = modelAccuracy;

figure('Name', 'IB model fit','position',[ 680   556   779   542]);
plot_models_map( modelAccuracy, EEG.ibsurprise.ibModel.params.betaVec, {'Model fit'});

