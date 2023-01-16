# DCIC-Final-Project
Radix-2 1024-points FFT and Radix-4 1024-points FFT implementation
## Radix-2 FFT
The system architecture is as follows:
![image](https://i.imgur.com/eLbj0ch.jpg)
* How to use?
  * Complie the main.m file in the and it will call the corresponding function
 
* Input data
  * The input data is a rectangular pulse or random sequence with length 1024

## Radix-4 FFT
The system architecture is as follows:
![image](https://i.imgur.com/BCl46Hs.jpg)

The flow chart is as follows:
![image](https://i.imgur.com/RmCO8Ix.jpg)
* How to use?
  * Complie the main.m file in the and it will call the corresponding function
 
* Input data
  * The input data is a rectangular pulse or random sequence with length 1024

## Simulation Results
The FFT results of a rectangular pulse:

![image](https://i.imgur.com/cbKEkvI.jpg)
![image](https://i.imgur.com/idLsyB4.jpg)

The histogram of the fixed-point and the floating-point simulation with differnt quantize level:
![image](https://i.imgur.com/SLlkZPq.jpg)
![image](https://i.imgur.com/KZLzIGp.jpg)


## Performance comparison
1. SQNR comparison:

 |Type|6 bits|8 bits|10 bits|12 bits|
 |---|---|---|---|---|
 |Radix-2 FFT|14.201 dB|19.497 dB|21.194 dB|22.716 dB|
 |Radix-4 FFT|19.042 dB|24.118 dB|39.194 dB|49.113 dB|
 2. Complexity:

 ||Complexity|Multiplier|Adder|
 |---|---|---|---|
 |DFT|$O(N^2)$|$O(N^2)$|$O(N(N-2))$|
 |Radix-2 FFT|$O(Nlog_2 N)$|$O(Nlog_2 N-1)$|$O(Nlog_2 N)$|
 |Radix-4 FFT|$O((3N/2)log_2 N)$|$O((3N/8)log_2 N)$|$O((3N/2)log_2 N)$|

## Case study - An OFDM system apply with the FFT function in this work
We implement an OFDM system which the Rx is apply with our FFT function, the modulation type is BPSK, we compare the BER between the floating-point and fixed-point implementation.
The simulation reaults is as follows:
![image](https://i.imgur.com/PwQ8yHE.png)

## Conclusion
Both radix-2 and radix-4 FFT has its pros and cons. Radix-2 is more flexible for hardware implementation (e.g., pipeline architecture). However, it has more stage than radix-4 FFT, which enhance the quantize noise and thus degrade the performance. Radix-4 FFT has smaller area cost and a lower quantize noise. Nevertheless, the hardware implementation is more restricted. Therefore, it is a tradeoff between choosing radix-2 or radix-4 FFT, both architecture is a good option for different application scenarios.
