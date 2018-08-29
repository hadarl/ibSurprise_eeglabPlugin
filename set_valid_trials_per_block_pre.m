function valid = set_valid_trials_per_block_pre(sequenceData,pastLength)

nBlocks = length(sequenceData.q1);
nTrialsPerBlock = length(sequenceData.seq1Full)/nBlocks;
if isfield(sequenceData,'OmittedTrials')
    valid = set_valid_trials_per_block_new(nBlocks,nTrialsPerBlock,pastLength,sequenceData.OmittedTrials);
else
    valid = set_valid_trials_per_block_new(nBlocks,nTrialsPerBlock,pastLength);
end