% eegplugin_ACor() - EEGLAB plugin for performing Artifact Correction.
%
% Usage:
%   >> eegplugin_ACor(fig, try_strings, catch_stringss);
%
% Inputs:
%   fig            - [integer]  EEGLAB figure
%   try_strings    - [struct] "try" strings for menu callbacks.
%   catch_strings  - [struct] "catch" strings for menu callbacks.
%
%
% Copyright (C) <2006> <James Desjardins> Brock University
%
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

% $Log: eegplugin_ACor.m



function eegplugin_ArtifactOptions(fig,try_strings,catch_strings);


% find "tools" menu.
% ---------------------
toolsmenu=findobj(fig,'tag','tools');


% add "Artifact options" menu to "tools" menu.
% ---------------------------------------
%submenu = uimenu( toolsmenu, 'label', 'Artifact options');

% Create callback cmd.
%---------------------------------------
cmdEyeReg='[EEG,LASTCOM] = pop_chan_reg(EEG);';
finalcmdEyeReg=[try_strings.no_check cmdEyeReg catch_strings.new_and_hist];

%cmdArtRej='[EEG,LASTCOM] = pop_ArtifactRej(EEG);';
%finalcmdArtRej=[try_strings.no_check cmdArtRej catch_strings.new_and_hist];

% add submenus to the "Artifact options" menu.
%--------------------------------------------------------------------
uimenu(toolsmenu, 'label', 'Channel regression', 'callback', finalcmdEyeReg);
%uimenu(submenu, 'label', 'Artifact rejection', 'callback', finalcmdArtRej); 
