% plot_wshade() - plot line with shaded area
% 
%
% Usage:
%       plot_wshade(x_data, y_data, y_sdata) % use default
%       plot_wshade(x_data, y_data, y_sdata, 'key', val, ...)
%
% Required input:
%       x_data 1-d array (n x 1: n is number of datapoints)
%       y_data  1-d or 2-d array (n x m: n is number of datapoints, m is number of datatypes)
%       y_sdata 1-d or 2-d array 
%               symmetrical shade (n x m: n is number of datapoints, m is number of datatypes)
%               asymmetrical shade (k x m: k should be twice number of datapoints([upper side; lowerside]), m is number of datatypes)
%                   
%
% Optional inputs:
% 'l_Color'     - [r g b] Line color
% 'f_Color'     - [r g b] Color of shaded area
% 'f_FaceAlpha' - Tranceparent level of shaded area
% 'xLim'        - [min max] limits for x axis
% 'yLim'        - [min max] limits for x axis
%
% Authors: Takahiro Hirao (takahiro.hirao@gmail.com) 

function plot_wshade(x_data, y_data, y_sdata, varargin)

if nargin < 3
    help plot_wshade;
    return;
end

len_y_data = size(y_data,1); len_y_sdata = size(y_sdata,1);

% default params
Mycolor     = colormap(gray(size(y_sdata,2)));
l_color     = Mycolor; 
l_lw        = 2;
f_color     = Mycolor;
f_facealpha = 0.3;
xl          = [min(x_data), max(x_data)]; 
if len_y_data == len_y_sdata
    yl = [min(y_data-y_sdata), max(y_data+y_sdata)];
elseif len_y_data == len_y_sdata/2
    yl = [min(y_data-y_sdata(len_y_sdata/2+1:end, :)), max(y_data+y_sdata(1:len_y_sdata/2, :))];
else
    error('Unexpected number of datapoints')
end

if ~isempty(varargin)
    for c = 1 : floor(length(varargin)/2)
        try
            switch varargin{2*c-1}
                case 'l_Color'; l_color = varargin{2*c};
                case 'l_LineWidth'; l_lw = varargin{2*c};
                case 'f_Color'; f_color = varargin{2*c}; 
                case 'f_FaceAlpha';  f_facealpha = varargin{2*c};
                case 'xLim'; xl = varargin{2*c};
                case 'yLim'; yl = varargin{2*c};
            end
        catch
            error(['An error was found:', varargin{2*c-1}])
        end
    end
end

x4fill=[x_data; x_data(end:-1:1)];

for i = 1 : size(y_sdata,2)
    if len_y_data == len_y_sdata
        y4fill=[y_data(:,i)+y_sdata(:, i); flip(y_data(:,i)-y_sdata(:, i))];
    elseif len_y_data == len_y_sdata/2
        y4fill=[y_data(:,i)+y_sdata(1:len_y_sdata/2, i); flip(y_data(:,i)-y_sdata(len_y_sdata/2+1:end, i))];
    end
    fill(x4fill, y4fill,  f_color(i,:), 'FaceAlpha',f_facealpha, 'EdgeColor', 'none')
    hold on
    plot(x_data, y_data(:,i), 'Color', l_color(i,:), 'LineWidth', l_lw)
    xlim(xl); ylim(yl);
end

hold off

end