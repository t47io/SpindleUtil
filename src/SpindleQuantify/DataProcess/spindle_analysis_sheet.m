function spd_data = spindle_analysis_sheet(file_name, sheet_name)

spd_data = spindle_load_XLS(file_name, sheet_name);
close all;
spd_data = spindle_match(spd_data);
close all;
spindle_plot(spd_data);
close all;
spd_data = spindle_trim(spd_data);
close all;

% save to variable in workspace
assignin('base', ['dat_', strrep(strrep(sheet_name, '+', '_'),'-','_')], spd_data);

