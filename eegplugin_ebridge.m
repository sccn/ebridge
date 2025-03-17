% eegplugin_eBridge() - EEGLAB plugin to detect bridged channels with eBridge
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

function vers = eegplugin_ebridge(fig, try_strings, catch_strings)

% Plugin version
vers = '1.0';

% Add paths to subfolders
if ~exist('ebridge.m', 'file')
    p = fileparts(which('eegplugin_eBridge.m'));
    addpath(p);
end

% find menu
menu = findobj(fig, 'tag', 'tools');

% menu callback
detect = [try_strings.no_check '[EEG, LASTCOM] = pop_ebridge(EEG);' catch_strings.new_and_hist];
uimenu(menu, 'Label', 'Detect Bridged Channels', 'CallBack', detect, 'separator', 'on');