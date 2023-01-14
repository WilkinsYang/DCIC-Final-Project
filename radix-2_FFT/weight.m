%% weight of fft
function w=weight(index, basis)
k=mod(index,basis/2);
w=exp(-1j*2*pi*k/basis);
end