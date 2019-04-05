function [inc_same, fix_same] = interday_sub(config)

for sub_ind = 1:config.sub_num
    % load data
    eval(sprintf('dir_name=[config.data_dir, ''\\sub%d''];',sub_ind));
    cd(dir_name);
    
    eval(sprintf('filename=[''FS%d'',''.mat''];',sub_ind));
    load(filename);
    
    % prepare storages for results
    y_n_lib = []; y_i_lib = []; y_o_lib = [];
    pred_inc_n_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    pred_inc_i_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    pred_inc_o_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    pred_fix_n_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    pred_fix_i_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    pred_fix_o_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    error_inc_n_lib = cell(1,config.day_num/3);
    error_inc_i_lib = cell(1,config.day_num/3);
    error_inc_o_lib = cell(1,config.day_num/3);
    error_fix_n_lib = cell(1,config.day_num/3);
    error_fix_i_lib = cell(1,config.day_num/3);
    error_fix_o_lib = cell(1,config.day_num/3);
    confusion_inc_n_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    confusion_inc_i_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    confusion_inc_o_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    confusion_fix_n_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    confusion_fix_i_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    confusion_fix_o_lib = cell(config.day_num/3,config.trial_num,config.model_num);
    
    n_count = 1; i_count = 1; o_count = 1;
    
    for day_ind = 1:config.day_num
        if day_ind <= 3
            % store training data
            tr_F = []; tr_y = [];
 
            for cv_ind = 1:config.trial_num
                temp_F = F{day_ind,cv_ind};
                temp_y = y{day_ind,cv_ind};
                    
                re_y = repelem(temp_y,config.win_num,1);
                    
                tr_F = [tr_F; temp_F'];
                tr_y = [tr_y; re_y];
            end
            
            if config.pos_label(day_ind) == 1
                 tr_F_n = tr_F;
                 tr_y_n = tr_y;
                 
                 tr_F_1st_n = tr_F;
                 tr_y_1st_n = tr_y;
            else
                if config.pos_label(day_ind) == 2
                    tr_F_i = tr_F;
                    tr_y_i = tr_y;
                    
                    tr_F_1st_i = tr_F;
                    tr_y_1st_i = tr_y;
                else
                    tr_F_o = tr_F;
                    tr_y_o = tr_y;
                    
                    tr_F_1st_o = tr_F;
                    tr_y_1st_o = tr_y;
                end
            end
        else
            % evaluate the recognition performance on a target day
            error_inc = zeros(config.trial_num,size(tr_y,2));
            error_fix = zeros(config.trial_num,size(tr_y,2));
            F_lib = []; y_lib = [];
            
            if config.pos_label(day_ind) == 1
                for cv_ind = 1:config.trial_num
                    te_F = F{day_ind,cv_ind}';
                
                    te_y = y{day_ind,cv_ind};
                    te_y = repelem(te_y,config.win_num,1);
                
                    % construct LDA classifiers and valid their performances
                    for model_ind = 1:config.model_num
                        tr_labels = tr_y_n(:,model_ind);
                        tr_labels_1st = tr_y_1st_n(:,model_ind);
                     
                        tr_data = tr_F_n;
                        tr_data_1st = tr_F_1st_n;
                     
                        te_data = te_F;
                        te_labels = te_y(:,model_ind);
                    
                        if model_ind >= 2 && model_ind <= 4
                            tr_labels(isnan(tr_labels)) = 0;
                            tr_labels_1st(isnan(tr_labels_1st)) = 0;
                         
                            te_labels(isnan(te_labels)) = 0;
                        else
                            if model_ind == 5
                                tr_data(isnan(tr_labels),:) = [];
                                tr_data_1st(isnan(tr_labels_1st),:) = [];
                                tr_labels(isnan(tr_labels)) = [];
                                tr_labels_1st(isnan(tr_labels_1st)) = [];
                             
                                te_data(isnan(te_labels),:) = [];
                                te_labels(isnan(te_labels)) = [];   
                            end
                        end
                     
                        obj = fitcdiscr(tr_data,tr_labels);
                        obj_1st = fitcdiscr(tr_data_1st,tr_labels_1st);
                     
                        pred_inc = predict(obj,te_data);
                        pred_fix = predict(obj_1st,te_data);
                     
                        error_inc(cv_ind,model_ind) = sum(pred_inc ~= te_labels)/length(te_labels)*100;
                        error_fix(cv_ind,model_ind) = sum(pred_fix ~= te_labels)/length(te_labels)*100;               
                     
                        confusion_inc_n_lib{n_count,cv_ind,model_ind} = confusionmat(te_labels,pred_inc);
                        confusion_fix_n_lib{n_count,cv_ind,model_ind} = confusionmat(te_labels,pred_fix);
                     
                        pred_inc_n_lib{n_count,cv_ind,model_ind} = pred_inc;
                        pred_fix_n_lib{n_count,cv_ind,model_ind} = pred_fix;
                    end
                    F_lib = [F_lib; te_F];
                    y_lib = [y_lib; te_y];
                end
                error_inc_n_lib{n_count} = error_inc;
                error_fix_n_lib{n_count} = error_fix;
            
                % add testing data to tr_F and tr_y
                tr_F_n = [tr_F_n; F_lib];
                tr_y_n = [tr_y_n; y_lib];
                
                n_count = n_count + 1;
            else
                if config.pos_label(day_ind) == 2
                    for cv_ind = 1:config.trial_num
                        te_F = F{day_ind,cv_ind}';
                
                        te_y = y{day_ind,cv_ind};
                        te_y = repelem(te_y,config.win_num,1);
                
                        % construct LDA classifiers and valid their performances
                        for model_ind = 1:config.model_num
                            tr_labels = tr_y_i(:,model_ind);
                            tr_labels_1st = tr_y_1st_i(:,model_ind);
                     
                            tr_data = tr_F_i;
                            tr_data_1st = tr_F_1st_i;
                     
                            te_data = te_F;
                            te_labels = te_y(:,model_ind);
                    
                            if model_ind >= 2 && model_ind <= 4
                                tr_labels(isnan(tr_labels)) = 0;
                                tr_labels_1st(isnan(tr_labels_1st)) = 0;
                         
                                te_labels(isnan(te_labels)) = 0;
                            else
                                if model_ind == 5
                                    tr_data(isnan(tr_labels),:) = [];
                                    tr_data_1st(isnan(tr_labels_1st),:) = [];
                                    tr_labels(isnan(tr_labels)) = [];
                                    tr_labels_1st(isnan(tr_labels_1st)) = [];
                             
                                    te_data(isnan(te_labels),:) = [];
                                    te_labels(isnan(te_labels)) = [];   
                                end
                            end
                     
                            obj = fitcdiscr(tr_data,tr_labels);
                            obj_1st = fitcdiscr(tr_data_1st,tr_labels_1st);
                     
                            pred_inc = predict(obj,te_data);
                            pred_fix = predict(obj_1st,te_data);
                     
                            error_inc(cv_ind,model_ind) = sum(pred_inc ~= te_labels)/length(te_labels)*100;
                            error_fix(cv_ind,model_ind) = sum(pred_fix ~= te_labels)/length(te_labels)*100;               
                     
                            confusion_inc_i_lib{i_count,cv_ind,model_ind} = confusionmat(te_labels,pred_inc);
                            confusion_fix_i_lib{i_count,cv_ind,model_ind} = confusionmat(te_labels,pred_fix);
                     
                            pred_inc_i_lib{i_count,cv_ind,model_ind} = pred_inc;
                            pred_fix_i_lib{i_count,cv_ind,model_ind} = pred_fix;
                        end
                        F_lib = [F_lib; te_F];
                        y_lib = [y_lib; te_y];
                    end
                    error_inc_i_lib{i_count} = error_inc;
                    error_fix_i_lib{i_count} = error_fix;
            
                    % add testing data to tr_F and tr_y
                    tr_F_i = [tr_F_i; F_lib];
                    tr_y_i = [tr_y_i; y_lib];
                
                    i_count = i_count + 1;
                else
                    for cv_ind = 1:config.trial_num
                        te_F = F{day_ind,cv_ind}';
                
                        te_y = y{day_ind,cv_ind};
                        te_y = repelem(te_y,config.win_num,1);
                
                        % construct LDA classifiers and valid their performances
                        for model_ind = 1:config.model_num
                            tr_labels = tr_y_o(:,model_ind);
                            tr_labels_1st = tr_y_1st_o(:,model_ind);
                     
                            tr_data = tr_F_o;
                            tr_data_1st = tr_F_1st_o;
                     
                            te_data = te_F;
                            te_labels = te_y(:,model_ind);
                    
                            if model_ind >= 2 && model_ind <= 4
                                tr_labels(isnan(tr_labels)) = 0;
                                tr_labels_1st(isnan(tr_labels_1st)) = 0;
                         
                                te_labels(isnan(te_labels)) = 0;
                            else
                                if model_ind == 5
                                    tr_data(isnan(tr_labels),:) = [];
                                    tr_data_1st(isnan(tr_labels_1st),:) = [];
                                    tr_labels(isnan(tr_labels)) = [];
                                    tr_labels_1st(isnan(tr_labels_1st)) = [];
                             
                                    te_data(isnan(te_labels),:) = [];
                                    te_labels(isnan(te_labels)) = [];   
                                end
                            end
                     
                            obj = fitcdiscr(tr_data,tr_labels);
                            obj_1st = fitcdiscr(tr_data_1st,tr_labels_1st);
                     
                            pred_inc = predict(obj,te_data);
                            pred_fix = predict(obj_1st,te_data);
                     
                            error_inc(cv_ind,model_ind) = sum(pred_inc ~= te_labels)/length(te_labels)*100;
                            error_fix(cv_ind,model_ind) = sum(pred_fix ~= te_labels)/length(te_labels)*100;               
                     
                            confusion_inc_o_lib{o_count,cv_ind,model_ind} = confusionmat(te_labels,pred_inc);
                            confusion_fix_o_lib{o_count,cv_ind,model_ind} = confusionmat(te_labels,pred_fix);
                     
                            pred_inc_o_lib{o_count,cv_ind,model_ind} = pred_inc;
                            pred_fix_o_lib{o_count,cv_ind,model_ind} = pred_fix;
                        end
                        F_lib = [F_lib; te_F];
                        y_lib = [y_lib; te_y];
                    end
                    error_inc_o_lib{o_count} = error_inc;
                    error_fix_o_lib{o_count} = error_fix;
            
                    % add testing data to tr_F and tr_y
                    tr_F_o = [tr_F_o; F_lib];
                    tr_y_o = [tr_y_o; y_lib];
                
                    o_count = o_count +1;
                end
            end
        end
    end
    cd(config.save_dir);
    eval(sprintf('filename=[''DaytoDay_SamePosS%d'',''.mat''];',sub_ind));
    save(filename,'pred_inc_n_lib','pred_fix_n_lib','pred_inc_i_lib','pred_fix_i_lib','pred_inc_o_lib','pred_fix_o_lib',...
        'y_n_lib','y_i_lib','y_o_lib','error_inc_n_lib','error_fix_n_lib',...
        'error_inc_i_lib','error_fix_i_lib','error_inc_o_lib','error_fix_o_lib',...
        'confusion_inc_n_lib','confusion_fix_n_lib','confusion_inc_i_lib','confusion_fix_i_lib','confusion_inc_o_lib','confusion_fix_o_lib');
end

cd(config.code_dir);

% visualization
[inc_same, fix_same] = plot_figure7(config);