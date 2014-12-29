function idx = spindle_mat_find_ID(spd_data, spindle_ID)

for i = 1:length(spd_data);
    if spd_data{i}.raw_file(end-3:end-1) == spindle_ID;
        idx = i;
        break;
    end;
end;