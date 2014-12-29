function rot_angle = spindle_rotate(im_input)

is_finish = 0;
rot_angle = 0;
update_display = 1;

figure(); set_print_page(gcf, 0);
set(gcf, 'closerequestfcn', '');
while ~is_finish
    if update_display;
        clf;
        imshow(imrotate(im_input, rot_angle, 'crop'));
        hold on;
        ylim = get(gca,'YLim');
        xlim = get(gca,'XLim');
        title('{\bf{Step 1}}: Rotate image to where poles are aligned vertically (north-south).','fontsize',16);
        h = text(xlim(1), ylim(2)+20, ['{\fontsize{16}{\bf{ Keys: }}',...
            '{\color{blue}\bf{up}}/{\color{red}\bf{down}}: counterclockwise / clockwise 1', char(176), ...
            ';   {\color{blue}\bf{left}}/{\color{red}\bf{right}}: counterclockwise / clockwise 5', char(176), '; ', char(10), ...
            '              {\color{orange}\bf{r}}: reset',...
            ';  {\color{green}\bf{q}}: save & quit}']);
        text(10,20, ['Rotation:', char(10), '\it{',num2str(rot_angle),'}'],'fontsize',16,'fontweight','bold','color','w');
    end;
    
    waitforbuttonpress;
    keychar = get(gcf,'CurrentCharacter');
    if double( keychar ) == 28; keychar = 'w'; end; % left arrow
    if double( keychar ) == 29; keychar = 's'; end; % right arrow
    if double( keychar ) == 30; keychar = 'a'; end; % up arrow
    if double( keychar ) == 31; keychar = 'd'; end; % down arrow
    
    switch keychar
        case {'q','Q'}
            set(gcf, 'closerequestfcn', 'closereq');
            is_finish = 1;
            set(h, 'String', 'Done!','fontsize',16,'fontweight','bold','color','m');
        case {'w','W'}
            rot_angle = rot_angle + 5;
            update_display = 1;
        case {'s','S'}
            rot_angle = rot_angle - 5;
            update_display = 1;
        case {'a','A'}
            rot_angle = rot_angle + 1;
            update_display = 1;
        case {'d','D'}
            rot_angle = rot_angle - 1;
            update_display = 1;
        case {'r', 'R'}
            rot_angle = 0;
            update_display = 1;
        otherwise
            update_display = 0;
    end;
end;
