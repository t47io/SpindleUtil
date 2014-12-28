function spd_data = spindle_excel_analysis_sheet(file_name, sheet_name)

spd_data = spindle_excel_load(file_name, sheet_name);
close all;
spd_data = spindle_excel_match(spd_data);
close all;
spindle_excel_plot(spd_data);
close all;
spd_data = spindle_excel_trim(spd_data);
close all;

% save to variable in workspace
assignin('base', ['dat_', strrep(strrep(sheet_name, '+', '_'),'-','_')], spd_data);

