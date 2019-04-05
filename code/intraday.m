function [tbl, c_intra] = intraday(config)

for sub_ind = 1:config.sub_num
    % load data
    eval(sprintf('dir_name=[config.data_dir, ''\\sub%d''];',sub_ind));
    cd(dir_name);
    
    eval(sprintf('filename=[''FS%d'',''.mat''];',sub_ind));
    load(filename);
    
    for day_ind = 1:config.day_num
        for cv_ind = 1:config.trial_num
            cd(config.code_dir);
            
            dammy_F = F(day_ind,:);
            dammy_y = y(day_ind,:);
                
            te_F_sub = dammy_F{cv_ind}';
            te_y_sub = dammy_y{cv_ind};
            
            te_y_sub = repelem(te_y_sub,config.win_num,1);
                
            dammy_F(cv_ind) = [];
            dammy_y(cv_ind) = [];
            
            % prepare storages for results
            pred_lib = cell(config.trial_num-1,size(te_y_sub,2));
            y_lib = cell(1,size(te_y_sub,2));
            error_lib = cell(config.trial_num-1,size(te_y_sub,2));
            confusion_lib = cell(config.trial_num-1,size(te_y_sub,2));
            obj_lib = cell(config.trial_num-1,size(te_y_sub,2));
            
            for vs_ind = 1:config.trial_num-1
                tr_cell_F = dammy_F(1:vs_ind);
                tr_cell_y = dammy_y(1:vs_ind);
                
                te_F = te_F_sub;
                te_y = te_y_sub;

                % reshape matrix
                tr_F = []; tr_y = [];
                for i = 1:length(tr_cell_F)
                    temp_F = tr_cell_F{i};
                    temp_y = tr_cell_y{i};
                    
                    re_y = repelem(temp_y,config.win_num,1);
                    
                    tr_F = [tr_F; temp_F'];
                    tr_y = [tr_y; re_y];
                end
                
                % construct LDA classifiers and valid their performances           
                for model_ind = 1:config.model_num
                     tr_labels = tr_y(:,model_ind);
                     te_labels = te_y(:,model_ind);
                    
                     if model_ind >= 2 && model_ind <= 4
                         tr_labels(isnan(tr_labels)) = 0;
                         te_labels(isnan(te_labels)) = 0;
                     else
                         if model_ind == 5
                             tr_F(isnan(tr_labels),:) = [];
                             tr_labels(isnan(tr_labels)) = [];        
                             
                             te_F(isnan(te_labels),:) = [];
                             te_labels(isnan(te_labels)) = [];   
                         end
                     end
                     
                     obj = fitcdiscr(tr_F,tr_labels);
                     pred_temp = predict(obj,te_F);
                     
                     error_temp = sum(pred_temp ~= te_labels)/length(te_labels)*100;
                     confusion_temp = confusionmat(te_labels,pred_temp);
                     
                     pred_lib{vs_ind,model_ind} = pred_temp;
                     y_lib{model_ind} = te_labels;
                     error_lib{vs_ind,model_ind} = error_temp;
                     confusion_lib{vs_ind,model_ind} = confusion_temp;
                     obj_lib{vs_ind,model_ind} = obj;
                end
            end
            cd(config.save_dir);
            eval(sprintf('filename=[''WithinDay_S%dD%dCV%d'',''.mat''];',sub_ind,day_ind,cv_ind));
            save(filename,'pred_lib','y_lib','error_lib','confusion_lib','obj_lib');
        end
    end
end
cd(config.code_dir);

% visualize the results and apply anova to the number of trials and
% electrode placements
plot_figure3(config);
[tbl, c_intra] = plot_figure4_and_figure5(config);