clc
clear all;

% Use the MATLAB's Communication Toolbox to simulate the performance of
% 16QAM over Gaussian Channel


% Modulation order
M = 16;
% Number of bits per symbol
k = log2(M);
% Number of bits per iteration
nBits = 30000;
% Range for EbN0
EbN0 = 0:10;
BER_16QAM_Sim = zeros(1,length(EbN0));
BER_16QAM_Theory = zeros(1,length(EbN0));


count = 1;

% === Simulation
for ebN0 = EbN0

    lengthOfTransmission = 0;
    nErrors = 0;
    
    % Convert Eb/N0(dB) to SNR(dB)
    snr = ebN0 + 10*log10(k);

    while lengthOfTransmission < 1e6 || nErrors < 100

        % --- Source
        bits = randi([0 1], nBits, 1);
        
        % --- Symbols
        symbols  = qammod(bits, M,'InputType','bit');
        
        % --- Channel
        y = awgn(symbols, snr, 'measured');

        % --- Receiver
        % Perform hard decision and measure errors
        bitsHat = qamdemod(y, M,'OutputType','bit');
        
        % Compute the number of errors
        [numErrors,~] = biterr(bits,bitsHat);
        
        nErrors = nErrors + numErrors;
        lengthOfTransmission = lengthOfTransmission + nBits;


    end

    BER_16QAM_Sim(count) = nErrors/lengthOfTransmission;
    BER_16QAM_Theory(count) = berawgn(ebN0, 'qam', M, 1);
    count = count + 1;
    
end


% === Plot results
figure()
semilogy(EbN0,BER_16QAM_Theory,'r--','LineWidth',2);
hold on;
semilogy(EbN0,BER_16QAM_Sim,'ko-','LineWidth',1);
grid on
legend('Theory','Simulation');
title('BER vs Eb/N0 for 16QAM modulation')
ylabel('BER');
xlabel('Eb/N0(dB)');

