% ASK_Tx.m
% Parameters
fs = 200e3;                % Sample rate
fc = 902e6;                % Center frequency
frameLength = 1024;        % Samples per frame
M = 2;                     % Binary ASK
numFrames = 200;           % Number of frames to send

% Generate ASK signal
msg = randi([0 M-1], frameLength, 1);
txSignal = pammod(msg, M);            % Generates -1 and 1
txSignal = single(real(txSignal));    % Ensure real, single type

% Normalize
txSignal = txSignal / max(abs(txSignal));

% Spectrum analyzer to visualize the transmit signal (baseband)
spectrumAnalyzer = dsp.SpectrumAnalyzer( ...
    'SampleRate', fs, ...
    'Title', 'Transmitted ASK Signal Spectrum (Baseband)', ...
    'YLimits', [-120 0]);

% Create transmitter object
txRadio = comm.SDRuTransmitter( ...
    'Platform', 'B2XX', ...
    'SerialNum', '33F8XXX', ...
    'CenterFrequency', fc, ...
    'MasterClockRate', 5e6, ...
    'InterpolationFactor', 25, ...
    'Gain', 25);

disp('Transmitting ASK signal...');

for i = 1:numFrames
    % Update spectrum analyzer
    spectrumAnalyzer(txSignal);
    % Transmit signal
    txRadio(txSignal);
    pause(0.35); % Match RX pacing
end

release(txRadio);
release(spectrumAnalyzer);
disp('Transmission complete.');
