% eegplugin_dipfit() - DIPFIT plugin version 2.0 for EEGLAB menu.
%                      DIPFIT is the dipole fitting Matlab Toolbox of
%                      Robert Oostenveld (in collaboration with A. Delorme).
%
% Usage:
%   >> eegplugin_dipfit(fig, trystrs, catchstrs);
%
% Inputs:
%   fig        - [integer] eeglab figure.
%   trystrs    - [struct] "try" strings for menu callbacks.
%   catchstrs  - [struct] "catch" strings for menu callbacks.
%
% Notes:
%   To create a new plugin, simply create a file beginning with "eegplugin_"
%   and place it in your eeglab folder. It will then be automatically
%   detected by eeglab. See also this source code internal comments.
%   For eeglab to return errors and add the function's results to
%   the eeglab history, menu callback must be nested into "try" and
%   a "catch" strings. For more information on how to create eeglab
%   plugins, see http://www.sccn.ucsd.edu/eeglab/contrib.html
%
% Author: Arnaud Delorme, CNL / Salk Institute, 22 February 2003
%
% See also: eeglab()

% Copyright (C) 2003 Arnaud Delorme, Salk Institute, arno@salk.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1.07  USA

function vers = eegplugin_ibSurprise(fig, trystrs, catchstrs)

    vers = 'ibSurprise0.1';
    if nargin < 3
        error('eegplugin_ibSurprise requires 3 arguments');
    end

    % find tools menu
    % ---------------
    menu = findobj(fig, 'tag', 'tools');
    % tag can be
    % 'import data'  -> File > import data menu
    % 'import epoch' -> File > import epoch menu
    % 'import event' -> File > import event menu
    % 'export'       -> File > export
    % 'tools'        -> tools menu
    % 'plot'         -> plot menu

    % command to check that the '.source' is present in the EEG structure
    % -------------------------------------------------------------------
    % check_dipfit = [trystrs.no_check 'if ~isfield(EEG, ''dipfit''), error(''Run the dipole setting first''); end;'  ...
    %                'if isempty(EEG.dipfit), error(''Run the dipole setting first''); end;'  ];
    %check_dipfitnocheck = [ trystrs.no_check 'if ~isfield(EEG, ''dipfit''), error(''Run the dipole setting first''); end; ' ];
    %check_chans = [ '[EEG tmpres] = eeg_checkset(EEG, ''chanlocs_homogeneous'');' ...
     %                  'if ~isempty(tmpres), eegh(tmpres), end; clear tmpres;' ];

    % menu callback commands
    % ----------------------
    comGenSeqData =         'EEG = pop_generate_sequenceData(EEG);';
    %[ trystrs.check_ica check_chans '[EEG LASTCOM]=testfunc(EEG);'    catchstrs.store_and_hist ];
    comCalcEegFeature =     'EEG = pop_calculate_EEG_feature(EEG);';
    comOddballPotential   = []; %[ check_dipfit check_chans  '[EEG LASTCOM] = pop_dipfit_gridsearch(EEG);'    catchstrs.store_and_hist ];
    comCalcIbPred     =     'EEG = pop_calculate_IB_predictors(EEG);';
                            % 'LASTCOM = ''% === History not supported for manual dipole fitting ==='';' ]  catchstrs.store_and_hist ];
    comFit    =             'EEG = pop_calculate_IB_model_fit_map(EEG);';  %[ check_dipfit check_chans  '[EEG LASTCOM] = pop_multifit(EEG);'        catchstrs.store_and_hist ];
    % preserve the '=" sign in the comment above: it is used by EEGLAB to detect appropriate LASTCOM
    comModelPlot    =       []; %[ check_dipfit check_chans 'LASTCOM = pop_dipplot(EEG);'                     catchstrs.add_to_hist ];
    comPval    =            []; %[ check_dipfit check_chans 'LASTCOM = pop_dipplot(EEG);'                     catchstrs.add_to_hist ];


    % create menus
    % ------------
%     submenu = uimenu( menu, 'Label', 'Locate dipoles using DIPFIT 2.x', 'separator', 'on');
    submenu = uimenu( menu, 'Label', 'IB surprise analysis', 'separator', 'on');
    uimenu( submenu, 'Label', 'Create sequence data'   , 'CallBack', comGenSeqData);
    uimenu( submenu, 'Label', 'Calculate EEG feature per trial'   , 'CallBack', comCalcEegFeature);
    uimenu( submenu, 'Label', 'Plot oddball probability potential'   , 'CallBack', comOddballPotential);
    uimenu( submenu, 'Label', 'Calculate IB predictors'  , 'CallBack', comCalcIbPred);
    uimenu( submenu, 'Label', 'Calculate model fit map'     , 'CallBack', comFit);
    uimenu( submenu, 'Label', 'Best model analysis (SRP, single trials and means regression)', 'CallBack', comModelPlot);
    uimenu( submenu, 'Label', 'Calculate p-value (permutation test)'  , 'CallBack', comPval, 'separator', 'on');