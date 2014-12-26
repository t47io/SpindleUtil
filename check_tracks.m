function check_tracks(xCrd, yCrd, n_picks, dir_name, cir_size, fps, dt, ratio_dist)
%  CHECK_TRACKS(xCoord, yCoord, [n_picks], [dir_name], [cir_size], [fps],
%       [deltaT], [microns])
%
% Randomly pick tracks and circle them in the time-lapse video for manual
% check of tracking quality. 6 tracks will be labeled with different color
% on same avi output movie.
% If deltaT and microns are supplied, print out statistics of picked tracks.
%
% Input
% =====
% xCoord        x coordinates from projData.xCoord, should be n_tracks
%               (rows) by n_frames (column).
% yCoord        y coordinates from projData.yCoord, same as xCoord.
% n_picks       [optional] number of tracks to pick, default 30.
% dir_name      [optional] TIFF directory, default 'images/'.
% cir_size      [optional] radius of each colored circle, default 5.
% fps           [optional] video speed in frames per second, default 3.
% deltaT        [optional] time interval between frames.
% microns       [optional] microns per pixel.
%
% e.g.
% check_tracks(projData.xCoord, projData.yCoord, 50);
% check_tracks(projData.xCoord, projData.yCoord, 50, [], 6, 1, 5, 150);
%
% by T47, Nov 2014
%
if nargin == 0; help(mfilename); return; end;

% check for data size match
if ~all(size(xCrd) == size(yCrd));
    fprintf(2,'ERROR: (x,y) coordinates data matrix size mismatch!\n');
    return;
end;
[n_tracks, n_frames] = size(xCrd);
fprintf('(x,y) coordinates of %d tracks in %d frames loaded.\n', n_tracks, n_frames);

if ~exist('dir_name','var') || isempty(dir_name); dir_name = 'images'; end;
if ~exist('n_picks','var') || isempty(n_picks); n_picks = 30; end;
print_flag = 0;
if exist('dt', 'var') && ~isempty(dt) && exist('ratio_dist', 'var') && ~isempty(ratio_dist); print_flag = 1; end;

clr_map = {'red','blue','green','yellow','magenta','cyan'};
tracks_per_video = length(clr_map);
if mod(n_picks, tracks_per_video) ~= 0;
    n_picks = (n_picks - mod(n_picks, tracks_per_video)) + tracks_per_video;
end;

if ~exist('cir_size','var') || isempty(cir_size); cir_size = 5; end;
if ~exist('fps','var') || isempty(fps); fps = 3; end;

filenames = dir([dir_name, '/*.tif*']);
if n_frames ~= length(filenames);
    fprintf(2,'ERROR: number of frame files mismatch!\n');
    return;
end;

im_frames = [];
for i = 1:length(filenames)
    temp = imadjust(imread([dir_name, '/', filenames(i).name]));
    temp = cat(3, temp, temp, temp);
    im_frames = cat(4, im_frames, temp);
end;
pixel_x = size(im_frames,1);
pixel_y = size(im_frames,2);
fprintf('%d frames loaded from %s/, %d by %d each frame.\n', length(filenames), dir_name, pixel_x, pixel_y);
fprintf('%d picks split to %d movies.\n\n', n_picks, n_picks/tracks_per_video);

id_picks = randi(n_tracks, 1, n_picks);
for i = 1:tracks_per_video:n_picks;
    
    im_overlay = im_frames;
    for j = i:(i + tracks_per_video - 1);
        
        for k = 1: n_frames;
            x = xCrd(id_picks(j), k);
            y = yCrd(id_picks(j), k);
            if all(~isnan([x,y]));
                im_overlay(:,:,:,k) = insertShape(im_overlay(:,:,:,k), 'Circle',[x, y, cir_size], 'color', clr_map{j-i+1});
            end;
        end;
        
    end;

    file_num = num2str((i-1)/tracks_per_video+1);
    
    obj = VideoWriter(['check_picks_',file_num,'.avi']);
    obj.FrameRate = fps; open(obj);
    writeVideo(obj, immovie(im_overlay)); close(obj);
    fprintf( ['Created: ', obj.Filename, '\n'] );
    
    if print_flag;
        [vel_all, vel_means, ~, ~, ~, life_times] = calculate_stats(xCrd(id_picks(i:(i + tracks_per_video - 1)),:), ...
            yCrd(id_picks(i:(i + tracks_per_video - 1)),:), dt, ratio_dist);
        
        figure(); set_print_page(gcf,1);
        subplot(3,1,1);
        for k = 1:tracks_per_video
            plot(vel_all(k,:)*60, [clr_map{k},'o-']); hold on;
        end;
        ylabel('Growth Speed (um/min)'); xlabel('Frame intervals');
        title('Speeds of picked tracks over frames','fontsize',15,'fontweight','bold');
        subplot(3,1,2);
        for k = 1:tracks_per_video
            bar(k, vel_means(k)*60, clr_map{k}); hold on;
        end;
        ylabel('Growth Speed (um/min)'); xlabel('Picked tracks');
        set(gca,'xtick',1:tracks_per_video, 'xticklabel',1:tracks_per_video);
        title('Averaged speed of picked tracks','fontsize',15,'fontweight','bold');
        subplot(3,1,3);
        for k = 1:tracks_per_video
            bar(k, life_times(k), clr_map{k}); hold on;
        end;
        ylabel('Life Time (frames)'); xlabel('Picked tracks');
        set(gca,'xtick',1:tracks_per_video, 'xticklabel',1:tracks_per_video);
        title('Life time of picked tracks','fontsize',15,'fontweight','bold');
    
        print_save_figure(gcf, ['check_picks_',file_num]);
    end;
end;
