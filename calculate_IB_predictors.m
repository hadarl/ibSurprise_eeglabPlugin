function EEG = calculate_IB_predictors( EEG, maxPastLength, betaVec)

[pathstr,name,ext] = fileparts(mfilename('fullpath'));
addpath([pathstr '\IB_code\']);

% Calculating the probability for the next element given the last elements:
pXYallN = cell(maxPastLength,1);
% Info = zeros(maxPastLength,length(betaVec),2); % IX_Xhat, IXhat_Y
for pastLength = 1:maxPastLength
    N = pastLength;
    k = 0:N;
    pXY_1 = (k+1)/((N+1)*(N+2));
    pXY_0 = (N-k+1)/((N+1)*(N+2));
    pXY = [pXY_0' pXY_1'];
    pXYallN{pastLength} = pXY;
%     Info(N,:,:) = calc_info_curve(pXY,betaVec);
end
sequenceData = EEG.ibsurprise.sequenceData;
sequence1 = sequenceData.seq1Full;
nTrials = length(sequence1);
nBlocks = length(sequenceData.q1);
nTrialsPerBlock = nTrials/nBlocks; % Should be an integer. Note that nTrials is the full sequence.

% calculating surpriseModels for the FULL sequence
ibPredictors = zeros(maxPastLength,length(betaVec),nTrials);
for pastLength = 1:maxPastLength
    pXY = pXYallN{pastLength};
    for betaInd = 1:length(betaVec)
       s = [zeros(1,pastLength) calc_surprise_signal_uniTheta(sequence1, pastLength, betaVec(betaInd),pXY)];
       valid = set_valid_trials_per_block(nBlocks,nTrialsPerBlock,pastLength);
        if ~( all(  s(valid)>0))
           % find( s(valid)==0)
           disp('found zero s')
        end        
         ibPredictors(pastLength, betaInd,:)  = s;        
    end
end

EEG.ibsurprise.ibPredictors = ibPredictors;