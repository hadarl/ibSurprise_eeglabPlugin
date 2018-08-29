function [lm, s, responses,valid, fullS, w] = get_surprise_lm(surpriseModels, AUCperTrial, sequenceData, pastLength, betaInd, useTrial, useWeights)
% NOTICE: BY WHAT INDICES IS useTrial defined??

% declare_global_params;

if ~exist('useWeights')
    useWeights = 0;
end

s = squeeze(surpriseModels(pastLength,betaInd,:));
s = s';

if ~exist( 'useTrial', 'var')
    useTrial = true( size( surpriseModels,3), 1)';
end

% % Removing trials from the beginning of each block due to model memory length
% % % Use blockStartInds in case bad trials were already omitted
% % blockStartInds = sequenceData.blockStart;
% try
%     assert( length( sequenceData.blockStart)==length(s))
% catch
%     error('Probably need to fix size of surprise models');
% end

valid = set_valid_trials_per_block_pre(sequenceData,pastLength);
% valid = set_valid_trials_per_block(length(s),length(sequenceData.q1),pastLength,blockStartInds);
if ~isempty(find(valid & s==0))
    find(valid & s==0)
    error('Problem: there are valid, zero surprise trials')
end
validAndUse = valid & useTrial;
fullS = s;
% Extracting surprise of relevant trials:
s = s(validAndUse);
assert( all( s>0),sprintf('Not all valid surprise values are greater than zero!'))

% Calculating weights for this surprise signal for the weighted linear
% regression:
[w, s]= calc_inverse_probability_weights(s, 0, pastLength, betaInd);
fullS(validAndUse) = s;

% Doing weighted linear regression:
responses = AUCperTrial(validAndUse);

tb = table(s', responses','VariableNames',{'s','response'});
if useWeights
    lm = fitlm(tb,'response~s','weights',w);
else
    lm = fitlm(tb,'response~s');
end



