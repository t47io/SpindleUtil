function spd_data = spindle_read_folder(dir_name, CEN_LINE_OFFSET, POLE_PORTION)

if ~exist('CEN_LINE_OFFSET','var') || isempty(CEN_LINE_OFFSET);
    CEN_LINE_OFFSET = 5;
end;
if ~exist('POLE_PORTION','var') || isempty(POLE_PORTION);
    POLE_PORTION = 1/10;
end;
if ~exist(dir_name, 'dir');
    fprintf(2, 'ERROR: directory not found.\n');
    return;
end;

TIFF_list_all = dir([dir_name, '/*.TIF']);
TIFF_list = {};
for i = 1:length(TIFF_list_all);
    if isempty(strfind(TIFF_list_all(i).name, 'thumb'));
        TIFF_list = [TIFF_list, TIFF_list_all(i).name];
    end;
end;
fprintf('Load files from directory: %s\n', dir_name);

if mod(length(TIFF_list), 3);
    fprintf(2, 'ERROR: TIFF images sets (of 3) incomplete.\n');
    fprintf(2, '       %d non-thumb TIF files present.\n', length(TIFF_list));
    return;
end;
fprintf('Load %d non-thumb TIF images from directory.\n', length(TIFF_list));
fprintf('Group into %d spindles {DAPI, FITC, TexRd}.\n\n', length(TIFF_list)/3);


fprintf(2,'<strong>Instructions</strong>:\n');
fprintf(['First rotate image to where poles are aligned vertically (north-south),\n'...
    'then draw box to encompass full spindle \n\t(two horizontal, two vertical, one vertical center line).\n']);
fprintf(2,'<strong>Controls</strong>:\n');
fprintf(['Keys: <strong>up/left</strong>: counterclockwise 1', char(176), '/5', char(176),...
    '; <strong>down/right</strong>: clockwise 1', char(176), '/5', char(176),...
    ';\n      <strong>r</strong>: reset; <strong>p</strong>: pass; <strong>q</strong>: save & next',...
    ';\n      <strong>x</strong>: abort (premature terminate, data lost).\n', ...
    'Lines: <strong>1/2</strong>: horizontal (top / bottom boundary)', ...
    ';\n       <strong>3/4</strong>: vertical (left / right boundary)',...
    ';\n       <strong>5</strong>: vertical (linescan center).\n',...
    'Display: <strong>1/2, 3/4, 5/6</strong> adjust R, G, B intensity', ...
    ';\n         <strong>t</strong> reset display only.\n\n']);


spd_data = cell(1, length(TIFF_list)/3);
for i = 1:length(TIFF_list);
    file_id = TIFF_list{i}(1:(length(dir_name) + 5));
    if ~strcmp(file_id(1:length(dir_name)), dir_name);
        fprintf(2, 'ERROR: TIF and directory name mismatch:\n');
        fprintf(2, '       %s/%s\n', dir_name, TIFF_list{i});
        return;
    end;
end;
for i = 1:3:length(TIFF_list);
    file_id = TIFF_list{i}(1:(length(dir_name) + 5));
    fprintf('[<strong>%d</strong> of %d] Processing: %s *3.TIF, ...', (i-1)/3+1, length(TIFF_list)/3, file_id);
    spd_data{(i-1)/3+1} = spindle_box_select([dir_name, '/', file_id], CEN_LINE_OFFSET, POLE_PORTION);
    close all;
    
    if spd_data{(i-1)/3+1}.is_bad;
        fprintf(' Considered ');
        fprintf(2, 'BAD ');
        fprintf(', ignored!\n');
    else
        fprintf(' Done!\n');
    end;
end;
fprintf('All done.\n');
