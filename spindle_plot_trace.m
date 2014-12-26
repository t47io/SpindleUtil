function spindle_plot_trace(spd_data, flag, selec)

% flag = 1 for scaled x-axis
if flag;
    x_lbl = 'Normalized Position by Inter-Peak Distance (%)';
else
    x_lbl = 'Normalized Position (%)';
end;

xlabel(x_lbl);
ylabel('Fluorescence Intensity (a.u.)');
str_legend = {};
clr_map = jet(length(spd_data.list_aligned));
for i = 1:length(spd_data.list_aligned);
    idx = spindle_find_ID(spd_data, spd_data.list_aligned(i));
    if flag;
        
        % selec = 1 for FITC
        if selec;
            plot(spd_data.data{idx}.x_norm, ...
                spd_data.data{idx}.data_FITC, ...
                'color', clr_map(i,:));
        else
            plot(spd_data.data{idx}.x_norm, ...
                spd_data.data{idx}.data_TexRd, ...
                'color', clr_map(i,:));
        end;
    else
        if selec;
            plot(linspace(0,1, length(spd_data.data{idx}.data_FITC)), ...
                spd_data.data{idx}.data_FITC, ...
                'color', clr_map(i,:));
        else
            plot(linspace(0,1, length(spd_data.data{idx}.data_FITC)), ...
                spd_data.data{idx}.data_TexRd, ...
                'color', clr_map(i,:));
        end;
    end;
    str_legend{length(str_legend) + 1} = num2str(spd_data.list_aligned(i));
end;
legend(str_legend,'Location','EastOutside');

if flag;
    plot([spd_data.parameters.PEAK_POS_LEFT, spd_data.parameters.PEAK_POS_LEFT], [0, 2000], 'k:');
    plot([spd_data.parameters.PEAK_POS_RIGHT, spd_data.parameters.PEAK_POS_RIGHT], [0, 2000], 'k:');
end;