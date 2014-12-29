function spindle_excel_plot_ratio(spd_data, flag)

% flag = 1 for scaled x-axis
if flag;
    x_lbl = 'Normalized Position by Inter-Peak Distance (%)';
else
    x_lbl = 'Normalized Position (%)';
end;

xlabel(x_lbl);
ylabel('Ratio (I_M_C_A_K / I_M_T)');
str_legend = {};
clr_map = jet(length(spd_data.list_aligned));
for i = 1:length(spd_data.list_aligned);
    idx = spindle_excel_find_ID(spd_data, spd_data.list_aligned(i));
    if flag;
        plot(spd_data.data{idx}.x_norm, ...
            spd_data.data{idx}.data_FITC ./ spd_data.data{idx}.data_TexRd, ...
            'color', clr_map(i,:));
    else
        plot(linspace(0,1, length(spd_data.data{idx}.data_FITC)), ...
            spd_data.data{idx}.data_FITC ./ spd_data.data{idx}.data_TexRd, ...
            'color', clr_map(i,:));
    end;
    str_legend{length(str_legend) + 1} = num2str(spd_data.list_aligned(i));
end;
legend(str_legend,'Location','EastOutside');

if flag;
    plot([spd_data.parameters.PEAK_POS_LEFT, spd_data.parameters.PEAK_POS_LEFT], [0, 2], 'k:');
    plot([spd_data.parameters.PEAK_POS_RIGHT, spd_data.parameters.PEAK_POS_RIGHT], [0, 2], 'k:');
end;