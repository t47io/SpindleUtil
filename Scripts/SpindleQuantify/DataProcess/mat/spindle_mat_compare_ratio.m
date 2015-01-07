function [ratio_poles, std_poles, ratio_body, std_body] = spindle_mat_compare_ratio(dir_name, POLE_PORTION, y_lim)

if ~exist('POLE_PORTION','var') || isempty(POLE_PORTION); POLE_PORTION = 1/10; end;
if ~exist('y_lim','var') || isempty(y_lim); y_lim = 2.0; end;

if isempty(dir_name);
    D = dir('*_analysis');
    dir_name = {};
    for i = 1:length(D);
        if D(i).isdir;
            dir_name = [dir_name, D(i).name(1:end-9)];
        end;
    end;
    fprintf('Autodetected %d folders.\n', length(dir_name));
    dir_name
end;

spd_data_cell = cell(1, length(dir_name));
pole_ratios = [];
for i = 1:length(dir_name);
    
    if ~exist([dir_name{i},'_analysis/save.mat'],'file');
        fprintf(2, 'ERROR: No save.mat found in %s.\n', dir_name{i});
    end;
    obj_all = who('-file',[dir_name{i},'_analysis/save.mat'],'obj*');
    if isempty(obj_all);
        fprintf(2, 'ERROR: No obj_ found in %s.\n', [dir_name{i},'_analysis/save.mat']);
    end;
    
    spd_data_cell{i} = load([dir_name{i},'_analysis/save.mat']);
    for j = 1:length(obj_all);
        idx = length(pole_ratios) + 1;
        pole_ratios(idx).ratios = spindle_mat_divide_pole(spd_data_cell{i}.spd_data, spd_data_cell{i}.(obj_all{j}).list_chosen, POLE_PORTION);
        pole_ratios(idx).label = ['{\bf{', num2str(idx), ' = }}', dir_name{i}, '\', obj_all{j}(4:end)];
        pole_ratios(idx).index = i;
        pole_ratios(idx).obj = obj_all{j};
        pole_ratios(idx).mat = dir_name{i};
        pole_ratios(idx).obj_list = length(spd_data_cell{i}.(obj_all{j}).list_chosen);
        
        print_save_figure(gcf, ['pole_ratio_', dir_name{i}, obj_all{j}(4:end)],'./');
        close all;
    end;
end;
fprintf('Processed %d obj_s.\n', length(pole_ratios));

clr_map = jet(length(pole_ratios));
all_poles = [];
group_poles = [];
all_body = [];
group_body = [];
ratio_poles = zeros(1, length(pole_ratios));
std_poles = zeros(1, length(pole_ratios));
ratio_body = zeros(1, length(pole_ratios));
std_body = zeros(1, length(pole_ratios));
labels = {};
for i = 1:length(pole_ratios);
    all_poles = [all_poles, pole_ratios(i).ratios(:,2)', pole_ratios(i).ratios(:,4)'];
    group_poles = [group_poles, repmat(i, 1, size(pole_ratios(i).ratios, 1)*2)];
    all_body = [all_body, pole_ratios(i).ratios(:,3)'];
    group_body = [group_body, repmat(i, 1, size(pole_ratios(i).ratios, 1))];
    ratio_poles(i) = mean([pole_ratios(i).ratios(:,2)', pole_ratios(i).ratios(:,4)']);
    std_poles(i) = std([pole_ratios(i).ratios(:,2)', pole_ratios(i).ratios(:,4)'], 0, 2);
    ratio_body(i) = mean([pole_ratios(i).ratios(:,3)']);
    std_body(i) = std([pole_ratios(i).ratios(:,3)'], 0, 2);
    labels = [labels, pole_ratios(i).label];
end;

figure(); set_print_page(gcf, 1);
subplot(3,2,1:2); hold on;
for i = 1:length(pole_ratios);
    plot(linspace(0,1,100), spd_data_cell{pole_ratios(i).index}.(pole_ratios(i).obj).ratio_box_mean, 'color', clr_map(i, :));
end;
plot([POLE_PORTION, POLE_PORTION],[0 y_lim],'k-');
plot([1 - POLE_PORTION, 1 - POLE_PORTION],[0 y_lim],'k-');
legend(labels, 'Location','EastOutside');
xlabel('Inter-Pole Percentage (north -> south)');
ylabel('FITC/TexRd Ratio');
title('FITC/TexRd Ratio Comparison','fontsize',16,'fontweight','bold');
axis([0 1 0 y_lim]);

subplot(3,2,3); hold on;
h = boxplot(all_poles, group_poles, 'colors', 'k');
h = findobj(h,'Tag','Box');
for j = 1:length(h);
    patch(get(h(j),'XData'),get(h(j),'YData'), clr_map(length(pole_ratios)+1-j, :),'facealpha',0.5);
end;
ylabel('FITC/TexRd Ratio');
title('Pole Ratios','fontsize',16,'fontweight','bold');
axis([0.5 length(pole_ratios)+0.5 0 y_lim]);

subplot(3,2,4); hold on;
h = boxplot(all_body, group_body, 'colors', 'k');
h = findobj(h,'Tag','Box');
for j = 1:length(h);
    patch(get(h(j),'XData'),get(h(j),'YData'), clr_map(length(pole_ratios)+1-j, :),'facealpha',0.5);
end;
ylabel('FITC/TexRd Ratio');
title('Body Ratios','fontsize',16,'fontweight','bold');
axis([0.5 length(pole_ratios)+0.5 0 y_lim]);

subplot(3,2,5:6); hold on;
for i = 1:length(pole_ratios);
    bar([i-0.2, i+0.2], [ratio_poles(i); ratio_body(i)]','facecolor', clr_map(i,:));
end;
% bar([ratio_poles; ratio_body]');
ylabel('FITC/TexRd Ratio');
% set(gca, 'xtick',1:length(pole_ratios), 'xticklabel', labels);
% xticklabel_rotate;
title(['Pole/Body Ratios', '   {\color{green}POLE\_PORTION = 1/', num2str(1/POLE_PORTION),'}'],'fontsize',16,'fontweight','bold');
axis([0.5 length(pole_ratios)+0.5 0 y_lim]);

print_save_figure(gcf, 'ratio_compare', './');
write_excel(ratio_poles', std_poles', ratio_body', std_body', labels, pole_ratios);
