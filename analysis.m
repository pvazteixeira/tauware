%{
2.131 - Advanced Systems and Instrumentation
Balance characterization project
Analysis script for WBB+Kinect data

April 2016
pvt@mit.edu
%}

clc;

%% parameters

% wbb sensor positions
dx = 21.7; % half of the horizontal distance between the sensors [cm]
dy = 11.9; % half of the vertical distance between the sensors [cm]

topRight_pos = [dx,dy];
bottomRight_pos = [dx,-dy];
topLeft_pos = [-dx,dy];
bottomLeft_pos = [-dx,-dy];

run('skeleton_joint_indices.m');

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

kinect_data = csvread('data/kinect/skeleton-track_murat_test1a.csv',1);
wbb_data = csvread('data/wbb/Test1A_murat_standing_both.csv');

%% kinect timing analysis

kinect_time = kinect_data(:,1);
kinect_time = kinect_time - kinect_time(1);
kinect_time = kinect_time/1e3; 

figure(1)
kinect_dt = diff(kinect_time);
hist(kinect_dt,100);
xlabel('Sampling period [s]')
ylabel('Count []')
grid on
title('Kinect sampling period histogram')

kinect_mean_sp = mean(kinect_dt);
kinect_std_dev_sp = std(kinect_dt);
disp('Sampling period:')
disp(['  mean:      ',num2str(kinect_mean_sp),'s'])
disp(['  std. dev.: ',num2str(kinect_std_dev_sp),'s'])

%% wbb timing analysis
wbb_time = wbb_data(:,1);
wbb_time = wbb_time - wbb_time(1);
wbb_time = wbb_time/1e3;

figure(2)
wbb_dt = diff(wbb_time);
hist(wbb_dt,100);
xlabel('Sampling period [s]')
ylabel('Count []')
grid on
title('WBB sampling period histogram')

wbb_mean_sp = mean(wbb_dt);
wbb_std_dev_sp = std(wbb_dt);
disp('Sampling period:')
disp(['  mean:      ',num2str(kinect_mean_sp),'s'])
disp(['  std. dev.: ',num2str(kinect_std_dev_sp),'s'])

%% kinect data
hip = [kinect_data(:,hip_center_x), kinect_data(:,hip_center_y), kinect_data(:,hip_center_z)];
spine = [kinect_data(:,spine_x), kinect_data(:,spine_y), kinect_data(:,spine_z)];
shoulder_center = [kinect_data(:,shoulder_center_x), kinect_data(:,shoulder_center_y), kinect_data(:,shoulder_center_z)];
head = [kinect_data(:,head_x), kinect_data(:,head_y), kinect_data(:,head_z)];

%% wbb data
w = sum( wbb_data(:,2:5),2); % total weight

% absolute readings
topRight = wbb_data(:,2);
bottomRight = wbb_data(:,3);
bottomLeft = wbb_data(:,4);
topLeft = wbb_data(:,5);

% normalized readings
topRight_n = wbb_data(:,2)./w;
bottomRight_n = wbb_data(:,3)./w;
bottomLeft_n = wbb_data(:,4)./w;
topLeft_n = wbb_data(:,5)./w;

% cop position
cop = topRight_n*topRight_pos + bottomRight_n*bottomRight_pos + ...
      topLeft_n*topLeft_pos + bottomLeft_n*bottomLeft_pos;


%% plot cop, hip, spine
% note: if the kinect is horizontal, we are interested in the XZ plane
figure()
plot(kinect_time,hip(:,1),'b')
hold on
plot(kinect_time,hip(:,2),'r')
plot(kinect_time,hip(:,3),'g')
grid on
legend('x_{hip}','y_{hip}','z_{hip}')

%%
figure()
plot(d(:,hip_center_x),d(:,hip_center_y))
hold on
plot(d(:,spine_x),d(:,spine_y),'r')
grid on
axis equal
xlabel('x_{hip} [m]')
ylabel('y_{hip} [m]')

kinect_cop = [d(:,hip_center_x),d(:,hip_center_y)];

%%

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
Fs = 30;
[cop_rs_x, ~] = resample(cop(:,1), t, Fs);
[cop_rs_y, t_rs] = resample(cop(:,2), t, Fs);

%%
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
