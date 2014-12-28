function spindle_mat_analysis(dir_name, CEN_LINE_OFFSET, POLE_PORTION)

if ~exist('CEN_LINE_OFFSET','var') || isempty(CEN_LINE_OFFSET);
    CEN_LINE_OFFSET = 5;
end;
if ~exist('POLE_PORTION','var') || isempty(POLE_PORTION);
    POLE_PORTION = 1/24;
end;
if ~exist(dir_name, 'dir');
    fprintf(2, 'ERROR: directory not found.\n');
    return;
end;

tic;
diary([dir_name,'_analysis/log.txt']);

spd_data = spindle_read_folder(dir_name, CEN_LINE_OFFSET, POLE_PORTION);

list_good = {};
list_bad = {};
for i = 1:length(spd_data);
    if ~spd_data{i}.is_bad;
        spindle_mat_summary(spd_data{i});
        list_good = [list_good, spd_data{i}.raw_file(end-3:end-1)];
    else
        list_bad = [list_bad, spd_data{i}.raw_file(end-3:end-1)];
    end;
    
    if ~mod(i, 6); close all; end;
end;
close all;
[spd_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = spindle_mat_plot_ratio(spd_data, list_good, dir_name);

% assignin('base', 'file_name', file_name);
save([dir_name,'_analysis/save.mat']);

diary off;
log_cleanup([dir_name,'_analysis/log.txt']);
toc;

