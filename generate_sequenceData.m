function EEG = generate_sequenceData(EEG)

sequenceData.seq = Trig(Trig>0);
sequenceData.seq1 = single(sequenceData.seq==3);
sequenceData.nBlocks = nBlocks;
sequenceData.q1 = [0.25 0.25 0.25 0.25]';
sequenceData.blockStart = zeros(1,length(sequenceData.seq));
sequenceData.blockStart(1:nTrialsPerBlock:length(sequenceData.seq)) = 1;
sequenceData.probPerTrial = kron(sequenceData.q1',ones(1,nTrialsPerBlock));
sequenceData.nTrialsPerBlock = nTrialsPerBlock;
