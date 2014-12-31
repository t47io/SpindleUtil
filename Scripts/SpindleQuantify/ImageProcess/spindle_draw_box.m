function [y1, y2, x1, x2, x0, rot_angle, is_pass] = spindle_draw_box(im_input, rot_angle, file_id, CEN_LINE_OFFSET, POLE_PORTION)

if ~exist('CEN_LINE_OFFSET','var') || isempty(CEN_LINE_OFFSET);
    CEN_LINE_OFFSET = 5;
end;
if ~exist('POLE_PORTION','var') || isempty(POLE_PORTION);
    POLE_PORTION = 1/24;
end;

is_finish = 0;
is_pass = false;
[x1, x2, y1, y2, x0] = deal(0, 0, 0, 0, 0);
is_status = 0;
update_display = 1;
update_plot = 0;
im_display = im_input;
COLOR_ADJUST = 1.25;

figure(); set_print_page(gcf, 0);
if exist('file_id','var') && ~isempty(file_id);
    set(gcf, 'name', file_id);
end;
set(gcf, 'closerequestfcn', '');
set(gcf, 'pointer','fullcross');
screen_size = get(0,'ScreenSize');
set(gcf, 'position', [(screen_size(3)-800)/2 screen_size(4)-600 800 600]);

while ~is_finish
    if update_display;
        h = show_img(im_display, rot_angle);
    end;
    if update_plot;
        ylim = get(gca,'YLim');
        if x1;
            plot([x1, x1], get(gca,'YLim'), 'c', 'linewidth', 2);
            text(x1-50, ylim(2)-20, ['X1 = ', num2str(x1)], 'color', 'w');
        end;
        if x2;
            plot([x2, x2], get(gca,'YLim'), 'c', 'linewidth', 2);
            text(x2+10, ylim(2)-20, ['X2 = ', num2str(x2)], 'color', 'w');
        end;
        if x0;
            plot([x0, x0], get(gca,'YLim'), 'y', 'linewidth', 2);
            text(x0+10, ylim(2)-20, ['X0 = ', num2str(x0)], 'color', 'w');

            plot([x0-CEN_LINE_OFFSET, x0-CEN_LINE_OFFSET], get(gca,'YLim'), 'w:');
            plot([x0+CEN_LINE_OFFSET, x0+CEN_LINE_OFFSET], get(gca,'YLim'), 'w:');
        end;
        if y1;
            plot(get(gca,'XLim'), [y1, y1], 'm', 'linewidth', 2);
            text(20, y1-10, ['Y1 = ', num2str(y1)], 'color', 'w');
        end;
        if y2;
            plot(get(gca,'XLim'), [y2, y2], 'm', 'linewidth', 2);
            text(20, y2+10, ['Y2 = ', num2str(y2)], 'color', 'w');
            
            y_pole_N = (y2 - y1) * POLE_PORTION + y1;
            y_pole_S = y2 - (y2 - y1) * POLE_PORTION;
            plot(get(gca,'XLim'), [y_pole_N, y_pole_N], 'm:');
            plot(get(gca,'XLim'), [y_pole_S, y_pole_S], 'm:');
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
        switch double(keychar)
            case {81, 113} %q/Q
                is_finish = 1;
                set(gcf, 'closerequestfcn', 'closereq');
                set(h, 'String', 'Done!','fontsize',16,'fontweight','bold','color','m');
                set(gcf, 'pointer','arrow');
            case 28
                rot_angle = rot_angle + 5;
                update_display = 1;
            case 29
                rot_angle = rot_angle - 5;
                update_display = 1;
            case 30
                rot_angle = rot_angle + 1;
                update_display = 1;
            case 31
                rot_angle = rot_angle - 1;
                update_display = 1;
            case {82, 114} %r/R
                rot_angle = 0;
                [x1, x2, y1, y2, x0] = deal(0, 0, 0, 0, 0);
                is_status = 0;
                update_plot = 0;
                update_display = 1;
            case {80, 112} %p/P
                rot_angle = 0;
                [x1, x2, y1, y2, x0] = deal(0, 0, 0, 0, 0);
                is_pass = true;
                is_finish = 1;
                set(gcf, 'closerequestfcn', 'closereq');
                set(h, 'String', 'Ignored!','fontsize',16,'fontweight','bold','color','m');
                set(gcf, 'pointer','arrow');
            case {88, 120} %x/X
                spindle_window_clear();
                fprintf('\n');
                error('Aborted: user chose to terminate. Data not saved.');
            case 49
                im_display(:, :, 1) = im_display(:, :, 1) / COLOR_ADJUST;
                update_display = 1;
            case 50
                im_display(:, :, 1) = im_display(:, :, 1) * COLOR_ADJUST;
                update_display = 1;
            case 51
                im_display(:, :, 2) = im_display(:, :, 2) / COLOR_ADJUST;
                update_display = 1;
            case 52 
                im_display(:, :, 2) = im_display(:, :, 2) * COLOR_ADJUST;
                update_display = 1;
            case 53
                im_display(:, :, 3) = im_display(:, :, 3) / COLOR_ADJUST;
                update_display = 1;
            case 54
                im_display(:, :, 3) = im_display(:, :, 3) * COLOR_ADJUST;
                update_display = 1;
            case {84, 116} %t/T
                im_display = im_input;
                update_display = 1;
            otherwise
                update_display = 0;
                update_plot = 0;
        end;
    end;
end;


function h = show_img(im_input, rot_angle)

clf;
imshow(imrotate(im_input, rot_angle, 'crop'));
hold on; axis image;
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
text(10, 20, ['First rotate image to where poles are aligned vertically (north-south).',char(10),...
    'then draw box to encompass full spindle (two horizontal, two vertical, one vertical center line).'],...
    'fontsize',14,'fontweight','bold','color','w');
h = text(0, ylim(2)+20, ['{\fontsize{14}{\bf{Keys: }}',...
    '{\color{blue}\bf{up/left}}: counterclockwise 1', char(176), '/5', char(176),...
    '; {\color{red}\bf{down/right}}: clockwise 1', char(176), '/5', char(176),...
    '; {\color{orange}\bf{r}}: reset; {\color[rgb]{0.5,0,0}\bf{p}}: pass',...
    '; {\color[rgb]{0,0.8,0}\bf{q}}: save & next; {\color[rgb]{0.5,0,0.5}\bf{x}}: abort. }', char(10), ...
    '{\fontsize{14}{\bf{Lines: }}',...
    '{\color{magenta}\bf{1/2}}: horizontal (top / bottom boundary)', ...
    '; {\color{cyan}\bf{3/4}}: vertical (left / right boundary)',...
    '; {\color[rgb]{0,0.5,0.5}\bf{5}}: vertical (linescan center).}']);
text(10, ylim(2)-20, ['{\color{cyan}Rotation:', '\bf{',num2str(rot_angle),char(176),'}}'],'fontsize',14);
text(xlim(2)-100, ylim(2)-50, ['{\color{white}Adjust Channel',char(10), 'Display: -/+',char(10), ...
    '{\color{red}{\bf{1}}/{\bf{2}}}, {\color{green}{\bf{3}}/{\bf{4}}}, {\color{blue}{\bf{5}}/{\bf{6}}};',char(10),...
    '{\color{yellow}{\bf{t}}}: reset color.}'],'fontsize',14);

