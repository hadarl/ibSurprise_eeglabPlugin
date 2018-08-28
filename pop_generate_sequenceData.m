function [EEG, com] = pop_generate_sequenceData( EEG,  param1 )
com = ''; 

% empty history
if nargin < 2 
        % pop up window if less than 2 arguments 
        result       = inputdlg({ 'Enter [oddball, standard] event numbers:' }, 'Title of window', 1, { '0' }); 
        if isempty( result )
            return; 
        end
        param1  = eval( [ '[' result{1} ']' ] ); 
% the brackets allow to process matlab arrays 
end
EEG = generate_sequenceData( EEG, param1); 
% run sample function 
com = sprintf('pop_generate_sequenceData(EEG, %d );', param1); 
% return history 
