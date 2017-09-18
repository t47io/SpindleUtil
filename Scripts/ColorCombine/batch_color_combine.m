function batch_color_combine(dir_name, range_lists)

  TIFF_list = tiff_read_folder(dir_name);
  for i = 1:length(TIFF_list);
      fprintf('Processing file group %s\n', TIFF_list{i})
      [R, G, B] = tiff_read_group(TIFF_list{i});

      for j = 1:size(range_lists, 1);
        batch_range_list(R, G, B, range_lists(j, :), TIFF_list{i});
      end;
  end;
