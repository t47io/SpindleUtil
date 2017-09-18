function TIFF_list = tiff_read_folder(dir_name)
  if ~exist(dir_name, 'dir');
    fprintf(2, 'ERROR: directory not found.\n');
    return;
  end;

  TIFF_list_all = dir([dir_name, '/*.TIF']);
  TIFF_list = {};
  for i = 1:length(TIFF_list_all);
    TIFF_file_name = strrep( ...
      strrep( ...
        strrep( ...
          strrep(TIFF_list_all(i).name, '_w1DAPI', ''), ...
          '_w2Texas Red', ''), ...
        '_w3FITC', ''), ...
      '.TIF', '');

    if ~ismember(TIFF_file_name, TIFF_list);
      TIFF_list = [TIFF_list, TIFF_file_name];
    end;
  end;

  fprintf('%d groups ( * 3  = %d TIF files ) to load from directory: %s\n', length(TIFF_list), length(TIFF_list) * 3, dir_name);
