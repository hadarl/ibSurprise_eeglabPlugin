function EEG = generate_sequenceData(EEG,eventType)
% eventType = [oddball, standard]

EEG.ibsurprise.sequenceData = [];

eventSequenceOrig = [EEG.epoch.eventtype];
oddStanSequence = eventSequenceOrig;
oddStanSequence(oddStanSequence==eventType(1)) = 0;
oddStanSequence(oddStanSequence==eventType(2)) = 1;


sequenceData.seq = eventSequenceOrig;
sequenceData.seq1 = oddStanSequence;
sequenceData.nBlocks = 1;
sequenceData.q1 = [sum(oddStanSequence==0)/length(oddStanSequence)]';
% sequenceData.probPerTrial = kron(sequenceData.q1',ones(1,nTrialsPerBlock));
sequenceData.nTrialsPerBlock = length(oddStanSequence);

EEG.ibsurprise.sequenceData = sequenceData;
