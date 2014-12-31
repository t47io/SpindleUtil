function idx = spindle_mat_find_ID(spd_data, spindle_ID)

if isnumeric(spindle_ID); 
    spindle_ID = num2str(spindle_ID);
end;

for i = 1:length(spd_data);
    if str2double(spd_data{i}.raw_file(end-3:end-1)) == str2double(spindle_ID);
        idx = i;
        return;
    end;
end;
idx = -1;
