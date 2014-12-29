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
if ~exist([dir_name,'_analysis'],'dir'); mkdir([dir_name,'_analysis']); end;
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
for i = 1:length(list_good);
    idx = spindle_mat_find_ID(spd_data, list_good{i});
    spd_data{idx}.ratio_box_100 = spd_data{idx}.ratio_box_100';
    spd_data{idx}.ratio_line_100 = spd_data{idx}.ratio_line_100';
    spd_data{idx}.plot_x = spd_data{idx}.plot_x';
end;
clear('i', 'idx');
save([dir_name,'_analysis/save.mat']);
fprintf('Saved workspace file: %s\n', [dir_name,'_analysis/save.mat']);

log_cleanup([dir_name,'_analysis/log.txt']);
fprintf('Saved screen log file: %s\n', [dir_name,'_analysis/log.txt']);
diary off;
toc;

