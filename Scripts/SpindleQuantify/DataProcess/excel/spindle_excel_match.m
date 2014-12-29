function spd_data = spindle_excel_match(spd_data)

spd_data.data = {};
n_repeat = 0;

for i = 1:length(spd_data.raw);
    
    spindleID = spd_data.raw{i}.spindleID;
    fluroChan = spd_data.raw{i}.fluroChan;
    
    % try to match the other flurophore
    is_found = false;
    for j = 1:length(spd_data.data);
        if strcmp(spd_data.data{j}.spindleID, spindleID);
            if isfield(spd_data.data{j}, 'data_TexRd') && ~isempty(strfind(fluroChan, 'FITC'));
                if ~isfield(spd_data.data{j}, 'data_FITC');
                    spd_data.data{j}.data_FITC = spd_data.raw{i}.data(:, 4);
                else
                    fprintf(2, 'WARNING: repeated dataset %s %s ignored.\n', spindleID, fluroChan);
                    n_repeat = n_repeat + 1;
                end;
                is_found = true;
                break;
            end;
            if isfield(spd_data.data{j}, 'data_FITC') && ~isempty(strfind(fluroChan, 'Texas Red'));
                if ~isfield(spd_data.data{j}, 'data_TexRd');
                    spd_data.data{j}.data_TexRd = spd_data.raw{i}.data(:, 4);
                else
                    fprintf(2, 'WARNING: repeated dataset %s %s ignored.\n', spindleID, fluroChan);
                    n_repeat = n_repeat + 1;
                end;
                is_found = true;
                break;
            end;
            
        end;
    end;
    
    % first encounter case
    if is_found;
        if length(spd_data.data{j}.data_TexRd) ~= length(spd_data.data{j}.data_FITC);
            fprintf(2, 'WARNING: trace size mismatch for spindle ID %d: FITC %d, TexRd %d.\n', ...
                spd_data.data{i}.spindleID, length(spd_data.data{j}.data_FITC), length(spd_data.data{j}.data_TexRd));
        end;
    else
        curr_id = length(spd_data.data) + 1;
        spd_data.data{curr_id}.spindleID = spindleID;
        
        if ~isempty(strfind(fluroChan, 'FITC'));
            spd_data.data{curr_id}.data_FITC = spd_data.raw{i}.data(:, 4);
        end;
        if ~isempty(strfind(fluroChan, 'Texas Red'));
            spd_data.data{curr_id}.data_TexRd = spd_data.raw{i}.data(:, 4);
        end;
        
        spd_data.data{curr_id}.x = spd_data.raw{i}.data(:, 1);
        spd_data.data{curr_id}.y = spd_data.raw{i}.data(:, 2);
    end;
end;

% find unpaired ones and warning
num_orphan = 0;

for i = 1:length(spd_data.data);
    if ~isfield(spd_data.data{i}, 'data_FITC') || ~isfield(spd_data.data{i}, 'data_TexRd');
        if isfield(spd_data.data{i}, 'data_FITC');
            fluro_miss = 'TexRed';
        else
            fluro_miss = 'FITC';
        end;
        fprintf(2, 'WARNING: spindleID %d lacks fluroChan %s.\n', spd_data.data{i}.spindleID, fluro_miss);
        num_orphan = num_orphan + 1;
    end;
end;

spd_data.n_pair = length(spd_data.data) - num_orphan;
spd_data.n_unpair = num_orphan;
spd_data.n_repeat = n_repeat;

fprintf('Found <strong>%d</strong> datasets pairs, <strong>%d</strong> left unpaired, <strong>%d</strong> repeated ignored.\n', ...
    spd_data.n_pair, spd_data.n_unpair, spd_data.n_repeat);
if (spd_data.n_pair * 2 + spd_data.n_unpair + spd_data.n_repeat) ~= spd_data.n_raw;
    fprintf(2, 'WARNING: data loss at pairing step.\n');
end;

