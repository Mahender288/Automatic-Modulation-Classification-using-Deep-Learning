%% =========================
% ASK Dataset Generation

fs = 200e3;                  % Sampling frequency
M = 2;                       % 2-ASK (2 levels)
numFrames = 1000;            % Number of frames
spf = 1024;                  % Samples per frame
samplesPerSymbol = 8;        
txFilter = rcosdesign(0.35, 4, samplesPerSymbol);

% Create directory to store data
dataDirectory = "modClassASKData";
if ~exist(dataDirectory, "dir")
    mkdir(dataDirectory);
else
    warning("Directory already exists: %s", dataDirectory);
end

% Preallocate arrays
askFrames = zeros(spf, numFrames);        
askLabels = repmat("ASK", numFrames, 1);  

for k = 1:numFrames
    % Random bits
    bits = randi([0 M-1], spf/samplesPerSymbol, 1);
    symbols = 2*bits - 1;  % Map bits to ASK symbols
    
    % Upsample and filter
    txSignal = upsample(symbols, samplesPerSymbol);
    txSignal = filter(txFilter, 1, txSignal);
    txSignal = txSignal(1:spf); % Truncate
    
    % Normalize and cast to complex
    txSignal = txSignal / max(abs(txSignal));
    frame = complex(txSignal, zeros(size(txSignal))); 
    
    % Save for training
    askFrames(:,k) = frame;
    
    % Save to file
    label = "ASK";
    fileName = sprintf("frameASK%03d.mat", k);
    save(fullfile(dataDirectory, fileName), "frame", "label");
end

% DSB-AM Dataset Generation

fs = 200e3;                  % Sampling frequency
numFrames = 1000;            % Number of frames
spf = 1024;                  % Samples per frame
samplesPerSymbol = 8;
txFilter = rcosdesign(0.35, 4, samplesPerSymbol);

% Create directory
dataDirectory = "modClassDSBAMData";
if ~exist(dataDirectory, "dir")
    mkdir(dataDirectory);
else
    warning("Directory already exists: %s", dataDirectory);
end

% Preallocate arrays
dsbamFrames = zeros(spf, numFrames);
dsbamLabels = repmat("DSB-AM", numFrames, 1);

fc = 20e3;                   % Carrier frequency for DSB-AM
t = (0:spf-1)' / fs;

for k = 1:numFrames
    % Random bits → baseband message signal
    bits = randi([0 1], spf/samplesPerSymbol, 1);
    symbols = 2*bits - 1;
    
    % Upsample and filter
    msgSignal = upsample(symbols, samplesPerSymbol);
    msgSignal = filter(txFilter, 1, msgSignal);
    msgSignal = msgSignal(1:spf); % Truncate
    
    % Normalize
    msgSignal = msgSignal / max(abs(msgSignal));
    
    % DSB-AM: s(t) = (1 + m(t)) * cos(2πf_ct)
    carrier = cos(2*pi*fc*t);
    txSignal = (1 + msgSignal) .* carrier;
    
    % Normalize and cast to complex
    txSignal = txSignal / max(abs(txSignal));
    frame = complex(txSignal, zeros(size(txSignal)));
    
    % Save
    dsbamFrames(:,k) = frame;
    label = "DSB-AM";
    fileName = sprintf("frameDSBAM%03d.mat", k);
    save(fullfile(dataDirectory, fileName), "frame", "label");
end
