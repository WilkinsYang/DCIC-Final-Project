%% fixed-point
function FFT_fixed=FFT2(x,stage,fft_points,DR_total)
group=fft_points/2;
DR1_real=DR_total(1,:);
DR1_imag=DR_total(2,:);
DR2_real=DR_total(3,:);
DR2_imag=DR_total(4,:);
y_1=x;
for k=1:stage
    disp(['stage:',num2str(k)]);
    base=2^k;
    temp_1=y_1;
    half=2^(k-1);
    for n=0:fft_points-1
        if(mod(n,base)>=(base/2))
            weight_q=Q(real(weight(n,base)),10,2)+1j*Q(imag(weight(n,base)),10,2);
            temp_1(n+1)=weight_q*y_1(n+1);
        else
            temp_1(n+1)=temp_1(n+1);
        end
    end
   
    %quantized first part
    temp_q=Q(real(temp_1),10,DR1_real(k))+1j*Q(imag(temp_1),10,DR1_imag(k));

   for n=1:group
      for g=1:half
        y_1(base*(n-1)+g)=temp_q(base*(n-1)+g)+temp_q(base*(n-1)+g+half);         
        y_1(base*(n-1)+g+half)=-temp_q(base*(n-1)+g+half)+temp_q(base*(n-1)+g);
      end
   end
   x=Q(real(y_1),10,DR2_real(k))+1j*Q(imag(y_1),10,DR2_imag(k));
   y_1=x;
   
   group=group/2;
end
FFT_fixed=x;
end