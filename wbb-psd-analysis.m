baseline = loadWBBData('data/wbb/rock2.csv');
standing = loadWBBData('data/wbb/Test1A_murat_standing_both.csv');
one_leg = loadWBBData('data/wbb/Test1c_Murat_standing_right_leg_no_bent.csv');
dizzy = loadWBBData('data/wbb/Test1H_murat_spinning_15times_then_wii.csv');

close all;
Fs = 100;       % we're resampling to 100Hz
f = logspace(-1,log10(Fs/2),1000); % from .1Hz to 50Hz
window = 5100;   % window length

%% COP x

noise_x = baseline.cop.resampled(:,1);
[noise_psd_x,noise_f_x] = pwelch(noise_x, window, [],f, Fs);
noise_psd_x_db = pow2db(noise_psd_x);

standing_x = standing.cop.resampled(:,1);
[standing_psd_x,standing_f_x] = pwelch(standing_x, window, [],f, Fs);
standing_psd_x_db = pow2db(standing_psd_x);

dizzy_x = dizzy.cop.resampled(:,1);
[dizzy_psd_x,dizzy_f_x] = pwelch(dizzy_x, window, [],f, Fs);
dizzy_psd_x_db = pow2db(dizzy_psd_x);

one_leg_x = one_leg.cop.resampled(:,1);
[one_leg_psd_x,one_leg_f_x] = pwelch(one_leg_x, window, [],f, Fs);
one_leg_psd_x_db = pow2db(one_leg_psd_x);

%% COP y

noise_y = baseline.cop.resampled(:,2);
[noise_psd_y,noise_f_y] = pwelch(noise_y, window, [],f, Fs);
noise_psd_y_db = pow2db(noise_psd_y);

standing_y = standing.cop.resampled(:,2);
[standing_psd_y,standing_f_y] = pwelch(standing_y, window, [],f, Fs);
standing_psd_y_db = pow2db(standing_psd_y);

dizzy_y = dizzy.cop.resampled(:,2);
[dizzy_psd_y,dizzy_f_y] = pwelch(dizzy_y, window, [],f, Fs);
dizzy_psd_y_db = pow2db(dizzy_psd_y);

one_leg_y = one_leg.cop.resampled(:,2);
[one_leg_psd_y,one_leg_f_y] = pwelch(one_leg_y, window, [],f, Fs);
one_leg_psd_y_db = pow2db(one_leg_psd_y);

%% plot

figure();
subplot(1,2,1);
semilogx(noise_f_x, noise_psd_x_db);
hold on;
semilogx(standing_f_x, standing_psd_x_db);
semilogx(one_leg_f_x, one_leg_psd_x_db);
semilogx(dizzy_f_x, dizzy_psd_x_db);
xlabel('Frequency [Hz]')

grid on

legend('noise','standing','one leg','dizzy')
title('COP_x')

subplot(1,2,2);
semilogx(noise_f_y, noise_psd_y_db);
hold on;
semilogx(standing_f_y, standing_psd_y_db);
semilogx(one_leg_f_y, one_leg_psd_y_db);
semilogx(dizzy_f_y, dizzy_psd_y_db);
grid on
xlabel('Frequency [Hz]')

legend('noise','standing','one leg','dizzy')
title('COP_y')

suptitle('COP - PSD analysis')

%% 

figure()
semilogx(f,standing_psd_y_db - noise_psd_y_db)
hold on
semilogx(f,one_leg_psd_y_db - noise_psd_y_db)
semilogx(f,dizzy_psd_y_db - noise_psd_y_db)
grid on