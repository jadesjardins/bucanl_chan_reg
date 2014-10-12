% pop_chan_reg() - Perform Eye Regression on segmented data.
%
% Usage: 
%   >>  EEG = pop_chan_reg( EEG, EyeCh );
%
% Inputs:
%   EEG         - input EEG dataset
%   EyeCh       - Index of bipolar eye channel or enter two channel indices to create a bipolar channel.
%    
% Outputs:
%   EEG  - output dataset
%
% See also:
%   EEGLAB 

% Copyright (C) <2006>  <James Desjardins> Brock University
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
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function [EEG,com]=pop_EyeReg(EEG,EyeCh)

com = ''; % this initialization ensure that the function will return something
          % if the user press the cancel button            

% display help if not enough arguments
% ------------------------------------
if nargin < 1
	help pop_EyeReg;
	return;
end;	

% pop up window
% -------------
if nargin < 2

    results=inputgui( ...
    {[1] [2 1 1] [1]}, ...
    {...
        {'Style', 'text', 'string', 'Enter channel regression parameters.', 'FontWeight', 'bold'}, ...
        {'Style', 'text', 'string', 'Regression channel(s)'}, ...
        {'Style', 'edit', 'tag', 'EyeChDisp'}, ...
        {'Style', 'pushbutton', 'string', '...', ...
        'callback', 'set(findobj(gcbf, ''tag'', ''EyeChDisp''), ''string'', int2str(pop_chansel({EEG.chanlocs.labels}, ''withindex'', ''on'')));'}, ...
        {'Style', 'checkbox', 'string', 'Enable Gratton & Coles correction'}, ...
    }, ...
    'pophelp(''pop_EyeReg'');', 'Artifact Correction (Eye regression) -- pop_EyeReg()' ...
    );
    
    EyeCh  	 = results{1};
    GCCor    = results{2};

end;


% return the string command
% -------------------------
com = sprintf('EEG = pop_chan_reg( %s, %s, %s );', inputname(1), vararg2str(EyeCh),GCCor)

% call function "EyeReg" on raw data.
% ---------------------------------------------------
EEG=chan_reg(EEG,EyeCh,GCCor);



