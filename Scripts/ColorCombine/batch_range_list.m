function batch_range_list(R, G, B, range_list, file_name)
  img_cc = tiff_adjust_combine(R, G, B, range_list);
  dir_name = strrep(num2str(range_list), '  ', '-');

  if ~exist(dir_name, 'dir');
    mkdir(dir_name);
  end;
  imwrite(img_cc, [dir_name, '/', file_name, '_cc.TIF']);
