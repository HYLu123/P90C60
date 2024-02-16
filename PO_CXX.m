%% generating audio
% carrier: 55,60,65db broadband white noise
% startle pulse only
% startle pulse 90db
% filename = 'POXX.wav'

fs = 44100;                               %broadband frequency
lowpf = 18000;                            %lowpass filter cutoff frequency

predur = 0.750+0.002+0.050+0.002+0.240;   %sec, pre-duration
pulsedur = 0.020;                         %sec, instantaneous rise and fall 
postdur = 2;                              %sec, post-duration

callvl    = 90;                           %dB, level of calibration      
pulselvl  = 90;                           %dB, level of startle pulse
pulsediff = db2mag(pulselvl-callvl);      %calibrating based on callvl
bkglvl0   = [55 60 65];                   %dB, level of carrier noise
trig_value = 0.9;                         %trigger value for PO 

for i_cond = 1:3                                         %three different carriers
    bkglvl = bkglvl0(i_cond);                            %dB, level of carrier noise
    bkgdiff = db2mag(bkglvl-callvl);                     %calibrating based on callvl

    pre   = ones(1, round(predur*fs)) .* bkgdiff;        %duration and level of prestim window
    pulse = ones(1, round(pulsedur*fs)) .* pulsediff;    %duration and level of pulse window
    post  = ones(1, round(postdur*fs)) .* bkgdiff;       %duration and level of poststim window

    window = [pre pulse post];                           %total window
    
    n = rand(1, length(window));                         %create rand vector of same length as window
    n = (n - 0.5) * 2;                                   %shift vector to center on zero
    % lowpass filter
    n_lp = lowpass(n, lowpf, fs);                        %LP filter of noise
    n_lp = n_lp/max(abs(n_lp(:)));                       %limit to 0 +/- 1 range by dividing signal by max()
                                                         %otherwise LP-filter introduces clipping
    
    %% add trigger
    trig_p   = [predur*fs+1,(predur+pulsedur)*fs];       %trigger index for the startle pulse

    soundmag(1,:) = n_lp.*window;
    soundmag(2,:) = zeros(1,length(soundmag));
   
    soundmag(2,ceil(trig_p(1)):ceil(mean(trig_p)))   = trig_value;       %add pulse trigger
    soundmag(2,ceil(mean(trig_p))+1:floor(trig_p(2))) = - trig_value;
    if i_cond ==1
       audiowrite("PO55.wav",soundmag',fs)   
    elseif i_cond ==2
       audiowrite("PO60.wav",soundmag',fs)   
    else
       audiowrite("PO65.wav",soundmag',fs)   
    end
end
