function obj_chosen = spindle_mat_pick(spd_data, str_title, file_name, y_lim, NUM_BIN)

if ~exist('y_lim','var') || isempty(y_lim); y_lim = 2.0; end;
if ~exist('NUM_BIN','var') || isempty(NUM_BIN); NUM_BIN = 100; end;
if ~exist('str_title','var'); str_title = ''; end;
if ~exist('file_name','var') || isempty(file_name); file_name = 'ratio_pick'; end;

list_input = input('Type in spindle IDs (MATLAB expression, e.g. [1:10,12].\nOnly spindles not marked as is_bad will be selected.\nInput: ');
list_chosen = {};

for i = 1:length(list_input);
    idx = spindle_mat_find_ID(spd_data, list_input(i));
    
    if idx == -1; continue; end;
    
    if ~spd_data{idx}.is_bad;
        list_chosen = [list_chosen, spd_data{idx}.raw_file(end-3:end-1)];
    end;
end;
    
[~, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = spindle_mat_plot_ratio(spd_data, list_chosen, y_lim, NUM_BIN, str_title, file_name, './');

obj_chosen.list_chosen = list_chosen;
obj_chosen.ratio_box_mean = ratio_box_mean;
obj_chosen.ratio_box_std = ratio_box_std;
obj_chosen.ratio_line_mean = ratio_line_mean;
obj_chosen.ratio_line_std = ratio_line_std;
