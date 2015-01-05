function pole_ratios = spindle_mat_divide_pole(spd_data, list_good, POLE_PORTION)

pole_ratios = zeros(length(list_good), 4);

for i = 1:length(list_good);
    idx = spindle_mat_find_ID(spd_data, list_good{i});
    pole_ratios(i, 1) = str2double(list_good{i});

    ratio_box = spd_data{idx}.ratio_box;
    pole_idx = round(length(ratio_box) * POLE_PORTION);
    
    pole_ratios(i, 2) = mean(ratio_box(1:pole_idx));
    pole_ratios(i, 3) = mean(ratio_box(pole_idx+1: end-pole_idx-1));
    pole_ratios(i, 4) = mean(ratio_box(end-pole_idx:end));
end;

figure(); set_print_page(gcf,0);
boxplot(pole_ratios(:, 2:4), 'label', {'POLE_left', 'BODY', 'POLE_right'});
title([spd_data{1}.raw_file(1:end-4), ' {\color{red}POLE\_PORTION = 1/', num2str(1/POLE_PORTION),'}'], 'fontsize',14,'fontweight','bold');
