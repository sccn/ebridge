function [EEG, com] = pop_ebridge(EEG, varargin)
% pop_ebridge - pop-up interface for eBridge: identify low-impedance electrical bridges.
%
% Usage:
%   >> [EEG, com] = pop_ebridge(EEG);
%   >> [EEG, com] = pop_ebridge(EEG, 'BCT', 0.5, 'BinSize', 0.25, 'PlotMode', 1, ...
%                               'Verbose', 1, 'EpLength', 0, 'FiltMode', 0, 'ExChans', {});
%
% This function displays a simple GUI to set the Bridge Classification Threshold (BCT)
% along with other parameters and then calls eBridge. The results are stored in EEG.etc.eBridge.
%
% Author: Arnaud Delorme, UCSD (wrapper only)
%         Daniel Alschuler, eBridge function

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

com = '';

if nargin < 1
    help pop_ebridge;
    error('pop_ebridge requires an EEG structure as input.');
end

% If no extra arguments provided, use a GUI to ask for parameters.
if nargin < 2
    prompt = { 'BCT (0-1):', 'BinSize (e.g., 0.25):', 'PlotMode (0:no, 1:if bridged, 2:always):', ...
               'Verbose (0,1,2):', 'EpLength (0 for auto):', 'FiltMode (0:no, 1:yes):', ...
               'Exclude Channels (comma-separated)' };
    defAns = { '0.5', '0.25', '1', '1', '0', '0', '' };
    dlgTitle = 'pop_ebridge - options';
    answer = inputdlg2(prompt, dlgTitle, 1, defAns);
    if isempty(answer), return; end
    BCT      = str2double(answer{1});
    BinSize  = str2double(answer{2});
    PlotMode = str2double(answer{3});
    Verbose  = str2double(answer{4});
    EpLength = str2double(answer{5});
    FiltMode = str2double(answer{6});
    if isempty(answer{7})
        ExChans = {};
    else
        % Remove any empty entries if the user adds extra commas or spaces.
        ExChans = strtrim(strsplit(answer{7}, {',',' '}));
        ExChans = ExChans(~cellfun('isempty',ExChans));
    end
else
    % Parse key/value pairs from varargin.
    p = inputParser;
    addParameter(p, 'BCT', 0.5, @(x) isnumeric(x) && (x>0 && x<1));
    addParameter(p, 'BinSize', 0.25, @(x) isnumeric(x) && (x>0 && x<100));
    addParameter(p, 'PlotMode', 1, @(x) any(x == [0 1 2]));
    addParameter(p, 'Verbose', 1, @(x) any(x == [0 1 2]));
    addParameter(p, 'EpLength', 0, @(x) isnumeric(x) && (x>=0));
    addParameter(p, 'FiltMode', 0, @(x) any(x == [0 1]));
    addParameter(p, 'ExChans', {}, @(x) iscell(x) || ischar(x));
    parse(p, varargin{:});
    
    BCT      = p.Results.BCT;
    BinSize  = p.Results.BinSize;
    PlotMode = p.Results.PlotMode;
    Verbose  = p.Results.Verbose;
    EpLength = p.Results.EpLength;
    FiltMode = p.Results.FiltMode;
    ExChans  = p.Results.ExChans;
    if ischar(ExChans)
        ExChans = strtrim(strsplit(ExChans, {',',' '}));
        ExChans = ExChans(~cellfun('isempty',ExChans));
    end
end

% Build the command string for reproducibility.
com = sprintf('pop_ebridge(EEG, ''BCT'', %g, ''BinSize'', %g, ''PlotMode'', %d, ''Verbose'', %d, ''EpLength'', %d, ''FiltMode'', %d, ''ExChans'', {''%s''})', ...
    BCT, BinSize, PlotMode, Verbose, EpLength, FiltMode, strjoin(ExChans, ''','''));

% Call the underlying eBridge function. It returns EB (bridging info) and ED (ED matrix).
try
    if isempty(ExChans)
        [EB, ED] = eBridge(EEG, 'BCT', BCT, 'BinSize', BinSize, 'PlotMode', PlotMode, ...
                           'Verbose', Verbose, 'EpLength', EpLength, 'FiltMode', FiltMode);
    else
        [EB, ED] = eBridge(EEG, ExChans, 'BCT', BCT, 'BinSize', BinSize, 'PlotMode', PlotMode, ...
                           'Verbose', Verbose, 'EpLength', EpLength, 'FiltMode', FiltMode);
    end
catch ME
    error('Error in eBridge: %s', ME.message);
end

% Save the results into EEG.etc.
if ~isfield(EEG, 'etc')
    EEG.etc = [];
end
EEG.etc.eBridge = EB;
if nargout > 1
    EEG.etc.eBridge.ED = ED;
end
if nargin < 2 
    if isempty(EB.Bridged.Indices)
        warndlg2('No bridged channels detected');
    else
        warndlg2('Channels detected');
    end
end

if Verbose > 0
    fprintf('pop_ebridge completed. %i bridged channels identified.\n', EB.Bridged.Count);
end