function img_RGB = tiff_adjust_combine(R, G, B, range_list)
  Rmin = range_list(1);
  Rmax = range_list(2);
  Gmin = range_list(3);
  Gmax = range_list(4);
  Bmin = range_list(5);
  Bmax = range_list(6);

  img_R = adjust_image(R, Rmin, Rmax);
  img_G = adjust_image(G, Gmin, Gmax);
  img_B = adjust_image(B, Bmin, Bmax);
  img_RGB = cat(3, img_R, img_G, img_B);


function img_scaled = adjust_image(img, imin, imax)
  % https://imagej.nih.gov/ij/developer/api/ij/process/ImageProcessor.html#setMinAndMax-double-double-
  % map [imin imax] space to [0 255] space

  % fprintf('imin imax: %d, %d\n', imin, imax);
  % fprintf('img min max: %d, %d\n', min(img(:)), max(img(:)));
  img_scaled = double(img);
  img_scaled(img_scaled < imin) = imin;
  img_scaled(img_scaled > imax) = imax;
  img_scaled = img_scaled - imin;
  % fprintf('offset min max: %d, %d\n', min(img_scaled(:)), max(img_scaled(:)));

  img_scaled = round(img_scaled * 255 / (imax - imin));
  img_scaled = uint8(img_scaled);
  % fprintf('output min max: %d, %d\n', min(img_scaled(:)), max(img_scaled(:)));
