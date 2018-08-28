function valid = set_valid_trials_per_block_new(nBlocks,nTrialsPerBlock,memoryLen,omittedTrials)
% First calculating valid on full sequence. Then removing omitted trials

valid = ones(1,nBlocks*nTrialsPerBlock);

for j = 1:nBlocks
    valid( ( (j-1)*nTrialsPerBlock+1):((j-1)*nTrialsPerBlock + memoryLen)) = 0;
end

if exist('omittedTrials','var')
    valid(omittedTrials)= [];
end       

valid = logical(valid);
