function spindle_plot(spd_data)

str_dir = strcat('fig_', spd_data.expCondition);
fprintf('Saved figures to folder: /%s.\n', str_dir);

for i = 1:length(spd_data.data);
    
    if isfield(spd_data.data{i}, 'data_TexRd') && isfield(spd_data.data{i}, 'data_FITC');
        figure();
        set_print_page(gcf, 0);
        str_title = strcat(spd_data.expCondition, '\_', spd_data.data{i}.spindleID);
        
        % plot RED and GREEN overlay
        subplot(2,1,1);
        norm_X = linspace(0, 1, length(spd_data.data{i}.data_TexRd));
        plot(norm_X, spd_data.data{i}.data_TexRd, 'r'); hold on;
        plot(norm_X, spd_data.data{i}.data_FITC, 'color',[0,0.5,0]);
        legend('TexRd', 'FITC', 'Location','Best');
        xlabel('Normalized Position (%)');
        ylabel('Fluorescence Intensity (a.u.)');
        title(str_title, 'fontsize', 20, 'fontweight', 'bold');
        
        % plot GREEN/RED ratio
        subplot(2,1,2);
        plot(norm_X, spd_data.data{i}.data_FITC ./ spd_data.data{i}.data_TexRd, 'bo');
        legend('FITC / TexRd', 'Location','Best');
        xlabel('Normalized Position (%)');
        ylabel('Ratio (I_M_C_A_K / I_M_T)');
        
        print_save_figure(gcf, strcat('raw_', spd_data.data{i}.spindleID), str_dir, [], 0);
    end;
end;

