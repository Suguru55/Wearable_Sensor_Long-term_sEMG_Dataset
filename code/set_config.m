function struct = set_config

% dir(change your directory)
struct.data_dir = 'C:\Users\3usgr\Desktop\Wearable_Sensor_Long-term_sEMG_Dataset-master\data';
struct.code_dir = 'C:\Users\3usgr\Desktop\Wearable_Sensor_Long-term_sEMG_Dataset-master\code';
struct.save_dir = 'C:\Users\3usgr\Desktop\Wearable_Sensor_Long-term_sEMG_Dataset-master\results';

% parameters
struct.pos = ['N'; 'I'; 'O'; 'N'; 'I'; 'I'; 'O'; 'O'; 'N'; 'N';...  % 1-10th day 
              'O'; 'N'; 'N'; 'O'; 'O'; 'I'; 'I'; 'I'; 'N'; 'O';...  % 11-20th day
              'O'; 'I'; 'O'; 'I'; 'I'; 'N'; 'N'; 'I'; 'N'; 'O'];    % 21-30th day

struct.pos_label = [1; 2; 3; 1; 2; 2; 3; 3; 1; 1;...
                    3; 1; 1; 3; 3; 2; 2; 2; 1; 3;...
                    3; 2; 3; 2; 2; 1; 1; 2; 1; 3]; % N: 1, I: 2, O: 3
   
struct.day_num = 30;
struct.sub_num = 1;
struct.mov_num = 22;
struct.fs = 200;
struct.process_dur = 1.5;         % analysis window (1.5 s)
struct.ch_num = 8;
struct.trial_num = 4;

struct.fs_pass = 15;
struct.fil_order = 5;

struct.dim = 2;                   % dimension for modified sample entropy
struct.samp_win = 8;              % window size for modified sample entropy (40 ms)
struct.samp_th = 0.4;             % threshold for normalized samp_en
struct.trial_dur = 6;             % 1 trial needs 6 s

struct.win_size = 50;             % 250ms window
struct.win_inc = 10;              % 50ms overlap
struct.win_num = 26;              % the number of features per trial
struct.model_num = 5;

struct.k = [2,3,3,3,2];           % binary classification for models 1 and 5
                                  % 3-class classification for models 2-4