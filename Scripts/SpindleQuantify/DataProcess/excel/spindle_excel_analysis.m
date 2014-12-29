function spindle_excel_analysis (file_name)

% get all sheets
[~, sheets] = xlsfinfo(file_name);

% start log of screen output
diary([file_name(1:strfind(file_name, '.')),'log']);
fprintf('File:  <strong>%s</strong>\n', file_name);
fprintf('Sheets:<strong>');
for i = 1:length(sheets);
    fprintf('%s    ', sheets{i});
end;
fprintf('</strong>\n');
fprintf('All sheets will be processed and plotted.\n');
fprintf(2, 'All current figures will be closed.\n');
fprintf('Figures will be saved to folders named with sheet name in current directory.\n');
fprintf('Data will be saved to variables named with sheet name in current workspace.\n');
fprintf('Workspace and screen output will be saved to current directory.\n');
fprintf(2,'Press any key to continue...\n');
pause;

% start timer
tic;
spd_all = {};
for i = 1:length(sheets);
    fprintf('\n');
    sheet_name = sheets{i};
    fprintf('Sheet <strong>%s</strong>:\n', sheet_name);
    spd_data = spindle_excel_analysis_sheet(file_name, sheet_name);
    spd_all{length(spd_all) + 1} = spd_data;
    fprintf('\n');
end;

% save base workspace
assignin('base', 'file_name', file_name);
evalin('base', 'save([file_name(1:strfind(file_name, ''.'')),''mat'']);');

% clean up log file
diary off;
log_cleanup([file_name(1:strfind(file_name, '.')),'log']);
toc;


% compare sheets
spindle_excel_plot_ratio_compare(spd_all);
close all;

