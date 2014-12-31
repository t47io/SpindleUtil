function [spd_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = spindle_mat_plot_ratio(spd_data, list_plot, y_lim, NUM_BIN, str_title, file_name, dir_name)

[spd_data, ratio_box_mean, ratio_box_std, ratio_line_mean, ratio_line_std] = spindle_mat_average_ratio(spd_data, list_plot, NUM_BIN);

if ~exist('dir_name','var') || isempty(dir_name); dir_name = [spd_data{1}.raw_file(1: strfind(spd_data{1}.raw_file, '/')-1), '_analysis']; end;
if ~exist('y_lim','var') || isempty(y_lim); y_lim = 2.0; end;
if ~exist('str_title','var') || isempty(str_title); str_title = dir_name(1:end-9); end;
if ~exist('file_name','var') || isempty(file_name); file_name = 'ratio'; end;

clrmap = jet(length(list_plot));
figure();
set_print_page(gcf, 0);

subplot(3,1,1); hold on;
for i = 1:length(list_plot);
    idx = spindle_mat_find_ID(spd_data, list_plot{i});
    plot(spd_data{idx}.plot_x, spd_data{idx}.ratio_box, 'color', clrmap(i, :));
end;
plot(linspace(0,1,NUM_BIN), ratio_box_mean, 'ko-','markersize',3);
axis([0 1 0 y_lim]);
legend(list_plot,'Location','EastOutside');
xlabel('Inter-Pole Percentage (north -> south)');
ylabel('FITC/TexRd Ratio');
title(str_title,'fontsize',16,'fontweight','bold'); 

subplot(3,1,2); hold on;
for i = 1:length(list_plot);
    idx = spindle_mat_find_ID(spd_data, list_plot{i});
    plot(spd_data{idx}.plot_x, spd_data{idx}.ratio_line, 'color', clrmap(i, :));
end;
plot(linspace(0,1,NUM_BIN), ratio_line_mean, 'ko-','markersize',3);
axis([0 1 0 y_lim]);
legend(list_plot,'Location','EastOutside');
xlabel('Inter-Pole Percentage (north -> south)');
ylabel('FITC/TexRd Ratio');
title('FITC/TexRd Ratio ({\color{blue}[top] BOX}; {\color{red}[bottom] LINE})','fontsize',14,'fontweight','bold'); 

subplot(3,1,3); hold on;
plot(linspace(0,1,NUM_BIN), ratio_box_mean, 'bo-','markersize',3);
plot(linspace(0,1,NUM_BIN), ratio_line_mean, 'ro-','markersize',3);
h = errorbar(linspace(0,1,NUM_BIN), ratio_box_mean, ratio_box_std, 'b');
errorbar_tick(h, 500);
h = errorbar(linspace(0,1,NUM_BIN), ratio_line_mean, ratio_line_std, 'r');
errorbar_tick(h, 500);
axis([0 1 0 y_lim]);
legend('Box','Line','Location','EastOutside');
xlabel('Inter-Pole Percentage (north -> south)');
ylabel('FITC/TexRd Ratio');
title(['FITC/TexRd Ratio ({\color{blue}BOX} vs {\color{red}LINE}), {\color[rgb]{0,0.5,0}n = ', num2str(length(list_plot)), '}'],'fontsize',14,'fontweight','bold'); 

print_save_figure(gcf, file_name, dir_name);
