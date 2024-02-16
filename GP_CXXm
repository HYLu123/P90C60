%% generating audio
% carrier: 55,60,65db broadband white noise
% gap + pulse
% startle pulse 90db
% filename = 'GPXX.wav'

fs = 44100;                         %broadband frequency
lowpf = 18000;                      %lowpass filter cutoff frequency

predur    = 0.750;                   %sec, pre-duration
fallt     = 0.002;                   %sec, fall-time before gap
gapdur    = 0.050;                   %sec, gap duration
riset     = 0.002;                   %sec, rise-time after gap
ISIt      = 0.240;                   %sec, Inter-stimulus interval, 
pulsedur  = 0.020;                   %sec, instantaneous rise and fall 
postdur   = 2.000;                   %sec, post-duration

callvl    = 90;                      %dB, level of calibration      
pulselvl  = 90;                      %dB, level of startle pulse
pulsediff = db2mag(pulselvl-callvl); %calibrating based on callvl
bkglvl0   = [55 60 65];              %dB, level of carrier noise

trig_value = [0.5 0.7];              %trigger value for GP [gap pulse]

for i_cond = 1:3                                         %three different carriers
    bkglvl = bkglvl0(i_cond);                            %dB, level of carrier noise
    bkgdiff = db2mag(bkglvl-callvl);                     %calibrating based on callvl

    pre   = ones(1, round(predur*fs)) .* bkgdiff;        %duration and level of prestim window
    gap   = zeros(1, round(gapdur*fs));                  %duration and level of gap window
    pulse = ones(1, round(pulsedur*fs)) .* pulsediff;    %duration and level of pulse window
    ISI   = ones(1, round(ISIt*fs)) .* bkgdiff;          %duration and level of ISI
    post  = ones(1, round(postdur*fs)) .* bkgdiff;       %duration and level of poststim window

    %gap fall/rise period 
    %fall
    rffreq = 1/(fallt * 2);                              %frequency that has period of 2 fallt
    dt = 1/fs;                                           %second, time per sample
    t = (0:dt:fallt);                                    %vector for rise/fall

    %general sine is = Amplitude * sin(2*pi*f*t + phase) + Amp shift
    %fall-window of duration fallt with t samples:
    fall = (0.5*bkgdiff) * sin(2*pi*rffreq*t + pi/2) + 0.5*bkgdiff;    %fall window
       
    % rise
    rffreq = 1/(riset * 2);                              %frequency that has period of 2 riset
    dt = 1/fs;                                           %second per sample
    t = (0:dt:riset);                                    %vector for rise/fall
    rise = (0.5*bkgdiff) * sin(2*pi*rffreq*t + pi/2) + 0.5*bkgdiff;     %fall window
    rise = flip(rise);                                   %rise window

    window = [pre fall gap rise ISI pulse post];         %total window
    
    n = rand(1, length(window));                         %create rand vector of same length as window
    n = (n - 0.5) * 2;                                   %shift vector to center on zero
    % lowpass filter
    n_lp = lowpass(n, lowpf, fs);                        %LP filter of noise
    n_lp = n_lp/max(abs(n_lp(:)));                       %limit to 0 +/- 1 range by dividing signal by max()
                                                         %otherwise LP-filter introduces clipping
    
    %% add trigger
    trig_gap = [predur*fs+1,(predur+fallt+gapdur+riset)*fs]; %trigger index for the gap
    trig_p   = [(predur+fallt+gapdur+riset+ISIt)*fs+1,(predur+fallt+gapdur+riset+ISIt+pulsedur)*fs]; 
                                                             %trigger index for the startle pulse
    soundmag(1,:) = n_lp.*window;
    soundmag(2,:) = zeros(1,length(soundmag));
    
    soundmag(2,ceil(trig_gap(1)):ceil(mean(trig_gap))) = trig_value(1);      %add gap trigger
    soundmag(2,ceil(mean(trig_gap))+1:floor(trig_gap(2)))= - trig_value(1);

    soundmag(2,ceil(trig_p(1)):ceil(mean(trig_p)))   = trig_value(2);       %add pulse trigger
    soundmag(2,ceil(mean(trig_p))+1:floor(trig_p(2))) = - trig_value(2);
    if i_cond ==1
       audiowrite("GP55.wav",soundmag',fs)   
    elseif i_cond ==2
       audiowrite("GP60.wav",soundmag',fs)   
    else
       audiowrite("GP65.wav",soundmag',fs)   
    end
end
