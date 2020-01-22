%% this function returns the base profile as well as the idle temperature of an antenna given the tx time  
%% (first block) reads the antenna temperature data from the directory
function [temp_fit, idle_temp] = CreateTemperatureProfile(antenna_no)

    global folder_currentdissipation 
    global tx_time smooth_factor tol data_length
    
    %% block 1
    file = strcat('dissipation_',num2str(tx_time),'_',num2str(antenna_no));
    filename = fullfile(folder_currentdissipation, file);
    temp_raw = ExtractTemperature(filename);
    throughput = ExtractThroughput(filename);
    
    %% block 2
    %% determine the idle temperature 
    %% and the index of the starting point from raw data
    i = 1;
    while throughput(i) == 0
        i = i+1;
    end
    t_start = i; % starting point
    idle_temp = mean(temp_raw(1:t_start-1)); % idle temperature
    std_idle = std(temp_raw(1:t_start-1));
    
    %% block 3
    %% fit the temperature to a smoothing spline model
    xdatain = (1:length(temp_raw)).';
    f = fit(xdatain,temp_raw,'smoothingspline','SmoothingParam',smooth_factor);
    temp_fit = f(xdatain);
    
    mu_idle_fit = 0;
    start = 1;
    win_size = 10; % running average window: we take mean over 10 time slots at a time
    while mu_idle_fit <= idle_temp+tol*std_idle
        mu_idle_fit = mean(temp_fit(start:start+win_size-1));
        start = start+1;
    end
    start = start + floor((win_size-1)/2);
    
    %% block 4
    % negate the idle temperature 
    temp_fit = temp_fit - idle_temp;
    %% eliminate the idle period and the idle temperature 
    %% to create the base transmission profile
    temp_fit(1:start-1) = [];

    %% 
    if length(temp_fit) > data_length
        temp_fit(data_length+1:end) = [];
    elseif length(temp_fit) < data_length
        while length(temp_fit) ~= data_length 
            temp_fit = [temp_fit; NaN];
        end
    end      
        
end