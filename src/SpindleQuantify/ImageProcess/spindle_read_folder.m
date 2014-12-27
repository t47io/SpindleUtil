function spd_data = spindle_read_folder(dir_name)

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

if mod(length(TIFF_list), 3);
    fprintf(2, 'ERROR: TIFF images sets (of 3) incomplete.\n');
    fprintf(2, '       %d non-thumb TIF files present.\n', length(TIFF_list));
    return;
end;

spd_data = cell(1, length(TIFF_list)/3);
for i = 1:3:length(TIFF_list);
    file_id = TIFF_list{i}(1:(length(dir_name) + 5));
    if ~strcmp(file_id(1:length(dir_name)), dir_name);
        fprintf(2, 'ERROR: TIF and directory name mismatch:\n');
        fprintf(2, '       %s/%s\n', dir_name, TIFF_list{i});
        return;
    end;
    fprintf('[%d/%d] Processing: %s *3.TIF, ...', (i-1)/3+1, length(TIFF_list)/3, file_id);
    spd_data{(i-1)/3+1} = spindle_box_select([dir_name, '/', file_id]);
    close all;
    fprintf(' Done!\n');
end;
