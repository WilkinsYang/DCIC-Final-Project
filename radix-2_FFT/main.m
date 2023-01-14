clc;
clf;
close all;
clear all;

%% main function
%parameter
fft_points=1024;
stage=log2(fft_points); 
iteration=1000;
group=fft_points/2;


x=randn(1,fft_points); %input data
x1=scrambler(x,stage); %scramble data for FFT computation
[y,DR_total]=FFT1(x1,stage,fft_points); %floating point operation
y_q=FFT2(x1,stage,fft_points,DR_total); %fixed-point operation
%% calculate SQNR
SQNR=10*log10(mean(abs(y).^2)/mean(abs(y-y_q).^2));
disp(['SQNR:',num2str(SQNR)]);

%% plot results
figure(1);
subplot(2,2,1);
plot(x);
ylim([-1, 3]);
grid on;
title('time domain');
subplot(2,2,2);
plot(fftshift(abs(fft(x,fft_points))));
grid on;
title('golden answer');
subplot(2,2,3);
plot(fftshift(abs(y)));
grid on;
title('radix-2 fft (floating-point)');
subplot(2,2,4);
plot(fftshift(abs(y_q)));
grid on;
title('radix-2 fft (fixed-point)');

figure(2);
subplot(2,2,1);
plot(real(y));
grid on;
title('floating-point simulation (real part)');
subplot(2,2,2);
plot(imag(y));
grid on;
title('floating-point simulation (imag part)');
subplot(2,2,3);
plot(real(y_q));
grid on;
title('fixed-point simulation (real part)');
subplot(2,2,4);
plot(imag(y_q));
grid on;
title('fixed-point simulation (imag part)');

figure(3);
histogram(real(y));
hold on;
histogram(real(y_q));
legend('origianl','quantized');
title('Radix-2 histogram (quantize 10 bit)');

%% OFDM system
OFDM(fft_points,stage,iteration);