% Example to show how the truncation sinusoids in time domain produces 
% sinc functions in the frequency domain
% The reason is the multiplication of the sinusoids in time domain with a
% window of length Ts (duration of the sinusoids) corresponds a convolution 
% in frequency domain with a delta function and a sinc

% The script outputs two figures

clc
clear all
close all

% --- Initialization
BW = 20e6; % Bandwidth
N = 4; % number of subcarriers (keep it small for illustration purpose)
scs = BW/N; % Subcarrier Spacing
f = [scs/2:scs:BW]; % Freq of oscillators
Ts = 1/scs; % Symbol duration

cx = 20; % upsampling rate
fs = BW*2*cx; % sampling rate
t = 0:1/fs:Ts-(1/fs);

% --- Print some information
fprintf('Bandwidth of the system: %0.4f (MHz)\n',BW/1e6)
fprintf('Duration of the Symbol of a single-carrier system: %0.4f (nsec)\n',1e9*1/BW)
fprintf('Duration of the Symbol of a multi-carrier system: %0.4f (nsec)\n',1e9*Ts)
fprintf('Number of Subcarriers: %d\n', N)
fprintf('Subcarrier Spacing: %0.4f (MHz)\n', scs/1e6);


% --- Create oscillators i.e. sinusoids
oscilattors = zeros(N,length(t));
figure
for i = 1:N
    oscilattors(i,:) = exp(2*pi*1j*f(i)*t);

    % plot
    subplot(N,1,i)
    plot(t,real(oscilattors(i,:)))
    xlabel('Time (sec)')
    grid on
    title(['Frequency ',num2str(f(i)/1e6),' MHz'])
end

% --- Assume that we transmit 1's and compute the FFT
FFT = 2^14;
% Find the frequency values
step = fs/FFT;
freqRange = -fs/2:step:(fs/2)-step;
figure
for i = 1:N
    cosSignal = oscilattors(i,:);

    % Append zeros
    cosSignalAppZeros = [cosSignal zeros(1,FFT-length(cosSignal))];

    % Compute FFT
    F = fft(cosSignalAppZeros)/sqrt(FFT);

    % Plot
    plot(freqRange/1e6,fftshift(real(F)))
    hold on
end
grid on
xlabel('Freq (MHz)')
ylabel('Real Part of FFT')
xlim([-1.1*f(end)/1e6 2.1*f(end)/1e6])
