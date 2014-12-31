function [spd_data] = spindle_mat_calc_ratio(spd_data, list_good)

for i = 1:length(list_good);
    idx = spindle_mat_find_ID(spd_data, list_good{i});
    spd_data{idx}.ratio_box = spd_data{idx}.data_box(:,2) ./ spd_data{idx}.data_box(:,1);
    spd_data{idx}.ratio_line = spd_data{idx}.data_line(:,2) ./ spd_data{idx}.data_line(:,1);
    spd_data{idx}.plot_x = linspace(0, 1, size(spd_data{idx}.data_line, 1));
end;
