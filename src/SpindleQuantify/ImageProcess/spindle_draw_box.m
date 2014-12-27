function [y1, y2, x1, x2, x0] = spindle_draw_box(im_input, rot_angle)

is_finish = 0;
[x1, x2, y1, y2, x0] = deal(0, 0, 0, 0, 0);
is_status = 0;
update_display = 1;
update_plot = 0;

figure(); set_print_page(gcf, 0);
set(gcf, 'closerequestfcn', '');
set(gcf, 'pointer','fullcross');

while ~is_finish
    if update_display;
        h = show_img(im_input, rot_angle);
    end;
    if update_plot;
        if x1;
            plot([x1, x1], get(gca,'YLim'), 'c', 'linewidth', 2);
            text(x1+10, 20, ['X1 = ', num2str(x1)], 'color', 'w');
        end;
        if x2;
            plot([x2, x2], get(gca,'YLim'), 'c', 'linewidth', 2);
            text(x2+10, 20, ['X2 = ', num2str(x2)], 'color', 'w');
        end;
        if x0;
            plot([x0, x0], get(gca,'YLim'), 'y', 'linewidth', 2);
            text(x0+10, 20, ['X0 = ', num2str(x0)], 'color', 'w');
        end;
        if y1;
            plot(get(gca,'XLim'), [y1, y1], 'm', 'linewidth', 2);
            text(20, y1+10, ['Y1 = ', num2str(y1)], 'color', 'w');
        end;
        if y2;
            plot(get(gca,'XLim'), [y2, y2], 'm', 'linewidth', 2);
            text(20, y2+10, ['Y2 = ', num2str(y2)], 'color', 'w');
        end;
    end;
    
    keydown = waitforbuttonpress;
    if ( ~keydown ) % mousebutton pressed!
        
        mouse_pos = get( gca, 'CurrentPoint' );
        switch is_status
            case 0
                is_status = 1;
                y1 = mouse_pos(1,2);
            case 1
                is_status = 2;
                y2 = mouse_pos(1,2);
            case 2
                is_status = 3;
                x1 = mouse_pos(1,1);
            case 3
                is_status = 4;
                x2 = mouse_pos(1,1);
            case 4
                is_status = 5;
                x0 = mouse_pos(1,1);
        end;
        
        update_display = 0;
        update_plot = 1;
    else
        keychar = get(gcf,'CurrentCharacter');
        switch keychar
            case {'q','Q'}
                set(gcf, 'closerequestfcn', 'closereq');
                is_finish = 1;
                set(h, 'String', 'Done!','fontsize',16,'fontweight','bold','color','m');
                set(gcf, 'pointer','arrow');
            case {'r', 'R'}
                update_display = 1;
                update_plot = 0;
                [x1, x2, y1, y2, x0] = deal(0, 0, 0, 0, 0);
                is_status = 0;
        end;
    end;
end;


function h = show_img(im_input, rot_angle)

clf;
imshow(imrotate(im_input, rot_angle, 'crop'));
hold on; axis image;
ylim = get(gca,'YLim');
xlim = get(gca,'XLim');
title('{\bf{Step 2}}: Draw box to encompass full spindle ().','fontsize',16);
h = text(xlim(1), ylim(2)+20, ['{\fontsize{16}{\bf{ Lines: }}',...
    '{\color{magenta}\bf{1 / 2}}: horizontal (top / bottom boundary)', ...
    ';    {\color{cyan}\bf{3 / 4}}: vertical (left / right boundary) ;', char(10),...
    '              {\color{yellow}\bf{5}}: vertical (linescan center)', ...
    ';   {\color{orange}\bf{r}}: reset',...
    ';   {\color{green}\bf{q}}: save & quit}']);


