function spindle_plot_ratio_compare(spd_all)

for i = 1:length(spd_all) - 1;
    for j = i + 1:length(spd_all);
        figure();
        set_print_page(gcf, 0);
        subplot(2,1,1); hold on;
        title(spd_all{i}.expCondition, 'fontsize', 20, 'fontweight', 'bold');
        spindle_plot_ratio(spd_all{i}, 1);
        axis([0 1 0 2]);

        subplot(2,1,2); hold on;
        title(spd_all{j}.expCondition, 'fontsize', 20, 'fontweight', 'bold');
        spindle_plot_ratio(spd_all{j}, 1);
        axis([0 1 0 2]);
        
        file_name = ['compare_', spd_all{i}.expCondition, '_vs_', spd_all{j}.expCondition];
        print_save_figure(gcf, file_name, './', [] ,0);

    end;
end;