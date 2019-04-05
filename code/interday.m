function [inc, fix] = interday(config)

for sub_ind = 1:config.sub_num
    % load data
    eval(sprintf('dir_name=[config.data_dir, ''\\sub%d''];',sub_ind));
    cd(dir_name);
    
    eval(sprintf('filename=[''FS%d'',''.mat''];',sub_ind));
    load(filename);
    
    cd(config.code_dir)
    % prepare storages for results
    y_lib = [];    
    pred_inc_n_lib = cell(config.day_num,config.trial_num,config.model_num);
    pred_fix_n_lib = cell(config.day_num,config.trial_num,config.model_num);
    pred_inc_i_lib = cell(config.day_num,config.trial_num,config.model_num);
    pred_fix_i_lib = cell(config.day_num,config.trial_num,config.model_num);
    pred_inc_o_lib = cell(config.day_num,config.trial_num,config.model_num);
    pred_fix_o_lib = cell(config.day_num,config.trial_num,config.model_num);    
    
    error_inc_n_lib = cell(1,config.day_num); error_fix_n_lib = cell(1,config.day_num);
    confusion_inc_n_lib = cell(config.day_num,config.trial_num,config.model_num);
    confusion_fix_n_lib = cell(config.day_num,config.trial_num,config.model_num);
    error_inc_i_lib = cell(1,config.day_num); error_fix_i_lib = cell(1,config.day_num);
    confusion_inc_i_lib = cell(config.day_num,config.trial_num,config.model_num);
    confusion_fix_i_lib = cell(config.day_num,config.trial_num,config.model_num);
    error_inc_o_lib = cell(1,config.day_num); error_fix_o_lib = cell(1,config.day_num);
    confusion_inc_o_lib = cell(config.day_num,config.trial_num,config.model_num);
    confusion_fix_o_lib = cell(config.day_num,config.trial_num,config.model_num);    

    for day_ind = 1:config.day_num
        if day_ind == 1
            % store training data from n position
            tr_n_F = []; tr_n_y = [];
 
            for cv_ind = 1:config.trial_num
                temp_F = F{day_ind,cv_ind};
                temp_y = y{day_ind,cv_ind};
                    
                re_y = repelem(temp_y,config.win_num,1);
                    
                tr_n_F = [tr_n_F; temp_F'];
                tr_n_y = [tr_n_y; re_y];
            end
            
            tr_n_F_1st = tr_n_F;
            tr_n_y_1st = tr_n_y;
        else
            if day_ind == 2
                % classificaition
                % n pos.
                [error_inc_n_lib{day_ind}, error_fix_n_lib{day_ind},confusion_inc_n_lib,confusion_fix_n_lib,pred_inc_n_lib,pred_fix_n_lib] = ...
                    interday_recog(config,day_ind,y,F,tr_n_y_1st,tr_n_F_1st,tr_n_y,tr_n_F,confusion_inc_n_lib,confusion_fix_n_lib,pred_inc_n_lib,pred_fix_n_lib);
                
                % store training data from i position
                tr_i_F = []; tr_i_y = [];
 
                for cv_ind = 1:config.trial_num
                    temp_F = F{day_ind,cv_ind};
                    temp_y = y{day_ind,cv_ind};
                    
                    re_y = repelem(temp_y,config.win_num,1);
                    
                    tr_n_F = [tr_n_F; temp_F'];
                    tr_n_y = [tr_n_y; re_y];
                    
                    tr_i_F = [tr_i_F; temp_F'];
                    tr_i_y = [tr_i_y; re_y];
                end
                
                tr_i_F_1st = tr_i_F;
                tr_i_y_1st = tr_i_y;
            else
                if day_ind == 3 
                    % classificaition
                    % n pos.
                    [error_inc_n_lib{day_ind}, error_fix_n_lib{day_ind},confusion_inc_n_lib,confusion_fix_n_lib,pred_inc_n_lib,pred_fix_n_lib] = ...
                        interday_recog(config,day_ind,y,F,tr_n_y_1st,tr_n_F_1st,tr_n_y,tr_n_F,confusion_inc_n_lib,confusion_fix_n_lib,pred_inc_n_lib,pred_fix_n_lib);
                    
                    % i pos.
                    [error_inc_i_lib{day_ind}, error_fix_i_lib{day_ind},confusion_inc_i_lib,confusion_fix_i_lib,pred_inc_i_lib,pred_fix_i_lib] = ...
                        interday_recog(config,day_ind,y,F,tr_i_y_1st,tr_i_F_1st,tr_i_y,tr_i_F,confusion_inc_i_lib,confusion_fix_i_lib,pred_inc_i_lib,pred_fix_i_lib);
                
                    % store training data from o position
                    tr_o_F = []; tr_o_y = [];
 
                    for cv_ind = 1:config.trial_num
                        temp_F = F{day_ind,cv_ind};
                        temp_y = y{day_ind,cv_ind};
                    
                        re_y = repelem(temp_y,config.win_num,1);
                    
                        tr_n_F = [tr_n_F; temp_F'];
                        tr_n_y = [tr_n_y; re_y];
                    
                        tr_i_F = [tr_i_F; temp_F'];
                        tr_i_y = [tr_i_y; re_y];
                        
                        tr_o_F = [tr_o_F; temp_F'];
                        tr_o_y = [tr_o_y; re_y];                       
                    end
                    
                    tr_o_F_1st = tr_o_F;
                    tr_o_y_1st = tr_o_y; 
                else
                    % classificaition
                    % n pos.
                    [error_inc_n_lib{day_ind}, error_fix_n_lib{day_ind},confusion_inc_n_lib,confusion_fix_n_lib,pred_inc_n_lib,pred_fix_n_lib] = ...
                        interday_recog(config,day_ind,y,F,tr_n_y_1st,tr_n_F_1st,tr_n_y,tr_n_F,confusion_inc_n_lib,confusion_fix_n_lib,pred_inc_n_lib,pred_fix_n_lib);
                    
                    % i pos.
                    [error_inc_i_lib{day_ind}, error_fix_i_lib{day_ind},confusion_inc_i_lib,confusion_fix_i_lib,pred_inc_i_lib,pred_fix_i_lib] = ...
                        interday_recog(config,day_ind,y,F,tr_i_y_1st,tr_i_F_1st,tr_i_y,tr_i_F,confusion_inc_i_lib,confusion_fix_i_lib,pred_inc_i_lib,pred_fix_i_lib);
                
                    % o pos.
                    [error_inc_o_lib{day_ind}, error_fix_o_lib{day_ind},confusion_inc_o_lib,confusion_fix_o_lib,pred_inc_o_lib,pred_fix_o_lib] = ...
                        interday_recog(config,day_ind,y,F,tr_o_y_1st,tr_o_F_1st,tr_o_y,tr_o_F,confusion_inc_o_lib,confusion_fix_o_lib,pred_inc_o_lib,pred_fix_o_lib);
                
                    for cv_ind = 1:config.trial_num
                        temp_F = F{day_ind,cv_ind};
                        temp_y = y{day_ind,cv_ind};
                    
                        re_y = repelem(temp_y,config.win_num,1);
                    
                        tr_n_F = [tr_n_F; temp_F'];
                        tr_n_y = [tr_n_y; re_y];
                    
                        tr_i_F = [tr_i_F; temp_F'];
                        tr_i_y = [tr_i_y; re_y];
                        
                        tr_o_F = [tr_o_F; temp_F'];
                        tr_o_y = [tr_o_y; re_y];                       
                    end
                end
            end
        end
    end
    cd(config.save_dir);
    eval(sprintf('filename=[''DaytoDay_S%d'',''.mat''];',sub_ind));
    save(filename,'pred_inc_n_lib','pred_fix_n_lib','pred_inc_i_lib','pred_fix_i_lib','pred_inc_o_lib','pred_fix_o_lib',...
        'y_lib','error_inc_n_lib','error_fix_n_lib','error_inc_i_lib','error_fix_i_lib','error_inc_o_lib','error_fix_o_lib',...
        'confusion_inc_n_lib','confusion_fix_n_lib','confusion_inc_i_lib','confusion_fix_i_lib','confusion_inc_o_lib','confusion_fix_o_lib');
end
cd(config.code_dir);

% visualization
[inc, fix] = plot_figure6(config);