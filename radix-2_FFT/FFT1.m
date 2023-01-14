%% radix-2 FFT (floating point)
function [FFT_float,DR_total]=FFT1(x,stage,fft_points)
DR1_real=zeros(1,stage); %register used to save the range 
DR1_imag=zeros(1,stage);
DR2_real=zeros(1,stage);
DR2_imag=zeros(1,stage);
group=fft_points/2;
for k=1:stage
    disp(['stage:',num2str(k)]);
    base=2^k;
    temp=x;
    half=2^(k-1);
    for n=0:fft_points-1
        if(mod(n,base)>=(base/2))
            temp(n+1)=weight(n,base)*x(n+1);
           
        else
            temp(n+1)=temp(n+1);
        end
    end
    disp(['First part.',' (max,min):',num2str(max(abs(temp))), ',',num2str(min(abs(temp)))]);
    DR1_real(k)=ddr(real(temp));
    DR1_imag(k)=ddr(imag(temp));
   for n=1:group
      for g=1:half
        x(base*(n-1)+g)=temp(base*(n-1)+g)+temp(base*(n-1)+g+half);         
        x(base*(n-1)+g+half)=-temp(base*(n-1)+g+half)+temp(base*(n-1)+g);
      end
   end
   disp(['Second part.',' (max,min):',num2str(max(abs(x))), ',',num2str(min(abs(x)))]);
   DR2_real(k)=ddr(real(x));
   DR2_imag(k)=ddr(imag(x));
   group=group/2;
end
FFT_float=x;
DR_total=[DR1_real;DR1_imag;DR2_real;DR2_imag];
end