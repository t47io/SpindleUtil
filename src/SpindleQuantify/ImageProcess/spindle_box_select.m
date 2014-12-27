function spd_data = spindle_box_select(file_id)

im_input = spindle_read_TIFF(file_id);
im_display = cat(3, imadjust(im_input(:,:,1)),imadjust(im_input(:,:,2)), imadjust(im_input(:,:,3)));
spd_data = [];

rot_angle = spindle_rotate(im_display);
close all;

[y1, y2, x1, x2, x0] = spindle_draw_box(im_display, rot_angle);
close all;
[data_box, data_line] = spindle_quantitate(im_input, rot_angle, [y1, y2, x1, x2, x0]);

spd_data.raw_file = file_id;
spd_data.rotation_angle = rot_angle;
spd_data.box_coord = [y1, y2, x1, x2, x0];
spd_data.data_box = data_box;
spd_data.data_line = data_line;
spd_data.data_label = {'TexRd', 'FITC', 'DAPI'};

im_output = imrotate(im_input, rot_angle, 'crop');
im_output = im_output(round(y1):round(y2), round(x1):round(x2), :);
spd_data.data_raw = im_output;


% figure(1); plot(spd_data.data_box(:,[3:-1:1])); 
% hold on; plot(spd_data.data_box(:,2) ./ spd_data.data_box(:,1) * 1000,'k')
% title('box');axis([0 size(spd_data.data_box,1) 0 max(spd_data.data_box(:,3))])
% legend('MCAK','MT','DNA','ratio');
% 
% figure(2); plot(spd_data.data_line(:,[3:-1:1])); 
% hold on; plot(spd_data.data_line(:,2) ./ spd_data.data_line(:,1) * 1000,'k')
% title('box');axis([0 size(spd_data.data_line,1) 0 max(spd_data.data_line(:,3))])
% legend('MCAK','MT','DNA','ratio');

figure();
x = linspace(0, 1, size(spd_data.data_line,1));
hold on; plot(x, spd_data.data_line(:,2) ./ spd_data.data_line(:,1),'b')
hold on; plot(x, spd_data.data_box(:,2) ./ spd_data.data_box(:,1),'r')
legend('LINE-ratio','BOX-ratio');
axis([0 1 0 1.2]);
plot([1/25,1/25],[0 1],'k');
plot([24/25,24/25],[0 1],'k');



