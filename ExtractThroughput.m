function tx_goodput = ExtractThroughput(filename)
    tx_goodput = [];

    fid = fopen(strcat(filename, '_bf'));
    tline = fgetl(fid);
    
    while ischar(tline) 
        if contains(tline, 'Goodput')
            mac_string = strsplit(tline, ':');
            tx_goodput = [tx_goodput; str2num(mac_string{3})];
        end        
        tline = fgetl(fid);
    end

    fclose all;
end
