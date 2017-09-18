function [img_TexRd, img_FITC, img_DAPI] = tiff_read_group(file_prefix)
  img_DAPI = imread([file_prefix, '_w1DAPI.TIF']);
  img_TexRd = imread([file_prefix, '_w2Texas Red.TIF']);
  img_FITC = imread([file_prefix, '_w3FITC.TIF']);
