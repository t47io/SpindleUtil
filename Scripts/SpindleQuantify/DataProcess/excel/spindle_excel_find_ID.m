function idx = spindle_excel_find_ID(spd_data, spindleID)

for i = 1:length(spd_data.data);
    if str2double(spd_data.data{i}.spindleID) == spindleID;
        idx = i;
        break;
    end;
end;