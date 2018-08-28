function [surpriseSequence, pXY, pXhat_X, pY_Xhat ] = calc_surprise_signal_uniTheta(sequence,n,beta,pXY,p0Xhat_X)
% Analyzing surprise  for oddball sequences where "past" is the number of
% occurences of "1" in the last n elements.
% The elements in the sequence should be 0 or 1
% This function gets a stimulus sequence and returns the  surprise signal
% n - the number of elements in the memory (length of past sequence)

global baseAnalysisFilesDir;
global betaVec;

if ~exist('p0Xhat_X','var')
    p0Xhat_X = eye(n+1);
end

nPastSequence = conv(ones(1,n),sequence);
nPastSequence = nPastSequence(n:end-n);

futureSequence = sequence((n+1):end);
surpriseSequence = zeros(size(futureSequence));

betaInd = find(betaVec==beta);
file = sprintf('%s\\IB_probs\\pXhat_X_%d_%d.mat',baseAnalysisFilesDir,n,betaInd);
if exist(file,'file')
%     disp(['IB probabilities were loaded from ' file]);
    pXhat_X = importdata(file);    
    file = sprintf('%s\\IB_probs\\pY_Xhat_%d_%d.mat',baseAnalysisFilesDir,n,betaInd);
    pY_Xhat = importdata(file);
else
    [pXhat_X, pY_Xhat] = IB(pXY,beta,p0Xhat_X);
end

sXY = -log2(pY_Xhat) * pXhat_X;
sXY = sXY';

if any(isnan(pXhat_X))
    error( 'pXhat_X contains nans')
end

if any(pY_Xhat==0)
    error('pY_Xhat contains zeros')
end

for i = 1: length(futureSequence)


    ithPast = nPastSequence(i);
    xInd = ithPast+1;
    currFutureElement = futureSequence(i);
    currFutureInd = currFutureElement+1;

%     surpriseSequence(i) = -log2(pY_Xhat(currFutureInd,:))*pXhat_X(:,xInd);
    surpriseSequence(i) = sXY( xInd, currFutureInd);

end

if isnan(sum(surpriseSequence))
    error( '  isnan(sum(surpriseSequence)) in \bmi_lab\P300_oddball\analysis\code\calc_surprise_signal_uniTheta.m')
end