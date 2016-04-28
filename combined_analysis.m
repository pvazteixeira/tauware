clear
clc
close all

Fs = 30;    % the frequency at which we want to resample data (e.g. 30Hz)
data=[];

%% Murat

skip = 10*Fs;
% data.kinect = loadKinectData('dataset2/murat/test1a-kinect-murat.csv',Fs);
% data.wbb = loadWBBData('dataset2/murat/test1a-wbb-murat.csv',Fs);

data.wbb = loadWBBData('dataset3/test1n-wbb-david.csv',Fs);
data.kinect = loadKinectData('dataset3/test1n-kinect-david.csv',Fs);

% data.wbb = loadWBBData('dataset3/test1n-wbb-david.csv',Fs);
% data.kinect = loadKinectData('dataset3/test1o-kinect-murat.csv',Fs);
% data.wbb = loadWBBData('dataset3/test1o-wbb-murat.csv',Fs);
% data.kinect = loadKinectData('dataset3/test1n-kinect-david2.csv',Fs);
% data.wbb = loadWBBData('dataset3/test1n-wbb-david2.csv',Fs);

% data.kinect = loadKinectData('dataset3/test1o-kinect-david-fall.csv',Fs);
% data.wbb = loadWBBData('dataset3/test1o-wbb-david-fall.csv',Fs);

% data.kinect = loadKinectData('dataset3/test1o-kinect-david.csv',Fs);
% data.wbb = loadWBBData('dataset3/test1o-wbb-david.csv',Fs);

%% David
%
% 1A - quiet standing
% data.kinect = loadKinectData('dataset2/murat/test1a-kinect-murat.csv',Fs);
% data.wbb = loadWBBData('dataset2/murat/test1a-wbb-murat.csv',Fs);
% 1C - standing on right leg
% data.kinect = loadKinectData('dataset2/david/test1c-kinect-david.csv',Fs);
% data.wbb = loadWBBData('dataset2/david/test1c-wbb-david.csv',Fs);
% 1D - standing on left leg
% data.kinect = loadKinectData('dataset2/david/test1d-kinect-david.csv',Fs);
% data.wbb = loadWBBData('dataset2/david/test1d-wbb-david.csv',Fs);
% 1H -
% data.kinect = loadKinectData('dataset2/david/test1h-kinect-david.csv',Fs);
% data.wbb = loadWBBData('dataset2/david/test1h-wbb-david.csv',Fs);
% 1K -
% data.kinect = loadKinectData('dataset2/david/test1l-kinect-david.csv',Fs);
% data.wbb = loadWBBData('dataset2/david/test1l-wbb-david.csv',Fs);
% 1L -
% data.kinect = loadKinectData('dataset2/david/test1l-kinect-david.csv',Fs);
% data.wbb = loadWBBData('dataset2/david/test1l-wbb-david.csv',Fs);
% 1M -
% data.kinect = loadKinectData('dataset2/david/test1m-kinect-david.csv',Fs);
% data.wbb = loadWBBData('dataset2/david/test1m-wbb-david.csv',Fs);
%}

%% Pedro
%{
% 1A - quiet standing
% data.kinect = loadKinectData('dataset2/pedro/test1a-kinect-pedro.csv',Fs);
% data.wbb = loadWBBData('dataset2/pedro/test1a-wbb-pedro.csv',Fs);
% 1C - standing on right leg
% data.kinect = loadKinectData('dataset2/pedro/test1c-kinect-pedro.csv',Fs);
% data.wbb = loadWBBData('dataset2/pedro/test1c-wbb-pedro.csv',Fs);
% 1D - standing on left leg
% data.kinect = loadKinectData('dataset2/pedro/test1d-kinect-pedro.csv',Fs);
% data.wbb = loadWBBData('dataset2/pedro/test1d-wbb-pedro.csv',Fs);
% 1H -
% data.kinect = loadKinectData('dataset2/pedro/test1h-kinect-pedro.csv',Fs);
% data.wbb = loadWBBData('dataset2/pedro/test1h-wbb-pedro.csv',Fs);
% 1K -
% data.kinect = loadKinectData('dataset2/pedro/test1l-kinect-pedro.csv',Fs);
% data.wbb = loadWBBData('dataset2/pedro/test1l-wbb-pedro.csv',Fs);
% 1L -
% data.kinect = loadKinectData('dataset2/pedro/test1l-kinect-pedro.csv',Fs);
% data.wbb = loadWBBData('dataset2/pedro/test1l-wbb-pedro.csv',Fs);
% 1M -
% data.kinect = loadKinectData('dataset2/pedro/test1m-kinect-pedro.csv',Fs);
% data.wbb = loadWBBData('dataset2/pedro/test1m-wbb-pedro.csv',Fs);
%}



%% Kinect analysis - PSD
%{
To do:
- look at sampling performance for both wbb and kinect
- measure time difference between both sensors
- compute the time indices for the wbb and the kinect for which the
resampled data overlaps
- 
%}

%{
sprintf('%16.4f',data.test1a.kinect.time.resampled(1))
sprintf('%16.4f',data.test1a.wbb.time.resampled(1))

% timing
figure()
plot(data.test1a.kinect.time.raw,data.test1a.kinect.time.raw,'.-')
hold on 
plot(data.test1a.wbb.time.raw,data.test1a.wbb.time.raw,'.-')
axis equal
grid on
legend('kinect','wbb')

figure()
plot(data.test1a.kinect.time.resampled,'-.')
hold on 
plot(data.test1a.wbb.time.resampled,'-.')

figure()
s = min(size(data.test1a.wbb.time.resampled),size(data.test1a.kinect.time.resampled));
plot(data.test1a.wbb.time.resampled(1:s) - data.test1a.kinect.time.resampled(1:s))
delta_t = mean(data.test1a.wbb.time.resampled(1:s) - data.test1a.kinect.time.resampled(1:s));
%}
%% combined analysis - timing 

% Compute the indices for which the two datasets overlap
[kinect_raw_idx, wbb_raw_idx] = getTimeIndices(data.kinect.time.raw, data.wbb.time.raw, skip );
[kinect_resampled_idx, wbb_resampled_idx] = getTimeIndices(data.kinect.time.resampled, data.wbb.time.resampled, skip );

%% combined analysis - cross-correlation cop/hip
% Medio-lateral (x) 
plotIOPSD(  data.wbb.time.resampled(wbb_resampled_idx), ...
            data.wbb.cop.resampled(wbb_resampled_idx,1),...
            'COP_x',...
            data.kinect.time.resampled(kinect_resampled_idx),...
            1000*data.kinect.hip.center.resampled(kinect_resampled_idx,1),...
            'Hip_x',...
            'M-L Direction (hip,x)',...
            Fs);

% Antero-posterior (y)
plotIOPSD(  data.wbb.time.resampled(wbb_resampled_idx), ...
            data.wbb.cop.resampled(wbb_resampled_idx,2),...
            'COP_y',...
            data.kinect.time.resampled(kinect_resampled_idx),...
            -1000*data.kinect.hip.center.resampled(kinect_resampled_idx,3),...
            'Hip_z',...
            'A-P Direction (hip,y)',...
            Fs);
            

%% combined analysis - cross-correlation cop/spine
% Medio-lateral (x) 
plotIOPSD(  data.wbb.time.resampled(wbb_resampled_idx), ...
            data.wbb.cop.resampled(wbb_resampled_idx,1),...
            'COP_x',...
            data.kinect.time.resampled(kinect_resampled_idx),...
            1000*data.kinect.spine.resampled(kinect_resampled_idx,1),...
            'Spine_x',...
            'M-L Direction (spine)',...
            Fs);

% Antero-posterior (y)
plotIOPSD(  data.wbb.time.resampled(wbb_resampled_idx), ...
            data.wbb.cop.resampled(wbb_resampled_idx,2),...
            'COP_y',...
            data.kinect.time.resampled(kinect_resampled_idx),...
            -1000*data.kinect.spine.resampled(kinect_resampled_idx,3),...
            'Spine_z',...
            'A-P Direction (spine)',...
            Fs);


%% combined analysis - cross-correlation cop/shoulder.center
% Medio-lateral (x) 
plotIOPSD(  data.wbb.time.resampled(wbb_resampled_idx), ...
            data.wbb.cop.resampled(wbb_resampled_idx,1),...
            'COP_x',...
            data.kinect.time.resampled(kinect_resampled_idx),...
            1000*data.kinect.shoulder.center.resampled(kinect_resampled_idx,1),...
            'Hip_x',...
            'M-L Direction (shoulder,x)',...
            Fs);

% Antero-posterior (y)
plotIOPSD(  data.wbb.time.resampled(wbb_resampled_idx), ...
            data.wbb.cop.resampled(wbb_resampled_idx,2),...
            'COP_y',...
            data.kinect.time.resampled(kinect_resampled_idx),...
            -1000*data.kinect.shoulder.center.resampled(kinect_resampled_idx,3),...
            'Hip_z',...
            'A-P Direction (shoulder,y)',...
            Fs);

%% combined analysis - cross-correlation cop/head
% Medio-lateral (x) 
plotIOPSD(  data.wbb.time.resampled(wbb_resampled_idx), ...
            data.wbb.cop.resampled(wbb_resampled_idx,1),...
            'COP_x',...
            data.kinect.time.resampled(kinect_resampled_idx),...
            1000*data.kinect.head.resampled(kinect_resampled_idx,1),...
            'Head_x',...
            'M-L Direction (head,x)',...
            Fs);

% Antero-posterior (y)
plotIOPSD(  data.wbb.time.resampled(wbb_resampled_idx), ...
            data.wbb.cop.resampled(wbb_resampled_idx,2),...
            'COP_y',...
            data.kinect.time.resampled(kinect_resampled_idx),...
            -1000*data.kinect.head.resampled(kinect_resampled_idx,3),...
            'Head_z',...
            'A-P Direction (head,y)',...
            Fs);