function [spd_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = spindle_mat_average_ratio(spd_data, list_good)

NUM_BIN = 100;

ratio_box_all = zeros(length(list_good), NUM_BIN);
ratio_line_all = zeros(length(list_good), NUM_BIN);
for i = 1:length(list_good);
    idx = spindle_mat_find_ID(spd_data, list_good{i});
    ratio_box_sub = spd_data{idx}.ratio_box;
    ratio_line_sub = spd_data{idx}.ratio_line;
    x_sub = spd_data{idx}.plot_x;
    
    for j = 1:NUM_BIN;
        idx_bin = find(x_sub > (j-1)/NUM_BIN & x_sub <= j/NUM_BIN);
        ratio_box_all(i, j) = mean(ratio_box_sub(idx_bin));
        ratio_line_all(i, j) = mean(ratio_line_sub(idx_bin));
    end;
    spd_data{idx}.ratio_box_100 = ratio_box_all(i, :);
    spd_data{idx}.ratio_line_100 = ratio_line_all(i, :);
end;

ratio_box_mean = mean(ratio_box_all, 1);
ratio_box_std = std(ratio_box_all, 0, 1);
ratio_line_mean = mean(ratio_line_all, 1);
ratio_line_std = std(ratio_line_all, 0, 1);
