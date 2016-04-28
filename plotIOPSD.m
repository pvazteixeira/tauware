function [ output_args ] = plotIOPSD( in_time, in_signal, in_name, out_time, out_signal, out_name, title_name, Fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % de-mean the signal
    in_signal = in_signal - mean(in_signal);
    out_signal = out_signal - mean(out_signal);

    % convert to elapsed time
    in_time = in_time - in_time(1);    
    out_time = out_time - out_time(1); 
    
    % determine total duration (and min. frequency, min. freq. increment)
    duration = min(in_time(end), out_time(end));
    df = 1/duration;
    f = df:df:(Fs/2);
    
    % signals
    figure('Position', [100, 100, 900, 700])
    plot(in_time, in_signal)
    title(['Time Series - ',title_name])
    hold on
    plot(out_time, out_signal)
    xlabel('time[s]')
    ylabel('displacement [mm]')
    legend(in_name,out_name)
    grid on

    % cross correlation
    [r, lags] = xcorr(in_signal, out_signal);
    figure('Position', [100, 100, 900, 700])
    plot(lags*(1/Fs),r)
    grid on
    xlabel('Lag [s]')
    title(['Cross Correlation - ',title_name])
    
    % power spectral densities
    [input_psd, input_psd_f] = pwelch(in_signal, [], [], f, Fs);
    input_psd_db = pow2db(input_psd);
    [output_psd, output_psd_f] = pwelch(out_signal, [], [], f, Fs);
    output_psd_db = pow2db(output_psd);
    
    figure('Position', [100, 100, 900, 700])
    semilogx(input_psd_f, input_psd_db)
    title(['Power Spectral Density - ',title_name])
    hold on 
    semilogx(output_psd_f, output_psd_db)
    grid on
    xlim([f(1) f(end)])
    xlabel('Frequency [s^{-1}]')
    legend(in_name,out_name)


    % cross spectral densities
    [Pxy,f_xy] = cpsd(in_signal,out_signal,[],[],[],Fs);
    [Cxy,fc_xy] = mscohere(in_signal,out_signal,[],[],[],Fs);
    figure('Position', [100, 100, 900, 700])
    suptitle(['Cross Power Spectral Density - ',title_name])
    subplot(3,1,1)
    semilogx(f_xy,mag2db(abs(Pxy)))
    ylabel('Gain [dB]')
    grid on 
    axis tight
    xlim([f(1) f(end)])
    subplot(3,1,2)
    semilogx(f_xy,unwrap(angle(Pxy)))
    ylabel('Phase [rad]')
    grid on
    axis tight
    xlim([f(1) f(end)])
    subplot(3,1,3)
    semilogx(fc_xy, Cxy)
    ylabel('|Coherence|^2')
    xlabel('Frequency [s^{-1}]')
    grid on
    xlim([f(1) f(end)])
    
    
    % transform estimate
    [Txy, ft_xy] = tfestimate(in_signal, out_signal, [], [], [], Fs);

    figure('Position', [100, 100, 900, 700])
    subplot(3,1,1)
    semilogx(ft_xy, mag2db(abs(Txy)))
    ylabel('Gain [dB]')
    grid on 
    axis tight
    xlim([f(1) f(end)])
    subplot(3,1,2)
    semilogx(ft_xy,unwrap(angle(Txy)))
    ylabel('Phase [rad]')
    grid on
    axis tight
    xlim([f(1) f(end)])
    subplot(3,1,3)
    semilogx(fc_xy, Cxy)
    ylabel('|Coherence|^2')
    xlabel('Frequency [s^{-1}]')
    grid on
    xlim([f(1) f(end)])
    suptitle(['Transfer Function Estimate - ',title_name])
end

