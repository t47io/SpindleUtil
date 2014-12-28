function [data_box, data_line] = spindle_quantitate(im_input, rot_angle, coord_xy, CEN_LINE_OFFSET)

if ~exist('CEN_LINE_OFFSET','var') || isempty(CEN_LINE_OFFSET);
    CEN_LINE_OFFSET = 5;
end;

coord_xy = num2cell(coord_xy);
[y1, y2, x1, x2, x0] = deal(coord_xy{:});
if y1 > y2; [y1, y2] = deal(y2, y1); end;
if x1 > x2; [x1, x2] = deal(x2, x1); end;

im_input = imrotate(im_input, rot_angle, 'crop');
trace_sub = im_input(round(y1):round(y2), round(x1):round(x2), :);

data_box = zeros(size(trace_sub, 1), 3);
data_box(:, 1) = mean(trace_sub(:, :, 1), 2);
data_box(:, 2) = mean(trace_sub(:, :, 2), 2);
data_box(:, 3) = mean(trace_sub(:, :, 3), 2);

x0 = round(x0 - x1);
data_line = zeros(size(trace_sub, 1), 3);
data_line(:, 1) = mean(trace_sub(:, [x0-CEN_LINE_OFFSET, x0, x0+CEN_LINE_OFFSET], 1), 2);
data_line(:, 2) = mean(trace_sub(:, [x0-CEN_LINE_OFFSET, x0, x0+CEN_LINE_OFFSET], 2), 2);
data_line(:, 3) = mean(trace_sub(:, [x0-CEN_LINE_OFFSET, x0, x0+CEN_LINE_OFFSET], 3), 2);
