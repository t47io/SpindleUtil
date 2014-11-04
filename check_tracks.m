function check_tracks(proj, n_picks, dir_name, circ_size, fps)
% CHECK_TRACKS(projData, [n_picks], [dir_name], [circ_size], [fps])
%
% Randomly pick tracks and circle them in the time-lapse video for manual
% check of tracking quality. 6 tracks will be labeled with different color
% on same avi output movie. Print out statistics of picked tracks.
%
% Input
% =====
% projData      projData struct in projData.mat
% n_picks       [optional] number of tracks to pick, default 30.
% dir_name      [optional] TIFF directory, default 'images/'.
% circ_size      [optional] radius of each colored circle, default 5.
% fps           [optional] video speed in frames per second, default 3.
%
% e.g.
% check_tracks(projData, 50, [], [], 1);
%
% by T47, Nov 2014
%
if nargin == 0; help(mfilename); return; end;

xCrd = proj.xCoord;
yCrd = proj.yCoord;
dt = proj.secPerFrame;
ratio_dist = proj.pixSizeNm;

[n_tracks, n_frames] = size(xCrd);
fprintf('Loaded from projData: (x,y) coordinates of %d tracks in %d frames.\n', n_tracks, n_frames);
fprintf('Loaded from projData: %d seconds per frame and %d microns per pixel.\n', dt, ratio_dist);

if ~exist('dir_name','var') || isempty(dir_name); dir_name = 'images'; end;
filenames = dir([dir_name, '/*.tif*']);
fprintf('Loaded from TIFF: %d TIFF files from %s/.\n', length(filenames), dir_name);
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
fprintf('Loaded from TIFF: %d by %d pixels in each frame.\n', size(im_frames,1), size(im_frames,2));

if ~exist('n_picks','var') || isempty(n_picks); n_picks = 30; end;
if ~exist('circ_size','var') || isempty(circ_size); circ_size = 5; end;
if ~exist('fps','var') || isempty(fps); fps = 3; end;
clr_map = {'red','blue','green','yellow','magenta','cyan'};
tracks_per_video = length(clr_map);
if mod(n_picks, tracks_per_video) ~= 0;
    n_picks = (n_picks - mod(n_picks, tracks_per_video)) + tracks_per_video;
end;
fprintf('Parameters used: n_picks %d, circ_size %d, fps %d\n', n_picks, circ_size, fps);
fprintf('Output: %d picks split to %d movies.\n\n', n_picks, n_picks/tracks_per_video);

id_picks = randi(n_tracks, 1, n_picks);
for i = 1:tracks_per_video:n_picks;
    
    im_overlay = im_frames;
    for j = i:(i + tracks_per_video - 1);
        
        for k = 1: n_frames;
            x = xCrd(id_picks(j), k);
            y = yCrd(id_picks(j), k);
            if all(~isnan([x,y]));
                im_overlay(:,:,:,k) = insertShape(im_overlay(:,:,:,k), 'Circle',[x, y, circ_size], 'color', clr_map{j-i+1});
            end;
        end;
        
    end;
    
    file_num = num2str((i-1)/tracks_per_video+1);
    
    obj = VideoWriter(['check_picks_',file_num,'.avi']);
    obj.FrameRate = fps; open(obj);
    writeVideo(obj, immovie(im_overlay)); close(obj);
    fprintf( ['Created: ', obj.Filename, '\n'] );
    
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
