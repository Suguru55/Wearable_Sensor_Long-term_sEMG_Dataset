function preprocessing(config)

for sub_ind = 1:config.sub_num     
    % reset config
    cd(config.code_dir)
    config = labeling(config);
    
    % storage for feature vectors and labels
    F = cell(config.day_num, config.trial_num);
    y = cell(config.day_num, config.trial_num);
    
    for day_ind = 1:config.day_num
        for trial_ind = 1:config.trial_num
            y(day_ind,trial_ind) = {config.labels};
            feature_lib = [];
            
            for mov_ind = 1:config.mov_num
                % load data
                eval(sprintf('dir_name=[config.data_dir, ''\\sub%d\\day%d''];',sub_ind,day_ind));    
                cd(dir_name);
                eval(sprintf('filename=[''D%dM%dT%d'',''.csv''];',day_ind,mov_ind,trial_ind));
                input = load(filename);
                
                % feature extraction (TDAR method)
                cd(config.code_dir); 
                feature = extract_feature(input,config.win_size,config.win_inc);
                feature_lib = [feature_lib; feature];
            end
            
            F(day_ind,trial_ind) = {feature_lib'};
        end
    end
    % save features and the labels
    eval(sprintf('dir_name=[config.data_dir, ''\\sub%d''];',sub_ind));
    cd(dir_name)
    eval(sprintf('filename=[''FS%d'',''.mat''];',sub_ind));
    save(filename,'F','y','config')
end

cd(config.code_dir);