%formatTickLabels(h, varargin) formats the x- and y-axis tick labels using format specifiers
% The default format uses the largest number of decimals found, except for '0'.
%
% Inputs:
%         h : figure handle
%
% Optional:
%   xformat : string specifier for the x-axis format
%   yformat : string specifier for the y-axis format
%
% Examples: formatTickLabels(h);
%           formatTickLabels(h, [], '%.3f');

% Francois Aguet, 2012

function formatTickLabels(varargin)
ip = inputParser;
ip.CaseSensitive = false;
ip.addOptional('h', gca, @(x) all(arrayfun(@ishandle, x)));
ip.addOptional('XFormat', [], @(x) isempty(x) || ischar(x));
ip.addOptional('YFormat', [], @ischar);
ip.addParamValue('FormatXY', [true true], @(x) islogical(x) && numel(x)==2);
ip.parse(varargin{:});
h = ip.Results.h;
xfmt = ip.Results.XFormat;
yfmt = ip.Results.YFormat;

for i = 1:numel(h)
    
    if ip.Results.FormatXY(1)
        xticks = cellstr(get(h(i), 'XTickLabel'));
        ppos = regexpi(xticks, '\.');
        nchar = cellfun(@numel, xticks);
        idx = ~cellfun(@isempty, ppos);
        if ~all(idx==0) || ~isempty(xfmt)
            val = cellfun(@str2num, xticks);
            if isempty(xfmt)
                nd = max(nchar(idx)-[ppos{idx}]');
                xfmt = ['%.' num2str(nd) 'f'];
            end
            xticks = arrayfun(@(i) num2str(i, xfmt), val, 'unif', 0);
            idx = find(val==0);
            if ~isempty(idx)
                xticks{idx} = '0';
            end
            set(h(i), 'XTick', val, 'XTickLabel', xticks);
        end
    end
    if ip.Results.FormatXY(2)
        yticks = cellstr(get(h(i), 'YTickLabel'));
        ppos = regexpi(yticks, '\.');
        nchar = cellfun(@numel, yticks);
        idx = ~cellfun(@isempty, ppos);
        if ~all(idx==0)
            val = cellfun(@str2num, yticks);
            if isempty(yfmt)
                nd = max(nchar(idx)-[ppos{idx}]');
                yfmt = ['%.' num2str(nd) 'f'];
            end
            yticks = arrayfun(@(i) num2str(i, yfmt), val, 'unif', 0);
            idx = find(val==0);
            if ~isempty(idx)
                yticks{idx} = '0';
            end
            set(h(i), 'YTick', val, 'YTickLabel', yticks);
        end
    end
end
