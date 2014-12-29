function spindle_mat_summary(spd_data_sub)

figure();
set_print_page(gcf, 0);

subplot(3,2,1:2:5);
im_output = cat(3, imadjust(spd_data_sub.img_raw(:,:,1)),imadjust(spd_data_sub.img_raw(:,:,2)), imadjust(spd_data_sub.img_raw(:,:,3)));
im_output = im2double(im_output);
im_output = imrotate(imrotate(im_output, spd_data_sub.rotation_angle, 'crop'),-90);
imshow(im_output); hold on;
box_coord = num2cell(spd_data_sub.box_coord);
[y1, y2, x1, x2, x0] = deal(box_coord{:});
plot([0, size(im_output,2)], [x1,x1],'w');
plot([0, size(im_output,2)], [x2,x2],'w');
plot([0, size(im_output,2)], [x0,x0],'w');
plot([0, size(im_output,2)], [x0-spd_data_sub.CEN_LINE_OFFSET,x0-spd_data_sub.CEN_LINE_OFFSET],'w:');
plot([0, size(im_output,2)], [x0+spd_data_sub.CEN_LINE_OFFSET,x0+spd_data_sub.CEN_LINE_OFFSET],'w:');
plot([size(im_output,2)-y1,size(im_output,2)-y1], [0, size(im_output,1)],'w');
plot([size(im_output,2)-y2,size(im_output,2)-y2], [0, size(im_output,1)],'w');
y_N = size(im_output,2)-y1-(y2-y1)*spd_data_sub.POLE_PORTION;
y_S = size(im_output,2)-y2+(y2-y1)*spd_data_sub.POLE_PORTION;
plot([y_N, y_N], [0, size(im_output,1)],'w:');
plot([y_S, y_S], [0, size(im_output,1)],'w:');
title(spd_data_sub.raw_file,'fontweight','bold','fontsize',16,'interpreter','none');
legend_str = ['TIFF size:', num2str(size(im_output,1)), ' x ', num2str(size(im_output,2)), ...
    ';crop size:', num2str(x2-x1+1), ' x ', num2str(y2-y1+1), char(10), ...
    'y1=',num2str(y1),'; y2=',num2str(y2),'; POLE\_PORTION=1/',num2str(1/spd_data_sub.POLE_PORTION),char(10),...
    'x1=',num2str(x1),'; x2=',num2str(x2), char(10), ...
    'x0=',num2str(x0), '; CEN\_LINE\_OFFSET=', num2str(spd_data_sub.CEN_LINE_OFFSET), char(10), ...
    '{\color{red}TexRd} {\color{green}FITC} {\color{blue}DAPI}'];
h = legend(legend_str,'Location','SouthOutside');
set(h, 'fontweight','bold');

subplot(3,2,2);
plot(spd_data_sub.data_box(:,[3:-1:1])); hold on; 
title('Traces (Box Average)','fontsize',14,'fontweight','bold'); 
legend(spd_data_sub.data_label(3:-1:1));
axis([0 size(spd_data_sub.data_box,1) 0 max(spd_data_sub.data_box(:,1))])
xlabel('Inter-pole Distance (north -> south)');
ylabel('Fluo Intensity (a.u.)');

subplot(3,2,4);
plot(spd_data_sub.data_line(:,[3:-1:1])); hold on; 
title('Traces (Line Scan)','fontsize',14,'fontweight','bold'); 
legend(spd_data_sub.data_label(3:-1:1));
axis([0 size(spd_data_sub.data_line,1) 0 max(spd_data_sub.data_line(:,1))])
xlabel('Inter-pole Distance (north -> south)');
ylabel('Fluo Intensity (a.u.)');

subplot(3,2,6);
x = linspace(0, 1, size(spd_data_sub.data_line,1));
hold on; plot(x, spd_data_sub.data_line(:,2) ./ spd_data_sub.data_line(:,1),'c','linewidth',2)
hold on; plot(x, spd_data_sub.data_box(:,2) ./ spd_data_sub.data_box(:,1),'k','linewidth',2)
title('FITC/TexRd Ratio','fontsize',14,'fontweight','bold'); 
legend('LINE-ratio','BOX-ratio','Location','Best');
xlabel('Inter-Pole Percentage (north -> south)');
ylabel('FITC/TexRd Ratio');
axis([0 1 0 1.5]);
plot([spd_data_sub.POLE_PORTION,spd_data_sub.POLE_PORTION],[0 1.5],'m');
plot([1-spd_data_sub.POLE_PORTION,1-spd_data_sub.POLE_PORTION],[0 1.5],'m');

dir_name = spd_data_sub.raw_file(1: strfind(spd_data_sub.raw_file, '/')-1);
dir_name = [dir_name, '_analysis/summary'];
file_name = spd_data_sub.raw_file(1 : end-1);
print_save_figure(gcf, file_name, dir_name);

