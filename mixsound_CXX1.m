%% generating audio
% carrier: 55,60,65db broadband white noise
% pulse only, gap only, pulse+gap
% filename = 'mixsoundCXX.wav'; 
  % GO, PO and GP play in a random sequence(one block)
  % three trials in one block, block repeats 100 times 
%%
                   
files = ["GO55.wav" "GP55.wav" "PO55.wav";
         "GO60.wav" "GP60.wav" "PO60.wav";
         "GO65.wav" 'GP65.wav' "PO65.wav";
        ];
for i_cond = 1:3                                     %three different carriers
    [soundmagGO,fs] = audioread(files(i_cond,1));
    [soundmagGP,fs] = audioread(files(i_cond,2));
    [soundmagPO,fs] = audioread(files(i_cond,3));
    
    sound_name{1,1} = soundmagGO';
    sound_name{1,2} = soundmagGP';
    sound_name{1,3} = soundmagPO';
%% 

    mixsound = [];
    for rep = 1:100                                  %block repeats 100 times
        i = randperm(3);                             %GO, PO and GP play in a random sequence(one block)
        mixsound_temp = [];
        for seq = 1: size(i,2)
            mixsound_temp = [mixsound_temp,sound_name{1,i(seq)}];
        end
        mixsound = [mixsound,mixsound_temp];
    end
%% 

    if i_cond ==1
        audiowrite("mixsound55.wav",mixsound',fs)   
    elseif i_cond ==2
        audiowrite("mixsound60.wav",mixsound',fs) 
    else
        audiowrite("mixsound65.wav",mixsound',fs)   
    end
end
