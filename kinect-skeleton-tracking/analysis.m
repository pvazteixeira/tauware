%{
2.131 - Advanced Systems and Instrumentation
Balance characterization project
Analysis script for Kinect skeletal tracking data

April 2016
pvt@mit.edu
%}

clc;

run('skeleton_joint_indices.m');

%% parameters

% values
dx = 21.7; % half of the horizontal distance between the sensors [cm]
dy = 11.9; % half of the vertical distance between the sensors [cm]

% sensor positions
topRight_pos = [dx,dy];
bottomRight_pos = [dx,-dy];
topLeft_pos = [-dx,dy];
bottomLeft_pos = [-dx,-dy];

%% read data
%{
    Data files contain comma-separated values 
    Each line contains 5 values:
    time - the measurement timestamp  [microseconds]
    topRight - the sensor reading for the top right sensor [kg]
    bottomRight - the sensor reading for the bottom right sensor [kg]
    bottomLeft - the sensor reading for the bottom left sensor [kg]
    topLeft - the sensor reading for the top left sensor [kg]
%}
% d = csvread('data/Test1a_murat_stading_30s.csv');
% d = csvread('data/Test1b_murat_stading_eyesclosed.csv');
% d = csvread('data/Test1c_right_leg_standing.csv');
% d = csvread('data/Test1d_murat_left_leg_standing.csv');
% d = csvread('data/Test1e_murat_left_leg_bent_knee.csv');
% d = csvread('data/Test1f_murat_right_leg_bent_knee.csv');
% d = csvread('data/Test1g_murat_squat.csv');
d = csvread('data/Test1h_spinning_murat_15.csv');

t = d(:,1);
t = t - t(1);   % relative time
t = t/1e6;      % convert to seconds

w = sum( d(:,2:5),2); % total weight

% absolute readings
topRight = d(:,2);
bottomRight = d(:,3);
bottomLeft = d(:,4);
topLeft = d(:,5);

% normalized readings
topRight_n = d(:,2)./w;
bottomRight_n = d(:,3)./w;
bottomLeft_n = d(:,4)./w;
topLeft_n = d(:,5)./w;

% cop position
cop = topRight_n*topRight_pos + bottomRight_n*bottomRight_pos + ...
      topLeft_n*topLeft_pos + bottomLeft_n*bottomLeft_pos;

%% plot data
close all

% 0 - sampling period
dt = diff(t);
hist(diff(t),1000);
xlabel('Sampling period [s]')
ylabel('Count []')
grid on
% mean and standard deviation
mean_sp = mean(dt);
std_dev_sp = std(dt);
disp('Sampling period:')
disp(['  mean:      ',num2str(mean_sp),'s'])
disp(['  std. dev.: ',num2str(std_dev_sp),'s'])
title('Sampling period histogram')


% let's plot only when there's someone on the board
i = w>10; 

% ...and remove the transient (to do)


% 1 - sensor readings
figure(2)
plot(t(i), topRight(i))
hold on
plot(t(i), bottomRight(i))
plot(t(i), bottomLeft(i))
plot(t(i), topLeft(i))
plot(t(i), w(i))
grid on
xlabel('time [s]')
ylabel('weight [kg]')
title('Sensor readings')
legend('topRight', 'bottomRight', 'bottomLeft', 'topLeft', 'total','Location','East')


% 2 - center of pressure
figure(3)
plot(cop(i,1),cop(i,2),'.-')
grid on
axis equal
xlabel('COP_x [cm]')
ylabel('COP_y [cm]')
title('Center of pressure')


%% data resampling (EXPERIMENTAL)
Fs = 10;
[cop_rs_x, ~] = resample(cop(:,1), t, Fs);
[cop_rs_y, t_rs] = resample(cop(:,2), t, Fs);

figure(4)
subplot(1,2,1)
plot(cop_rs_x,cop_rs_y,'.-')
grid on
axis equal
xlabel('COP_x [cm]')
ylabel('COP_y [cm]')
title(['Center of pressure (resampled to ',num2str(Fs),'Hz)'])
subplot(1,2,2)
plot(t_rs,cop_rs_x)
hold on
plot(t_rs,cop_rs_y)
grid on
ylabel('COP [cm]')
xlabel('time [s]')

%% frequency analysis (EXPERIMENTAL)

% pwelch(x,window,noverlap,f,fs)
[psd_x,f_x] = pwelch(cop_rs_x, [], [] ,[] ,Fs);
[psd_y,f_y] = pwelch(cop_rs_y, [], [] ,[] ,Fs);
psd_db_x = pow2db(psd_x);
psd_db_y = pow2db(psd_y);
figure(5)
semilogx(f_x, psd_db_x,'.-')
hold on
semilogx(f_y, psd_db_y,'.-')
xlabel('Frequency [Hz]')
grid on
title('COP - Power Spectral Density')
legend('COP_x','COP_Y')
