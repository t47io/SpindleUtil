function log_cleanup(file_name)

f = fopen(file_name, 'r');
lines = textscan(f, '%s', 'Delimiter', '');
lines = strrep(strrep(lines{1}, '<strong>',''), '</strong>','');
fclose(f);
f = fopen(file_name, 'w');
for i = 1:length(lines);
    fprintf(f, '%s\n', lines{i});
end;
fclose(f);
