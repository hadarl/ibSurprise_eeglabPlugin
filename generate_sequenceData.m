function EEG = generate_sequenceData(EEG,eventType)
% eventType = [oddball, standard]

EEG.ibsurprise.sequenceData = [];

eventSequence = [EEG.event.type];

oddballEvents = (eventSequence == eventType(1));
standardEvents = (eventSequence == eventType(2));

origSequence = eventSequence;
eventSequence = -1*ones(1, length(eventSequence));
eventSequence(oddballEvents) = 0;
eventSequence(standardEvents) = 1;

seq = eventSequence(oddballEvents | standardEvents);


% sequenceData.seq = Trig(Trig>0);
% sequenceData.seq1 = single(sequenceData.seq==3);
% sequenceData.nBlocks = nBlocks;
% sequenceData.q1 = [0.25 0.25 0.25 0.25]';
% sequenceData.blockStart = zeros(1,length(sequenceData.seq));
% sequenceData.blockStart(1:nTrialsPerBlock:length(sequenceData.seq)) = 1;
% sequenceData.probPerTrial = kron(sequenceData.q1',ones(1,nTrialsPerBlock));
% sequenceData.nTrialsPerBlock = nTrialsPerBlock;
