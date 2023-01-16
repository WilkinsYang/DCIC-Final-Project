clc;
clear;
close all;

%% FFT parameters
FFT_LENGTH = 1024;

%% Generate signal x
% Real
% x = randn(1, FFT_LENGTH);
% X = zeros(1, FFT_LENGTH);
% Complex
x = complex(randn(1, FFT_LENGTH), randn(1, FFT_LENGTH));
X = complex(zeros(1, FFT_LENGTH));

% Build-in FFT in MATLAB
answer_X = fft(x);
init_x = x;


%% Floating point
index = 0;
fft_length = FFT_LENGTH;
DR=zeros(2,5);
% Calculate stages
while(1)
    index = index + 1;
    fft_length = bitshift(fft_length, -2);
    if fft_length == 4
        total_stage = index;
        break;
    end
end

% FFT Radix-4 Algorithm
for i = 0:total_stage
    if i==total_stage
        % Radix-4 butterfly final stage
        for n = 1:FFT_LENGTH/4
            k = n-1;
            X(4*k + 1) = (x(n) + x(n+FFT_LENGTH/4) + x(n+2*FFT_LENGTH/4) + x(n+3*FFT_LENGTH/4));
            X(4*k + 2) = (x(n) - x(n+FFT_LENGTH/4) + x(n+2*FFT_LENGTH/4) - x(n+3*FFT_LENGTH/4))*exp(-1i*2*pi*0/FFT_LENGTH);
            X(4*k + 3) = (x(n) - x(n+FFT_LENGTH/4)*(1i) - x(n+2*FFT_LENGTH/4) + x(n+3*FFT_LENGTH/4)*(1i))*exp(-1i*2*pi*0/FFT_LENGTH);
            X(4*k + 4) = (x(n) + x(n+FFT_LENGTH/4)*(1i) - x(n+2*FFT_LENGTH/4) - x(n+3*FFT_LENGTH/4)*(1i))*exp(-1i*2*pi*0/FFT_LENGTH);
        end
        x = X;
    else
        % Radix-4 butterfly previous stages
        for n = 1:FFT_LENGTH/4
            k = n-1;
            weight = (4^i) * floor(k/(4^i));
            X(4*k + 1) = (x(n) + x(n+FFT_LENGTH/4) + x(n+2*FFT_LENGTH/4) + x(n+3*FFT_LENGTH/4));
            X(4*k + 2) = (x(n) - x(n+FFT_LENGTH/4) + x(n+2*FFT_LENGTH/4) - x(n+3*FFT_LENGTH/4))*exp(-1i*2*pi*2*weight/FFT_LENGTH);
            X(4*k + 3) = (x(n) - x(n+FFT_LENGTH/4)*(1i) - x(n+2*FFT_LENGTH/4) + x(n+3*FFT_LENGTH/4)*(1i))*exp(-1i*2*pi*weight/FFT_LENGTH);
            X(4*k + 4) = (x(n) + x(n+FFT_LENGTH/4)*(1i) - x(n+2*FFT_LENGTH/4) - x(n+3*FFT_LENGTH/4)*(1i))*exp(-1i*2*pi*3*weight/FFT_LENGTH);
        end
        x = X;
        
    end
    DR(:,i+1)=[ddr(real(X)); ddr(imag(X))];
end


% Digit reversal
float_reversal_X = bitrevorder(X);

%% Fixed point
index = 0;
fft_length = FFT_LENGTH;
x = init_x;
while(1)
    index = index + 1;
    fft_length = bitshift(fft_length, -2);
    if fft_length == 4
        total_stage = index;
        break;
    end
end

% FFT Radix-4 Algorithm
temp=x;
% Do fixed-point to x
x = Q(real(temp), 10, ddr(real(temp))) + (1j)*Q(imag(temp), 10, ddr(imag(temp)));
for i = 0:total_stage
    if i==total_stage
        % Radix-4 butterfly final stage
        for n = 1:FFT_LENGTH/4
            k = n-1;
            X(4*k + 1) = (x(n) + x(n+FFT_LENGTH/4) + x(n+2*FFT_LENGTH/4) + x(n+3*FFT_LENGTH/4));
            X(4*k + 2) = (x(n) - x(n+FFT_LENGTH/4) + x(n+2*FFT_LENGTH/4) - x(n+3*FFT_LENGTH/4));
            X(4*k + 3) = (x(n) - x(n+FFT_LENGTH/4)*(1i) - x(n+2*FFT_LENGTH/4) + x(n+3*FFT_LENGTH/4)*(1i));
            X(4*k + 4) = (x(n) + x(n+FFT_LENGTH/4)*(1i) - x(n+2*FFT_LENGTH/4) - x(n+3*FFT_LENGTH/4)*(1i));
        end
        x = Q(real(X), 10, DR(1,i+1)) + (1j)*Q(imag(X), 10, DR(2,i+1));
        X=x;
    else
        % Radix-4 butterfly previous stages
        for n = 1:FFT_LENGTH/4
            k = n-1;
            weight = (4^i) * floor(k/(4^i));
            exp2_q = Q(real(exp(-1j*2*pi*2*weight/FFT_LENGTH)), 10, 2)...
                   + (1j)*Q(imag(exp(-1i*2*pi*2*weight/FFT_LENGTH)), 10, 2);
            exp3_q = Q(real(exp(-1j*2*pi*weight/FFT_LENGTH)), 10, 2)...
                   + (1j)*Q(imag(exp(-1i*2*pi*weight/FFT_LENGTH)), 10,2);
            exp4_q = Q(real(exp(-1j*2*pi*3*weight/FFT_LENGTH)), 10, 2)...
                   + (1j)*Q(imag(exp(-1j*2*pi*3*weight/FFT_LENGTH)), 10, 2);
            X(4*k + 1) = (x(n) + x(n+FFT_LENGTH/4) + x(n+2*FFT_LENGTH/4) + x(n+3*FFT_LENGTH/4));
            X(4*k + 2) = (x(n) - x(n+FFT_LENGTH/4) + x(n+2*FFT_LENGTH/4) - x(n+3*FFT_LENGTH/4))*exp(-1i*2*pi*2*weight/FFT_LENGTH);
            X(4*k + 3) = (x(n) - x(n+FFT_LENGTH/4)*(1i) - x(n+2*FFT_LENGTH/4) + x(n+3*FFT_LENGTH/4)*(1i))*exp(-1i*2*pi*weight/FFT_LENGTH);
            X(4*k + 4) = (x(n) + x(n+FFT_LENGTH/4)*(1i) - x(n+2*FFT_LENGTH/4) - x(n+3*FFT_LENGTH/4)*(1i))*exp(-1i*2*pi*3*weight/FFT_LENGTH);
        end
        x = Q(real(X), 10, DR(1,i+1)) + (1j)*Q(imag(X), 10, DR(2,i+1));
    end
end

% Digit reversal
fixed_reversal_X = bitrevorder(X);


%% calculate SQNR
SQNR=10*log10(mean(abs(float_reversal_X).^2)/mean(abs(float_reversal_X-fixed_reversal_X).^2));
disp(['SQNR:',num2str(SQNR)]);

figure(1);
subplot(2,2,1);
plot(fftshift(abs(answer_X)));
title('golden answer');
subplot(2,2,2);
plot(fftshift(abs(float_reversal_X)));
title('radix-4 fft (floating-point)');
subplot(2,2,3);
plot(fftshift(abs(fixed_reversal_X)));
title('radix-4 fft (fixed-point)');

figure(2);
subplot(2,2,1);
plot(real(float_reversal_X));
title('floating-point simulation (real part)');
subplot(2,2,2);
plot(imag(float_reversal_X));
title('floating-point simulation (imag part)');
subplot(2,2,3);
plot(real(fixed_reversal_X));
title('fixed-point simulation (real part)');
subplot(2,2,4);
plot(imag(fixed_reversal_X));
title('fixed-point simulation (imag part)');

figure(3);
histogram(imag(float_reversal_X));
hold on;
histogram(imag(fixed_reversal_X));
legend('origianl','quantized');
title('histogram');

%% Plot 
figure(4);
plot(real(float_reversal_X));
hold on;
plot(real(fixed_reversal_X));
title('Real');
xlim([1 1024]);

figure(5);
plot(imag(float_reversal_X));
hold on;
plot(imag(fixed_reversal_X));
title('Imag');
xlim([1 1024]);

%% Range decision
function range=ddr(x)
    if(real(x)==0)
        range=0;
    else
        range=round(log2(max(abs(real(x)))));
    end
end


%% Quantizer function
function quantized=Q(input, bits, DR)
    step=2*(2^DR)/(2^bits);
    width=(-2^DR:step:2^DR);
    width=width(1:end-1);
    for k=1:length(input)
        if(input(k)==0)
            quantized(k)=0;
        else
            distance=abs(width-input(k));
            [~,idx]=sort(distance);
            quantized(k)=width(idx(1));
        end
    end
end

