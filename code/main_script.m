%% Main script
%  "Are armband sEMG devices dense enough for long-term use?--Sensor placement
%   shifts cause significant reduction in recognition accuracy" [1]
%
% Dataset (DxxMxxTx.csv)
%  A 22-motion dataset including three types of electrode positions (N, I, O) recorded from 5 subjects for 30 days.
%  The stimuli were visualized by Myo SDK 0.9.0 [2] and Unity
%   - # of channels (ch_num)                : 8 electrodes were used as input to the analysis
%   - # of trials (trial_num)               : 4 
%   - # of motions (mov_num)                : 22
%   - Data length of epochs (process_dur)   : 1.5 seconds (the onset points were detected by sample entropy)
%   - Sampleing rate (fs)                   : 200 Hz
%
% Features (FSx.mat)
%  Obtained from TDAR method [3]
%   - Dimention of feature                  : 11 per channel
%   - Window size (win_size)                : 250 ms
%   - Shifting size of the window (win_inc) : 50 ms
%
% Classifier: LDA
%
% See also:
%   - set_config
%   - preprocessing
%       - extract_feature
%          - getrmsfeat
%          - getmavfeat
%          - getzcfeat
%          - getsscfeat
%          - getwlfeat
%          - getarfeat
%    - intraday
%       - plot_firegu6_and_figure7
%    - interday
%       - labeling
%       - interday_recog
%       - plot_figure8
%    - interday_sub
%       - plot_figure9
%
% References:
%  [1] S. Kanoga, A. Kanemura, H. Asoh,"Are armband sEMG devices dense enough for 
%      long-term use?--Sensor placement shifts cause significant reduction 
%      in recognition accuracy," Biomedical signal processing and control, 
%      vol. , no. , pp. , 2020.
%  [2] https://developer.staging.thalmic.com/docs/api_reference/platform/the-sdk.html
%  [3] Y. Huang et al., ÅgA Gaussian Mixture Model Based Classification Scheme
%      for Myoelectric Control of Powered Upper Limb Prostheses,Åh IEEE Trans.
%      Biomed. Eng., vol. 52, no. 11, pp. 1801-1811, Nov. 2005.
%
% Suguru Kanoga, 19-April-2020
% Artificial Intelligence Research Center, National Institute of Advanced
% Industrial Science and Technology (AIST)
% E-mail: s.kanouga@aist.go.jp

% Caliculation time: About 2 hours (using laptop PC)

%% Clear workspace and add path for loading data
clear all
close all
% clc

% addpath data
%help main_script

%% Set config 
config = set_config;

%% Pre-processing
% prepares feature vectors F and labels y
% !! before using this function, you should download getxxxxx.m files 
% from http://www.sce.carleton.ca/faculty/chan/index.php?page=matlab
preprocessing(config);

% we will use only FSx.mat (about 40 MB each) from next section
% once you made the mat files, you can skip this section

%% Main stream (classificaition in each day)
% the number of testing trials is always one 
% but the number of training trials is changeable from 1 to config.trial_num-1 
[tbl, c_intra] = intraday(config); % 2-way ANOVA for the number of trials and electrode placements

%% Main stream (classification over all days)
% check recognition performances under the following conditions with each sensor position
% i) increment training data after evaluation
% ii) use only 1 day data as training data
[inc, fix] = interday(config);

%% Sub stream
% incremental-training-data setting with same electrode positions
[inc_same, fix_same] = interday_sub(config);