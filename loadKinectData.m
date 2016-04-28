function [ kinect_data ] = loadKinectData( filename, Fs )
%LOADKINECTDATA Summary of this function goes here
%   Detailed explanation goes here
%
%   pvt@mit.edu

    kinect_data = [];

    % joint (row) indices 
    hip_center      = 2:4;
    spine           = 5:7;
    shoulder_center = 8:10;
    head            = 11:13;  
    shoulder_left   = 14:16;        
    elbow_left      = 17:19; 
    wrist_left      = 20:22;
    hand_left       = 23:25;  
    shoulder_right  = 26:28;
    elbow_right     = 29:31;  
    wrist_right     = 32:34;
    hand_right      = 35:37;
    hip_left        = 38:40;
    knee_left       = 41:43;
    ankle_left      = 44:46;
    foot_left       = 47:49;    
    hip_right       = 50:52;
    knee_right      = 53:55;
    ankle_right     = 56:58;
    foot_right      = 59:61;

    % read csv (skip header)
    d = csvread(filename,2);
    
    % time
    t = d(:,1);
    %t = t-t(1);
    t = t/1e3;
    kinect_data.time.raw = t;
    
    % head
    kinect_data.head.raw = d(:,head);
    % joint measurements - shoulders
    kinect_data.shoulder.center.raw = d(:,shoulder_center);
    kinect_data.shoulder.left.raw = d(:,shoulder_left);
    kinect_data.shoulder.right.raw = d(:,shoulder_right);
    % elbows
    kinect_data.elbow.left.raw = d(:,elbow_left);
    kinect_data.elbow.right.raw = d(:,elbow_right);
    % wrists
    kinect_data.wrist.left.raw = d(:,wrist_left);
    kinect_data.wrist.right.raw = d(:,wrist_right);
    % hand
    kinect_data.hand.left.raw = d(:,hand_left);
    kinect_data.hand.right.raw = d(:,hand_right);
    % spine
    kinect_data.spine.raw = d(:,spine); 
    % hip
    kinect_data.hip.center.raw = d(:,hip_center);
    kinect_data.hip.left.raw   = d(:,hip_left);
    kinect_data.hip.right.raw  = d(:,hip_right);
    % knees
    kinect_data.knee.left.raw = d(:,knee_left);
    kinect_data.knee.right.raw = d(:,knee_right);
    % ankles
    kinect_data.ankle.left.raw = d(:,ankle_left);
    kinect_data.ankle.right.raw = d(:,ankle_right);
    % feet
    kinect_data.foot.left.raw = d(:,foot_left);
    kinect_data.foot.right.raw = d(:,foot_right);
    
    
    % TODO: resample EVERYTHING
    %Fs = 30; % nominal sampling frequency
    [kinect_data.head.resampled, kinect_data.time.resampled] = resample(kinect_data.head.raw, t, Fs);
    % shoulder
    [kinect_data.shoulder.center.resampled,~] = resample(kinect_data.shoulder.center.raw, t, Fs);
    [kinect_data.shoulder.left.resampled,~] = resample(kinect_data.shoulder.left.raw, t, Fs);
    [kinect_data.shoulder.right.resampled,~] = resample(kinect_data.shoulder.right.raw, t, Fs);
    
    % elbows
    [kinect_data.elbow.left.resampled,~] = resample(kinect_data.elbow.left.raw, t, Fs);
    [kinect_data.elbow.right.resampled,~] = resample(kinect_data.elbow.right.raw, t, Fs);
    
    % wrists
    [kinect_data.wrist.left.resampled,~] = resample(kinect_data.wrist.left.raw, t, Fs);
    [kinect_data.wrist.right.resampled,~] = resample(kinect_data.wrist.right.raw, t, Fs);
    
    % hands
    [kinect_data.hand.left.resampled,~] = resample(kinect_data.hand.left.raw, t, Fs);
    [kinect_data.hand.right.resampled,~] = resample(kinect_data.hand.right.raw, t, Fs);
    
    % spine
    [kinect_data.spine.resampled,~] = resample(kinect_data.spine.raw, t, Fs);
    
    % hip
    [kinect_data.hip.center.resampled,~] = resample(kinect_data.hip.center.raw, t, Fs);
    [kinect_data.hip.left.resampled,~] = resample(kinect_data.hip.left.raw, t, Fs);
    [kinect_data.hip.right.resampled,~] = resample(kinect_data.hip.right.raw, t, Fs);
    
    % knees
    [kinect_data.knee.left.resampled,~] = resample(kinect_data.knee.left.raw, t, Fs);
    [kinect_data.knee.right.resampled,~] = resample(kinect_data.knee.right.raw, t, Fs);
   
    % ankles
    [kinect_data.ankle.left.resampled,~] = resample(kinect_data.ankle.left.raw, t, Fs);
    [kinect_data.ankle.right.resampled,~] = resample(kinect_data.ankle.right.raw, t, Fs);
   
    % feet
    [kinect_data.foot.left.resampled,~] = resample(kinect_data.foot.left.raw, t, Fs);
    [kinect_data.foot.right.resampled,~] = resample(kinect_data.foot.right.raw, t, Fs);
   
end

