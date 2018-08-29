function EEG = pop_calculate_IB_predictors(EEG,param1)

% empty history
if nargin < 2
        % pop up window if less than 2 arguments
        result       = inputdlg({ 'Enter max past length:' , 'Enter beta values:', 'Enter predictors file:'}, 'Title of window', 1, { '0', '0', ' '});
        if isempty( result )
            return;
        end
        maxPastLength = str2double(result{1});
        betaVec = eval(result{2}); % logspace(0,2,20);
        ibPredictorsFile = result{3};
end

ibPredictorsFile= ibPredictorsFile(~isspace(ibPredictorsFile));
if ~isempty(ibPredictorsFile)
    ibPredictors = load(ibPredictorsFile);
    EEG.ibsurprise.ibPredictors = ibPredictors;
else
    EEG = calculate_IB_predictors( EEG, maxPastLength, betaVec);
    % run sample function
    com = sprintf('pop_calculate_IB_predictors(EEG, %d, %s );', maxPastLength, result{2} );
    % return history
end