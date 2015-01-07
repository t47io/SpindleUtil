function write_excel(ratio_poles, std_poles, ratio_body, std_body, labels, pole_ratios)


for i = 1:length(labels);
    labels{i} = strrep(labels{i}(strfind(labels{i}, '}}')+2:end), '\', '');
end;
group = labels';

obj_list_len = zeros(length(pole_ratios), 1);
obj_name = cell(length(pole_ratios), 1);
dir_name = cell(length(pole_ratios), 1);
for i = 1:length(pole_ratios);
    obj_list_len(i) = pole_ratios(i).obj_list;
    obj_name{i} = pole_ratios(i).obj;
    dir_name{i} = pole_ratios(i).mat;
end;

T = table(group, ratio_poles, std_poles, ratio_body, std_body, dir_name, obj_name, obj_list_len, ...
    'RowNames', strread(num2str(1:i'),'%s'));
writetable(T, 'ratio_compare.txt','WriteRowNames',true);

