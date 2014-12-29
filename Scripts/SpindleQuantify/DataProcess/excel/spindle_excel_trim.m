function spd_data = spindle_excel_trim(spd_data)
%
% parameter settings
PEAK_FINDER_RANGE = 0.2;
PEAK_RATIO_CUTOFF = 1.8;
PEAK_POS_LEFT = 0.05;
PEAK_POS_RIGHT = 1- PEAK_POS_LEFT;

spd_data.parameters.PEAK_FINDER_RANGE = PEAK_FINDER_RANGE;
spd_data.parameters.PEAK_RATIO_CUTOFF = PEAK_RATIO_CUTOFF;
spd_data.parameters.PEAK_POS_LEFT = PEAK_POS_LEFT;
spd_data.parameters.PEAK_POS_RIGHT =PEAK_POS_RIGHT;

str_dir = strcat('fig_', spd_data.expCondition);

for i = 1:length(spd_data.data);

    size_X = length(spd_data.data{i}.data_FITC);
    norm_X = linspace(0, 1, size_X);
    str_title = strcat(spd_data.expCondition, '\_', spd_data.data{i}.spindleID);

    % find first max(peak) on both ends
    [val_max_left, idx_max_left] = max(spd_data.data{i}.data_FITC(1:round(size_X*PEAK_FINDER_RANGE)));
    [val_max_right, idx_max_right] = max(spd_data.data{i}.data_FITC((size_X-round(size_X*PEAK_FINDER_RANGE)+1):end));

    figure();
    set_print_page(gcf, 0);

    % plot peak postion on origianl trace, using original x-axis
    subplot(2,1,1); hold on;
    xlabel('Normalized Position (%)');
    ylabel('Fluorescence Intensity (a.u.)');
    plot(norm_X, spd_data.data{i}.data_FITC, 'color',[0 0.5 0]);
    plot(idx_max_left/size_X,val_max_left,'ro', 'markersize',6,'MarkerFaceColor','r');
    plot((1-PEAK_FINDER_RANGE)+idx_max_right/size_X,val_max_right,'ro', 'markersize',6,'MarkerFaceColor','r');
    title(str_title, 'fontsize', 20, 'fontweight', 'bold');
    legend('FITC', strcat('left peak:', num2str(val_max_left)), strcat('right peak:',num2str(val_max_right)),'Location','Best');

    % plot using scaled (5%-95% peak) x-axis
    subplot(2,1,2); hold on;
    xlabel('Normalized Peak Position (%)');
    ylabel('Fluorescence Intensity (a.u.)');
    val_max = max(val_max_left, val_max_right);
    val_max2 = min(val_max_left, val_max_right);
    val_min = min(spd_data.data{i}.data_FITC);

    % compare peak intensity
    if (val_max-val_min)/(val_max2-val_min) > PEAK_RATIO_CUTOFF;
        plot(0,0);
        str_error = strcat('Peak intensity ratio out-of-range:', num2str((val_max-val_min)/(val_max2-val_min)));
        title(str_error,'fontsize', 20,'color','r');

        % mark as bad if too different
        bad_flag = '(bad)';
        spd_data.data{i}.is_balanced_peak = false;
    else

        % calculate new x-axis grids
        x_unit = (PEAK_POS_RIGHT - PEAK_POS_LEFT) / ((1-PEAK_FINDER_RANGE)*size_X+idx_max_right - idx_max_left);
        x_start = (1-idx_max_left)*x_unit + PEAK_POS_LEFT;
        x_norm = x_start:x_unit:(x_start + (length(spd_data.data{i}.data_FITC) - 1)* x_unit);
        spd_data.data{i}.x_norm = x_norm;

        plot(x_norm, spd_data.data{i}.data_FITC, 'color',[0 0.5 0]);
        plot(PEAK_POS_LEFT,val_max_left,'ro', 'markersize',6,'MarkerFaceColor','r');
        plot(PEAK_POS_RIGHT,val_max_right,'ro', 'markersize',6,'MarkerFaceColor','r');

        plot([PEAK_POS_LEFT, PEAK_POS_LEFT], [0, val_max_left], 'k:');
        plot([PEAK_POS_RIGHT, PEAK_POS_RIGHT], [0, val_max_right], 'k:');
        str_info = strcat('Normalized to', num2str(PEAK_POS_LEFT), '-', num2str(PEAK_POS_RIGHT));
        legend(str_info,'Location','Best');
        bad_flag = '';
        spd_data.data{i}.is_balanced_peak = true;
    end;

    print_save_figure(gcf, strcat('normalize_', spd_data.data{i}.spindleID, bad_flag), str_dir, [] ,0);
end;

% save align/unalign statistics
list_good = [];
list_bad = [];
for i = 1:length(spd_data.data);
    if spd_data.data{i}.is_balanced_peak;
        list_good = [list_good, str2double(spd_data.data{i}.spindleID)];
    else
        list_bad = [list_bad,  str2double(spd_data.data{i}.spindleID)];
    end;
end;
spd_data.n_aligned = length(list_good);
spd_data.n_unaligned = length(list_bad);
spd_data.list_aligned = list_good;
spd_data.list_unaligned = list_bad;
fprintf('<strong>Aligned %d datasets by inter-peak distance.</strong>\n', spd_data.n_aligned);


%%%
% plot overlay ratio
figure();
set_print_page(gcf, 0);
subplot(2,1,1); hold on;
title(spd_data.expCondition, 'fontsize', 20, 'fontweight', 'bold');
spindle_excel_plot_ratio(spd_data, 0);
subplot(2,1,2); hold on;
spindle_excel_plot_ratio(spd_data, 1);
title('FITC/TexRd Ratio', 'fontsize', 20, 'fontweight', 'bold');
print_save_figure(gcf, 'overlay_ratio', str_dir, [] ,0);

% plot overlay FITC, TexRd separately
figure();
set_print_page(gcf, 0);
subplot(2,1,1); hold on;
title(spd_data.expCondition, 'fontsize', 20, 'fontweight', 'bold');
spindle_excel_plot_trace(spd_data, 0, 1);
subplot(2,1,2); hold on;
spindle_excel_plot_trace(spd_data, 1, 1);
title('FITC Trace', 'fontsize', 20, 'fontweight', 'bold');
print_save_figure(gcf, 'overlay_FITC', str_dir, [] ,0);

figure();
set_print_page(gcf, 0);
subplot(2,1,1); hold on;
title(spd_data.expCondition, 'fontsize', 20, 'fontweight', 'bold');
spindle_excel_plot_trace(spd_data, 0, 0);
subplot(2,1,2); hold on;
spindle_excel_plot_trace(spd_data, 1, 0);
title('TexRd Trace', 'fontsize', 20, 'fontweight', 'bold');
print_save_figure(gcf, 'overlay_TexRd', str_dir, [] ,0);

figure();
set_print_page(gcf, 0);
subplot(2,1,1); hold on;
title(spd_data.expCondition, 'fontsize', 20, 'fontweight', 'bold');
spindle_excel_plot_trace(spd_data, 1, 1);
subplot(2,1,2); hold on;
spindle_excel_plot_trace(spd_data, 1, 0);
title('FITC(up) TexRd(down) Trace', 'fontsize', 20, 'fontweight', 'bold');
print_save_figure(gcf, 'overlay_both', str_dir, [] ,0);

% plot trace scaled by total intensity
figure();
set_print_page(gcf, 0);
subplot(2,1,1); hold on;
title('FITC scaled by sum(FITC)', 'fontsize', 20, 'fontweight', 'bold');
xlabel('Normalized Position by Inter-Peak Distance (%)');
ylabel('Fluorescence Intensity (a.u.)');
str_legend = {};
clr_map = jet(length(spd_data.list_aligned));
for i = 1:length(spd_data.list_aligned);
    idx = spindle_excel_find_ID(spd_data, spd_data.list_aligned(i));
    plot(spd_data.data{idx}.x_norm, ...
        spd_data.data{idx}.data_FITC / sum(spd_data.data{idx}.data_FITC), ...
        'color', clr_map(i,:));
    str_legend{length(str_legend) + 1} = num2str(spd_data.list_aligned(i));
end;
legend(str_legend,'Location','EastOutside');
plot([spd_data.parameters.PEAK_POS_LEFT, spd_data.parameters.PEAK_POS_LEFT], ...
    [0, max(spd_data.data{idx}.data_FITC / sum(spd_data.data{idx}.data_FITC))], 'k:');
plot([spd_data.parameters.PEAK_POS_RIGHT, spd_data.parameters.PEAK_POS_RIGHT], ...
    [0, max(spd_data.data{idx}.data_FITC / sum(spd_data.data{idx}.data_FITC))], 'k:');

subplot(2,1,2); hold on;
title('TexRd scaled by sum(TexRd)', 'fontsize', 20, 'fontweight', 'bold');
xlabel('Normalized Position by Inter-Peak Distance (%)');
ylabel('Fluorescence Intensity (a.u.)');
clr_map = jet(length(spd_data.list_aligned));
for i = 1:length(spd_data.list_aligned);
    idx = spindle_excel_find_ID(spd_data, spd_data.list_aligned(i));
    plot(spd_data.data{idx}.x_norm, ...
        spd_data.data{idx}.data_TexRd / sum(spd_data.data{idx}.data_TexRd), ...
        'color', clr_map(i,:));
end;
legend(str_legend,'Location','EastOutside');
plot([spd_data.parameters.PEAK_POS_LEFT, spd_data.parameters.PEAK_POS_LEFT], ...
    [0, max(spd_data.data{idx}.data_TexRd / sum(spd_data.data{idx}.data_TexRd))], 'k:');
plot([spd_data.parameters.PEAK_POS_RIGHT, spd_data.parameters.PEAK_POS_RIGHT], ...
    [0, max(spd_data.data{idx}.data_TexRd / sum(spd_data.data{idx}.data_TexRd))], 'k:');
print_save_figure(gcf, 'overlay_normalized intensity', str_dir, [] ,0);

