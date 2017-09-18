% images must be present in triples, i.e. _w1DAPI, _w2Texas Red, _w3FITC
% image extension must be uppercase .TIF

% first go to the folder that has all the .TIF images
cd 'some-directory';

% define the ranges to try, each row should be in format of
% Rmin, Rmax, Gmin, Gmax, Bmin, Bmax
range_lists = [ ...
  120 1500 200 1000 300 2000; ...
  50 500 50 500 50 500; ...
];

% color-combined images are saved with _cc.TIF suffix
% under each range folder, e.g. 50-500--50-500--50-500
batch_color_combine('.', range_lists);
