function [spd_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = spindle_mat_plot_ratio(spd_data, list_good, dir_name)

for i = 1:length(list_good);
    idx = spindle_mat_find_ID(spd_data, list_good{i});
    spd_data{idx}.ratio_box = spd_data{idx}.data_box(:,2) ./ spd_data{idx}.data_box(:,1);
    spd_data{idx}.ratio_line = spd_data{idx}.data_line(:,2) ./ spd_data{idx}.data_line(:,1);
    spd_data{idx}.plot_x = linspace(0, 1, size(spd_data{idx}.data_line, 1));
end;
[spd_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = spindle_mat_average_ratio(spd_data, list_good);


clrmap = jet(length(list_good));
figure();
set_print_page(gcf, 0);

subplot(3,1,1); hold on;
for i = 1:length(list_good);
    idx = spindle_mat_find_ID(spd_data, list_good{i});
    plot(spd_data{idx}.plot_x, spd_data{idx}.ratio_box, 'color', clrmap(i, :));
end;
plot(linspace(0,1,100), ratio_box_mean, 'ko-','markersize',3);
axis([0 1 0 1.5]);
legend(list_good,'Location','EastOutside');
xlabel('Inter-Pole Percentage (north -> south)');
ylabel('FITC/TexRd Ratio');
title('FITC/TexRd Ratio (Box)','fontsize',14,'fontweight','bold'); 

subplot(3,1,2); hold on;
for i = 1:length(list_good);
    idx = spindle_mat_find_ID(spd_data, list_good{i});
    plot(spd_data{idx}.plot_x, spd_data{idx}.ratio_line, 'color', clrmap(i, :));
end;
plot(linspace(0,1,100), ratio_line_mean, 'ko-','markersize',3);
axis([0 1 0 1.5]);
legend(list_good,'Location','EastOutside');
xlabel('Inter-Pole Percentage (north -> south)');
ylabel('FITC/TexRd Ratio');
title('FITC/TexRd Ratio (Line)','fontsize',14,'fontweight','bold'); 

subplot(3,1,3); hold on;
plot(linspace(0,1,100), ratio_box_mean, 'bo-','markersize',3);
plot(linspace(0,1,100), ratio_line_mean, 'ro-','markersize',3);
h = errorbar(linspace(0,1,100), ratio_box_mean, ratio_box_std, 'b');
errorbar_tick(h, 500);
h = errorbar(linspace(0,1,100), ratio_line_mean, ratio_line_std, 'r');
errorbar_tick(h, 500);
axis([0 1 0 1.5]);
legend('Box','Line','Location','EastOutside');
xlabel('Inter-Pole Percentage (north -> south)');
ylabel('FITC/TexRd Ratio');
title('FITC/TexRd Ratio (Line vs Box)','fontsize',14,'fontweight','bold'); 

print_save_figure(gcf, 'ratio', [dir_name, '_analysis']);
