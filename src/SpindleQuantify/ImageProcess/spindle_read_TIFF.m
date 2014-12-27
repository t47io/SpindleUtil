function im_input = spindle_read_TIFF(file_id)

im_DAPI = imread('3. M+F2MCAK_001_w1DAPI.TIF');
im_FITC = imread('3. M+F2MCAK_001_w2FITC.TIF');
im_TexRd = imread('3. M+F2MCAK_001_w3Texas Red.TIF');
im_input = cat(3, im_TexRd, im_FITC, im_DAPI);
