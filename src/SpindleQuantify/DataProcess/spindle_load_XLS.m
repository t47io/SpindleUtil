function spd_data = spindle_load_XLS(file_name, sheet_name)

% use xlsread to load xls file
[~, ~, raw_data] = xlsread(file_name, sheet_name);

count = 0;
spd_data.raw = {};
prev_index = 0;

for i = 1:(size(raw_data, 1) - 2);
    
    % trim out NaN (empty cells)
    if isnan(raw_data{i, 1}); continue; end;
    
    % look for 3 lines in a row with non-numeric start (label)
    if (~isnumeric(raw_data{i, 1}) && ...
            ~isnumeric(raw_data{i + 1, 1}) && ...
            ~isnumeric(raw_data{i + 2, 1})) ...
        || i == size(raw_data, 1) - 2;
        
        if prev_index == 0;
            % 1st block
            prev_index = i;
        else
            % save current position
            curr_index = i;
            % save end-of-file for last block
            if i == size(raw_data, 1) - 2;
                curr_index = size(raw_data, 1) + 1;
            end;
            
            count = count + 1;
            spd_data.raw{count}.data = cell2mat(raw_data((prev_index + 3):(curr_index - 1), 1:4));
            label = raw_data{prev_index + 1, 1};
            label = strsplit(label, '_');
            
            % test expCondition label should be same
            if isfield(spd_data, 'expCondition');
                if spd_data.expCondition ~= label{1};
                    fprintf(2, 'WARNING: expCondition mismatch: %s should not be in the same set of %s', ...
                        label, spd_data.expCondition);
                end;
            else
                spd_data.expCondition = label{1};
            end;
            spd_data.raw{count}.spindleID = label{2};
            spd_data.raw{count}.fluroChan = label{3};
            
            prev_index = curr_index;
        end;
    end;
end;

spd_data.n_raw = length(spd_data.raw);
fprintf('Loaded <strong>%d</strong> blocks from <strong>%s</strong>, sheet <strong>%s</strong>.\n', spd_data.n_raw, file_name, sheet_name);
