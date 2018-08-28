EEG = pop_loadset('filepath', 'E:\hadarl\google_drive\VEPESS\session\1\', 'filename', 'eeg_VEP_visual_oddball_session_1_task_Oddball_task_subjectLabId_01_B_01_VEP_recording_1.set');
eeglab redraw
EEG = eeg_checkset( EEG );

EEG = pop_epoch( EEG, {  }, [-0.2           1], 'newname', 'BDF file epochs', 'epochinfo', 'yes');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
eeglab redraw;

EEG = pop_selectevent( EEG, 'type',[34 35] ,'deleteevents','on','deleteepochs','on','invertepochs','off');
EEG = eeg_checkset( EEG );
