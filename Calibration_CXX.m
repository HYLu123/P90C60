%% generating loud test audio
%  baseline(carrier level) duration 15s, pulse duration 15s
%  3 carrier level, 55 60 65dB broadband white noise 
%  filename = 'P90_CXX_ltestbbn.wav'
 
fs = 44100;                            %Hz, broadband frequency 
lowpf = 18000;                         %Hz, Lowpass filter cutoff

predur   = 15;                         %sec, pre-duration
pulsedur = 15;                         %sec, pulse-duration
totdur   = 30;                         %sec, total duration

pulselvl = 90;                         %dB, level of startle pulse
callvl = 90;                           %dB, level of calibration
pulsediff = db2mag(pulselvl-callvl);   

bkglvl = [ 55 60 65 ] ;                %dB, level of carrier noise


for i_cond = 1:3                                         %different carrier level
    bkgdiff = db2mag(bkglvl(i_cond)-callvl); 

    pre   = ones(1, round(predur*fs)) .* bkgdiff;        %duration and level of pre pulse window
    pulse = ones(1, round(pulsedur*fs)) .* pulsediff;    %duration and level of pulse window
    
    window = [pre pulse];                                %total window
       
    n = rand(1, length(window));                         %create rand vector of same length as window
    n = (n - 0.5) * 2;                                   %shift vector to center on zero
    
    n_lp = lowpass(n, lowpf, fs);                        %lowpass filter of noise
    n_lp = n_lp/max(abs(n_lp(:)));                


    soundmag(1,:) = n_lp.*window;
    
    
    soundmag20 = [];                                    %same trial repeats 20 times
    for rep = 1:20
        soundmag20 = [soundmag20,soundmag];
    end


    if i_cond ==1 
        audiowrite("P90_C55_ltestbbn.wav",soundmag',fs);
    elseif i_cond ==2
        audiowrite("P90_C60_ltestbbn.wav",soundmag',fs);
    else
        audiowrite("P90_C65_ltestbbn.wav",soundmag',fs);
    end
end 
