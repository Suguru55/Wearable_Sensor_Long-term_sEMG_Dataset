function [error_inc, error_fix,confusion_inc_lib,confusion_fix_lib,pred_inc_lib,pred_fix_lib] =...
    interday_recog(config,day_ind,y,F,tr_y_1st,tr_F_1st,tr_y,tr_F,confusion_inc_lib,confusion_fix_lib,pred_inc_lib,pred_fix_lib)

% evaluate the recognition performance on a target day
error_inc = zeros(config.trial_num,size(tr_y,2));
error_fix = zeros(config.trial_num,size(tr_y,2));
            
for cv_ind = 1:config.trial_num
    te_F = F{day_ind,cv_ind}';
                
    te_y = y{day_ind,cv_ind};
    te_y = repelem(te_y,config.win_num,1);
                
    % construct LDA classifiers and valid their performances           
    for model_ind = 1:config.model_num
        tr_labels = tr_y(:,model_ind);
        tr_labels_1st = tr_y_1st(:,model_ind);
                     
        tr_data = tr_F;
        tr_data_1st = tr_F_1st;
                     
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
                     
        confusion_inc_lib{day_ind,cv_ind,model_ind} = confusionmat(te_labels,pred_inc);
        confusion_fix_lib{day_ind,cv_ind,model_ind} = confusionmat(te_labels,pred_fix);
                     
        pred_inc_lib{day_ind,cv_ind,model_ind} = pred_inc;
        pred_fix_lib{day_ind,cv_ind,model_ind} = pred_fix;
    end
end

cd(config.code_dir);