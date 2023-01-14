%% Quantizer function
function quantized=Q(input, bits, DR)
step=2*(2^DR)/(2^bits);
width=[-2^DR:step:2^DR];
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