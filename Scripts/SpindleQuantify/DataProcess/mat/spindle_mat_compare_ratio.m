function spindle_mat_compare_ratio(dir_name, POLE_PORTION, y_lim)

if ~exist('POLE_PORTION','var') || isempty(POLE_PORTION); POLE_PORTION = 1/24; end;
if ~exist('y_lim','var') || isempty(y_lim); y_lim = 2.0; end;

spd_data_cell = cell(1, length(dir_name));
clr_map = jet(length(dir_name));
for i = 1:length(dir_name);
    spd_data_cell{i} = load([dir_name{i},'_analysis/save.mat']);
    spd_data_cell{i}.pole_ratios = spindle_mat_divide_pole(spd_data_cell{i}.spd_data, spd_data_cell{i}.list_good, POLE_PORTION);
end;
close all;
all_poles = [];
group_poles = [];
all_body = [];
group_body = [];
ratio_poles = zeros(1, length(dir_name));
std_poles = zeros(1, length(dir_name));
ratio_body = zeros(1, length(dir_name));
std_body = zeros(1, length(dir_name));
for i = 1:length(dir_name);
    all_poles = [all_poles, spd_data_cell{i}.pole_ratios(:,2)', spd_data_cell{i}.pole_ratios(:,4)'];
    group_poles = [group_poles, repmat(i, 1, size(spd_data_cell{i}.pole_ratios, 1)*2)];
    all_body = [all_body, spd_data_cell{i}.pole_ratios(:,3)'];
    group_body = [group_body, repmat(i, 1, size(spd_data_cell{i}.pole_ratios, 1))];
    ratio_poles(i) = mean([spd_data_cell{i}.pole_ratios(:,2)', spd_data_cell{i}.pole_ratios(:,4)']);
    std_poles(i) = std([spd_data_cell{i}.pole_ratios(:,2)', spd_data_cell{i}.pole_ratios(:,4)'], 0, 2);
    ratio_body(i) = mean([spd_data_cell{i}.pole_ratios(:,3)']);
    std_body(i) = std([spd_data_cell{i}.pole_ratios(:,3)'], 0, 2);
end;

figure(); set_print_page(gcf, 1);
subplot(3,2,1:2); hold on;
for i = 1:length(dir_name);
    plot(linspace(0,1,100), spd_data_cell{i}.ratio_box_mean, 'color', clr_map(i, :));
end;
legend(dir_name, 'Location','EastOutside');
xlabel('Inter-Pole Percentage (north -> south)');
ylabel('FITC/TexRd Ratio');
title('FITC/TexRd Ratio Comparison','fontsize',16,'fontweight','bold');
axis([0 1 0 y_lim]);

subplot(3,2,3); hold on;
boxplot(all_poles, group_poles, 'colors', clr_map);
ylabel('FITC/TexRd Ratio');
title('Pole Ratios','fontsize',16,'fontweight','bold');
axis([0.5 length(dir_name)+0.5 0 y_lim]);

subplot(3,2,4); hold on;
boxplot(all_body, group_body, 'colors', clr_map);
ylabel('FITC/TexRd Ratio');
title('Body Ratios','fontsize',16,'fontweight','bold');
axis([0.5 length(dir_name)+0.5 0 y_lim]);

subplot(3,2,5:6); hold on;
bar([ratio_poles; ratio_body]');
ylabel('FITC/TexRd Ratio');
title('Pole/Body Ratios','fontsize',16,'fontweight','bold');
axis([0.5 length(dir_name)+0.5 0 y_lim]);

print_save_figure(gcf, 'ratio_compare');
