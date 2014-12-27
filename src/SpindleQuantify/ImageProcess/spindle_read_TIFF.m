function im_input = spindle_read_TIFF(file_id, file_id2, file_id3)

if (exist('file_id2','var') && exist('file_id3','var') && ~isempty(file_id2) && ~isempty(file_id3));
    im_DAPI = imread(file_id);
    im_FITC = imread(file_id2);
    im_TexRd = imread(file_id3);
else
    im_DAPI = imread([file_id, 'w1DAPI.TIF']);
    im_FITC = imread([file_id, 'w2FITC.TIF']);
    im_TexRd = imread([file_id, 'w3Texas Red.TIF']);
end;

im_input = cat(3, im_TexRd, im_FITC, im_DAPI);
