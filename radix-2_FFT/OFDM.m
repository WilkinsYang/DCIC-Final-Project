%% case study OFDM system 
function OFDM(fft_points,stage,iteration)
fs=2.5*10^9; %bandwidth (symbol rate)
fc=60*10^9; %carrier frequency
SNR=[0:1:25];
BER=zeros(2,length(SNR));
error_bit=zeros(2,length(SNR));
sequence=zeros(1,fft_points);
y_sequence=zeros(1,fft_points);
yq_sequence=zeros(1,fft_points);
dr1=zeros(2,2);
% OFDM system
tic;
for k=1:length(SNR)
    error=zeros(1,2);
    for iter=1:iteration
        %rx
        sequence=2*randi([0,1],1,fft_points)-1;
        % IFFT
        x=ifft(sequence);
        %ideal DAC
        L=100;
        upsample=zeros(1,L*length(x));
        upsample(1:L:end)=x;
        practical_DAC=conv(upsample,ones(1,L),'same');
        %upconversion
        fdc=fc/(L*fs);
        w_c=2*pi*fdc;
        m=(1:length(upsample));
        upconversion=practical_DAC.*exp(j*w_c*m);

        % awgn channel
        signal_power=mean(abs(upconversion).^2);
        noise_power=signal_power*10^(-SNR(k)/10);
        noise=sqrt(noise_power)*(randn(1,length(upconversion))+1j*randn(1,length(upconversion)));
        rx=upconversion+noise;
        %Tx
        %downconversion
        downconversion=rx.*exp(-j*w_c*m);
        dr1(1,1)=ddr(real(downconversion));
        dr1(1,2)=ddr(imag(downconversion));
        downconversion_q=Q(real(downconversion),8,dr1(1,1))+1j*Q(imag(downconversion),8,dr1(1,2));
        %downsampling
        downsample=downconversion(1:L:end);
        dr1(2,1)=ddr(real(downsample));
        dr1(2,2)=ddr(imag(downsample));
        downsample_q=downconversion_q(1:L:end);
        downsample=scrambler(downsample,stage);
        [y,dr2]=FFT1(downsample,stage,fft_points);
        %decision
        for t=1:length(y)
           if(real(y(t))>=0)
               y_sequence(t)=1;
           elseif(real(y(t))<0)
               y_sequence(t)=-1;
           end
        end
        error(1)=error(1)+sum(sequence~=y_sequence);
        downsample_q=scrambler(downsample_q,stage);
        y_q=FFT2((downsample_q),stage,fft_points,dr2);
        for t=1:length(y_q)
           if(real(y_q(t))>=0)
               yq_sequence(t)=1;
           elseif(real(y_q(t))<0)
               yq_sequence(t)=-1;
           end
        end      
        error(2)=error(2)+sum(sequence~=yq_sequence);
        disp(['SNR:',num2str(k),'    iteration:',num2str(iter)]);
    end
    error_bit(:,k)=error';
end
BER=error_bit/(fft_points*iteration);
toc;
%% results
figure(5);
semilogy(SNR,BER(1,:));
hold on;
semilogy(SNR, BER(2,:));
grid on;
xlabel('SNR (dB)');
ylabel('BER (dB)');
title('Radix-2 FFT BER v.s SNR');
legend('floating-point','fixed-point');


figure(6);
subplot(2,1,1);
stem(sequence);
hold on;
stem(y_sequence);
stem(yq_sequence);
hold on;
xlabel('index');
legend('origianl','floating-point','fixed-point');

end