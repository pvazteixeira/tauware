function [ wbb_data ] = loadWBBData( filename, Fs)
%LOADWBBDATA Summary of this function goes here
%   Detailed explanation goes here
%
%   pvt@mit.edu

    wbb_data = [];
    
    % values
    dx = 217; % half of the horizontal distance between the sensors [mm]
    dy = 119; % half of the vertical distance between the sensors [mm]
    
    % sensor positions
    wbb_data.sensor.topRight.position       = [dx,dy];
    wbb_data.sensor.bottomRight.position    = [dx,-dy];
    wbb_data.sensor.topLeft.position        = [-dx,dy];
    wbb_data.sensor.bottomLeft.position     = [-dx,-dy];

    d = csvread(filename); 

    t = d(:,1);
    %t = t - t(1);   % relative time
    t = t/1e3;      % convert to seconds
    wbb_data.time.raw = t;

    w = sum( d(:,2:5),2); % total weight

    % absolute readings
    wbb_data.sensor.topRight.raw      = d(:,2);
    wbb_data.sensor.bottomRight.raw   = d(:,3);
    wbb_data.sensor.bottomLeft.raw    = d(:,4);
    wbb_data.sensor.topLeft.raw       = d(:,5);
    wbb_data.sensor.total.raw         = w;
    
    topRight_n = d(:,2)./w;
    bottomRight_n = d(:,3)./w;
    bottomLeft_n = d(:,4)./w;
    topLeft_n = d(:,5)./w;
    wbb_data.cop.raw =  topRight_n*wbb_data.sensor.topRight.position + ...
                        bottomRight_n*wbb_data.sensor.bottomRight.position + ...
                        topLeft_n*wbb_data.sensor.topLeft.position + ...
                        bottomLeft_n*wbb_data.sensor.bottomLeft.position;
    
    % add resampled data (to nominal sampling frequency)
    % Fs = 100;
    [wbb_data.sensor.topRight.resampled, ~]     = resample(wbb_data.sensor.topRight.raw,t,Fs);
    [wbb_data.sensor.bottomRight.resampled, ~]  = resample(wbb_data.sensor.bottomRight.raw,t,Fs);
    [wbb_data.sensor.bottomLeft.resampled, ~]   = resample(wbb_data.sensor.bottomLeft.raw,t,Fs);
    [wbb_data.sensor.topLeft.resampled, ~]      = resample(wbb_data.sensor.topLeft.raw,t,Fs);
    [wbb_data.sensor.total.resampled, wbb_data.time.resampled] = resample(wbb_data.sensor.total.raw, t, Fs); 
    
    [cop_rs_x, ~] = resample(wbb_data.cop.raw(:,1), t, Fs);
    [cop_rs_y, ~] = resample(wbb_data.cop.raw(:,2), t, Fs);
    
    wbb_data.cop.resampled = [cop_rs_x, cop_rs_y];
                    
 end

