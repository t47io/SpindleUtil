function spd_data = spindle_box_select(file_id, CEN_LINE_OFFSET, POLE_PORTION)

if ~exist('CEN_LINE_OFFSET','var') || isempty(CEN_LINE_OFFSET);
    CEN_LINE_OFFSET = 5;
end;
if ~exist('POLE_PORTION','var') || isempty(POLE_PORTION);
    POLE_PORTION = 1/10;
end;

im_input = spindle_read_TIFF(file_id);
im_display = cat(3, imadjust(im_input(:,:,1)),imadjust(im_input(:,:,2)), imadjust(im_input(:,:,3)));
spd_data = [];

[y1, y2, x1, x2, x0, rot_angle, is_pass] = spindle_draw_box(im_display, 0, file_id, CEN_LINE_OFFSET, POLE_PORTION);
close all;

while any([y1, y2, x1, x2, x0] == 0) && ~is_pass;
    fprintf(2, '\nERROR: box selection incomplete.\n');
    fprintf('       Please try again.\n');
    [y1, y2, x1, x2, x0, rot_angle, is_pass] = spindle_draw_box(im_display, rot_angle, file_id, CEN_LINE_OFFSET, POLE_PORTION);
    close all;
end;

spd_data.raw_file = file_id;
spd_data.rotation_angle = rot_angle;
spd_data.box_coord = [y1, y2, x1, x2, x0];
spd_data.img_raw = im_input;
spd_data.is_bad = is_pass;
spd_data.data_box = [];
spd_data.data_line = [];
spd_data.data_label = {'TexRd', 'FITC', 'DAPI'};
spd_data.img_box = [];
spd_data.CEN_LINE_OFFSET = CEN_LINE_OFFSET;
spd_data.POLE_PORTION = POLE_PORTION;

if ~is_pass;
    [data_box, data_line] = spindle_quantitate(im_input, rot_angle, [y1, y2, x1, x2, x0], CEN_LINE_OFFSET);
    
    spd_data.data_box = data_box;
    spd_data.data_line = data_line;
    
    im_output = imrotate(im_input, rot_angle, 'crop');
    im_output = im_output(round(y1):round(y2), round(x1):round(x2), :);
    spd_data.img_box = im_output;
end;
