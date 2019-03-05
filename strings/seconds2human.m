function out = seconds2human(secs, varargin)
%SECONDS2HUMAN Converts the given number of seconds into a human-readable string.
% Usage:
%   str = SECONDS2HUMAN(seconds) returns a human-readable string from a
%   given (usually large) amount of seconds. For example,
%
%       str = seconds2human(1463456.3)
%       str =
%       '2 weeks, 2 days, 22 hours, 30 minutes, 56 seconds'
%
%   You may also call the function with a second input argument; either
%   'short' or 'full' (the default). This determines the level of detail
%   returned in the string:
%
%       str = seconds2human(1463456.3, 'short')
%       str =
%       'About 2 weeks and 2 days'
%
%   The 'short' format returns only the two largest units of time.
%
%   [secs] may be an NxM-matrix, in which case the output is an NxM cell
%   array of the corresponding strings.
%
%   NOTE: SECONDS2HUMAN() defines one month as an "average" month, which
%   means that the string 'month' indicates 30.471 days.
%
%   See also datestr, datenum, etime.

% Please report bugs and inquiries to:
%
% Name       : Rody P.S. Oldenhuis
% E-mail     : oldenhuis@gmail.com    (personal)
%              oldenhuis@luxspace.lu  (professional)
% Affiliation: LuxSpace sàrl
% Licence    : GPL + anything implied by placing it on the FEX

% Changelog
%{
2014/February/28 (Rody Oldenhuis) (Pick of the week!)
- Added 'Decennia'
- Added checks on IO arguments
- Updated contact info & documentation

2009/February (Rody Oldenhuis)
- Added proper documentation
- Cleanup & re-write

2008 (?) (Rody Oldenhuis
- Initial version
%}

% TODO
%{
- The bigger time units should be adapted to read 'About 1.6 centuries' or 'About 
  4.5 decennia.' This should not apply to anything smaller ('4.7 years' is not 
  "human" to say)
%}
% If you find this work useful, please consider a donation:
% https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6G3S5UYM7HJ3N
    
    % Some error checking
%     error(nargchk(1,2,nargin, 'struct'));
%     error(nargoutchk(0,1,nargout, 'struct'));
    
    assert(isnumeric(secs) && all(isfinite(secs(:))) && all(imag(secs(:))==0) && all(secs(:)>=0),...
        'seconds2human:seconds_mustbe_numeric', ...
        'Input argument ''secs'' must be finite, real, and all-positive.');
    
    % Define some intuitive variables
    Seconds   = round(1                 );
    Minutes   = round(60     * Seconds  );
    Hours     = round(60     * Minutes  );
    Days      = round(24     * Hours    );
    Weeks     = round(7      * Days     );
    Months    = round(30.471 * Days     );
    Years     = round(365.26 * Days     );
    Decennia  = round(10     * Years    );
    Centuries = round(100    * Years    );    
    Millennia = round(10     * Centuries);
    
    % Put these into an array, and define associated strings
    units = [Millennia, Centuries, Decennia, Years, Months, Weeks, ...
        Days, Hours, Minutes, Seconds];
    singles = {'millennium'; 'century'; 'decennium'; 'year'; 'month'; ...
        'week'; 'day'; 'hour'; 'minute'; 'second'};
    plurals = {'millennia' ; 'centuries'; 'decennia'; 'years'; 'months'; ...
        'weeks'; 'days'; 'hours'; 'minutes'; 'seconds'};
    
    % Cut off all decimals from the given number of seconds    
    secs = round(secs);
    
    % Parse any second argument
    short = false;
    if (nargin > 1)
        % Extract argument
        short = varargin{1};
        % Check its type and content
        assert(ischar(short),...
            'seconds2human:argument_type_incorrect', ...
            'The second argument must be of type ''char''; got ''%s''.', class(short));
        % Check its content
        switch lower(short)
            case 'full' , short = false;
            case 'short', short = true;
            otherwise
                error('seconds2human:short_format_incorrect',...
                    'The second argument must be either ''short'' or ''full''.');
        end
    end
    
    % Pre-allocate appropriate output-type
    numstrings = numel(secs);
    if (numstrings > 1)
        out = cell(size(secs)); end
    
    % Build (all) output string(s)
    for jj = 1:numstrings
        
        % Initialize nested loop
        secsj   = secs(jj);
        counter = 0;
        if short, string = 'About ';
        else      string = '';
        end
        
        % Possibly quick exit
        if (secsj < 1), string = 'Less than one second.'; end
        
        % Build string for j-th amount of seconds
        for ii = 1:length(units)
            
            % Amount of this unit
            amount = fix(secsj/units(ii));
            
            % Include this unit in the output string
            if amount > 0
                
                counter = counter + 1;
                
                % Append (single or plural) unit of time to string
                if (amount > 1)
                    string = [string, num2str(amount), ' ', plurals{ii}]; %#ok<AGROW>
                else
                    string = [string, num2str(amount), ' ', singles{ii}]; %#ok<AGROW>
                end
                
                % Finish the string after two units if short format is requested
                if (counter > 1 && short)
                    string = [string, '']; break, end %#ok<AGROW>
                
                % Determine whether the ending should be a period (.) or a comma (,)
                if (rem(secsj, units(ii)) > 0)
                    if short, ending = ' and ';
                    else ending = ', ';
                    end
                else ending = '';
                end
                string = [string, ending];%#ok<AGROW>
                
            end
            
            % Subtract this step from given amount of seconds
            secsj = secsj - amount*units(ii);
        end
        
        % Insert in output cell, or set output string
        if (numstrings > 1)
            out{jj} = string;
        else
            out = string;
        end
        
    end % for
    
end % function seconds2human

