function [radio_temp, mac_temp] = ExtractTemperature(filename) 

    mac_temp = [];
    radio_temp = [];
    fid = fopen(strcat(filename, '_temp'));
    tline = fgetl(fid);
    while ischar(tline)        
        % check if it mac or radio
        if contains(tline, 'mac')
            mac_string = strsplit(tline, '=');
            mac_temp = [mac_temp; str2num(mac_string{2})];
        elseif contains(tline, 'radio')
            radio_string = strsplit(tline, '=');
            radio_temp = [radio_temp; str2num(radio_string{2})];
        end        
        tline = fgetl(fid);
    end 
        
    fclose all;
end