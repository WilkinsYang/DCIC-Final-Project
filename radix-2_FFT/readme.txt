This folder is construct by several files, the structure is as follows:
_main.m
_FFT1.m (the radix-2 floating-point FFT)
_FFT2.m (the radix-2 fixed-point FFT)
_Q.m    (the quantize module for fixed-point implementation)
_ddr.m  (a module used to decide the quantization range)
_scambler.m (a module used to re-order the input data's index)
_weight.m (the module generate the weight of the FFT calculation)
_OFDM.m   (A OFDM system that apply the FFT1.m and FFT2.m function)


