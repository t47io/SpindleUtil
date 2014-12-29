function [vel_all, vel_means, vel_cutoff, dist_all, dist_sum, life_times, lf_tm_cutoff, n_tracks, n_frames] = calculate_stats(xCrd, yCrd, dt, ratio_dist)

% save data dimentions
[n_tracks, n_frames] = size(xCrd);

% calculate speed and distance for all intervals all tracks
vel_all = nan(n_tracks,n_frames -1);
dist_all = nan(n_tracks,n_frames -1);
for i = 1:n_tracks
    for j = 1:(n_frames - 1)
        if ~any(isnan([xCrd(i,j:j+1),yCrd(i,j:j+1)]));
            dist_all(i,j) = ((xCrd(i,j) - xCrd(i,j+1))^2 + (yCrd(i,j) - yCrd(i,j+1))^2)^0.5;
            vel_all(i,j) = dist_all(i,j)*ratio_dist/1000/dt;
        end;
    end;
end;

% calculate life time, average speed and total distance for each track
vel_means = nan(n_tracks,1);
dist_sum = nan(n_tracks,1);
life_times = nan(n_tracks,1);
for i = 1:n_tracks
    temp = vel_all(i,:);
    vel_means(i) = mean(temp(~isnan(temp)));
    temp = dist_all(i,:);
    dist_sum(i) = sum(temp(~isnan(temp)));
    life_times(i) = length(temp(~isnan(temp)));
end;

% calculate global mean speed and life time
vel_cutoff = mean(vel_means);
lf_tm_cutoff = mean(life_times);