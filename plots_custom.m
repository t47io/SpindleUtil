function [proj_stats] = plots_custom(proj)
% [proj_stats] = PLTOS_CUSTOM(projData)
%
% Plots speed vs. life time distribution, and tracks colored by speed or
% displacement. 5 figures will be saved as .eps files in Figures/.
%
% Input
% =====
% projData      projData struct in projData.mat
%
% Output
% ======
% proj_stats    statistics calcluated, includes following fields:
%   vel_all       speed of each track (rows) at each interval (column).
%   vel_means     averaged speed of each track.
%   dist_all      distance of each track (rows) at each interval (column).
%   dist_sum      total displacement of each track.
%   life_times    life time span (number of frames) of each track.
%
% e.g.
% plot_customs(projData);
%
% by T47, Nov 2014
%
if nargin == 0; help(mfilename); return; end;

xCrd = proj.xCoord;
yCrd = proj.yCoord;
dt = proj.secPerFrame;
ratio_dist = proj.pixSizeNm;
clr_accu = 50;

[vel_all, vel_means, vel_cutoff, dist_all, dist_sum, life_times, lf_tm_cutoff, n_tracks, n_frames] = calculate_stats(xCrd, yCrd, dt, ratio_dist);
fprintf('Loaded from projData: (x,y) coordinates of %d tracks in %d frames.\n', n_tracks, n_frames);
fprintf('Loaded from projData: %d seconds per frame and %d microns per pixel.\n', dt, ratio_dist);

quarter_tag = zeros(n_tracks, 1);

% FIGRUE scatter quarters
% plot all tracks, colored by its quarter affiliation
% quarters divided by mean speed and life time
figure(1); hold on; set_print_page(gcf,1);
for i = 1:n_tracks;
    if vel_means(i) < vel_cutoff && life_times(i) < lf_tm_cutoff;
        scatter(vel_means(i)*60, life_times(i)*2, [],'g');
        quarter_tag(i) = 1;
    elseif vel_means(i) < vel_cutoff && life_times(i) >= lf_tm_cutoff;
        scatter(vel_means(i)*60, life_times(i)*2, [],'r');
        quarter_tag(i) = 2;
    elseif vel_means(i) >= vel_cutoff && life_times(i) < lf_tm_cutoff;
        scatter(vel_means(i)*60, life_times(i)*2, [],'k');
        quarter_tag(i) = 3;
    elseif vel_means(i) >= vel_cutoff && life_times(i) >= lf_tm_cutoff;
        scatter(vel_means(i)*60, life_times(i)*2, [],'b');
        quarter_tag(i) = 4;
    end;
end;
xlabel('Growth Speed (um/min)');
ylabel('Lifetime (s)');
print_save_figure(gcf, 'scatter_vel_lftm');

% tag each track to its quarter affiliation (int 1-4)
quarter_subset = cell(1,4);
clr_map = {'g','r','k','b'};
for i = 1:4
    quarter_subset{i} = find(quarter_tag == i);
end;

% FIGURE traces plot
% plot tracks of each quarter, same color as above
figure(2); x = [3 1 4 2]; set_print_page(gcf,1);
for i = 1:4
	subplot(2,2,x(i)); hold on;
    for j = 1:length(quarter_subset{i})
        plot(xCrd(quarter_subset{i}(j),:), yCrd(quarter_subset{i}(j),:), clr_map{i});
    end;
    axis square; xlabel('x coordinate'); ylabel('y coordinate');
    set(gca, 'Ydir', 'reverse');
end;
print_save_figure(gcf, 'scatter_vel_lftm_quarters');

% FIGURE traces plot
% plot all tracks, colored by its quarter
figure(3); hold on; set_print_page(gcf,1);
for i = 1:4
    for j = 1:length(quarter_subset{i})
        plot(xCrd(quarter_subset{i}(j),:), yCrd(quarter_subset{i}(j),:), clr_map{i});
    end;
end;
axis square; xlabel('x coordinate'); ylabel('y coordinate'); set(gca, 'Ydir', 'reverse');
title('Tracks classified by mean speed and life time','fontsize',15,'fontweight','bold');
print_save_figure(gcf, 'track_color_quarter');

% get color map range for 50 bins
clr_map = jet(clr_accu);
cmin = min(vel_all(:)); cmax = max(vel_all(:));
% get bin width by speed
cstep = (cmax - cmin) / (clr_accu - 1);

% FIGURE traces plot
% colored tracks by their speed at each interval
figure(4); hold on; set_print_page(gcf,1);
for i = 1:n_tracks;
    for j = 1:n_frames - 1;
        if ~isnan(vel_all(i,j));
            c_temp = round((vel_all(i,j) - cmin) / cstep + 1);
            plot(xCrd(i,j:j+1), yCrd(i,j:j+1), 'color', clr_map(c_temp,:));
        end;
    end;
end;
axis square; xlabel('x coordinate'); ylabel('y coordinate'); set(gca, 'Ydir', 'reverse');
colorbar; title('Tracks colored by interval speeds','fontsize',15,'fontweight','bold');
print_save_figure(gcf, 'track_color_speed');

% get bin width by displacement
cmin = min(dist_sum(:)); cmax = max(dist_sum(:));
cstep = (cmax - cmin) / (clr_accu - 1);

% FIGURE traces plot
% colored tracks by their total displacement
figure(5); hold on; set_print_page(gcf,1);
for i = 1:n_tracks;
    c_temp = round((dist_sum(i) - cmin) / cstep + 1);
    plot(xCrd(i,:), yCrd(i,:), 'color', clr_map(c_temp,:));
end;
axis square; xlabel('x coordinate'); ylabel('y coordinate'); set(gca, 'Ydir', 'reverse');
colorbar; title('Tracks colored by total displacement','fontsize',15,'fontweight','bold');
print_save_figure(gcf, 'track_color_disp');

proj_stats.vel_all = vel_all;
proj_stats.vel_means = vel_means;
proj_stats.dist_all = dist_all;
proj_stats.dist_sum = dist_sum;
proj_stats.lifetime = life_times;
proj_stats.n_frames = n_frames;
proj_stats.n_tracks = n_tracks;

