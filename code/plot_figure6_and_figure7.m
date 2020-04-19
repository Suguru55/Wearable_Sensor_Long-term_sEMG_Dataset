function [tbl, c_tr] = plot_figure6_and_figure7(config)

% storages for error
er_t1_lib = []; er_t2_lib = []; er_t3_lib = [];
er_n_t1_lib = []; er_n_t2_lib = []; er_n_t3_lib = [];
er_i_t1_lib = []; er_i_t2_lib = []; er_i_t3_lib = [];
er_o_t1_lib = []; er_o_t2_lib = []; er_o_t3_lib = [];

% storages for confusion matrix
conf_t = zeros(3,13,13);

er_all_t1 = []; er_all_t2 = []; er_all_t3 = [];
er_fig_t1 = zeros(15,30,5); er_fig_t2 = zeros(15,30,5); er_fig_t3 = zeros(15,30,5);
 
for sub_ind = 1:config.sub_num
    cd(config.save_dir)
    
    x = [1:3, 5:7, 9:11, 13:15, 17:19, 21:23, 25:27, 29:31, 33:35, 37:39,...
        41:43, 45:47, 49:51, 53:55, 57:59, 61:63, 65:67, 69:71, 73:75, 77:79,...
        81:83, 85:87, 89:91, 93:95, 97:99, 101:103, 105:107, 109:111, 113:115, 117:119,...
        121:123, 125:127, 129:131, 133:135];
    
    er_N_t1 = []; er_N_t2 = []; er_N_t3 = [];
    er_I_t1 = []; er_I_t2 = []; er_I_t3 = [];
    er_O_t1 = []; er_O_t2 = []; er_O_t3 = [];
    
    for day_ind = 1:config.day_num + 4
        if day_ind <= config.day_num
            er_temp_t1 = []; er_temp_t2 = []; er_temp_t3 = [];
        
            for cv_ind = 1:config.trial_num-1
                eval(sprintf('filename=[''WithinDay_S%dD%dCV%d'',''.mat''];',sub_ind,day_ind,cv_ind));
                load(filename);
            
                er_temp_t1 = [er_temp_t1; error_lib{1,:}];
                er_temp_t2 = [er_temp_t2; error_lib{2,:}];
                er_temp_t3 = [er_temp_t3; error_lib{3,:}];
                
                conf_t(cv_ind,1:2,1:2) = squeeze(conf_t(cv_ind,1:2,1:2)) + confusion_lib{cv_ind,1};
                conf_t(cv_ind,3:5,3:5) = squeeze(conf_t(cv_ind,3:5,3:5)) + confusion_lib{cv_ind,2};
                conf_t(cv_ind,6:8,6:8) = squeeze(conf_t(cv_ind,6:8,6:8)) + confusion_lib{cv_ind,3};
                conf_t(cv_ind,9:11,9:11) = squeeze(conf_t(cv_ind,9:11,9:11)) + confusion_lib{cv_ind,4};
                conf_t(cv_ind,12:13,12:13) = squeeze(conf_t(cv_ind,12:13,12:13)) + confusion_lib{cv_ind,5};
            end
        
            er_all_t1 = [er_all_t1; er_temp_t1];
            er_all_t2 = [er_all_t2; er_temp_t2];
            er_all_t3 = [er_all_t3; er_temp_t3];
            
            er_fig_t1(1+size(er_temp_t1,1)*(sub_ind-1):size(er_temp_t1,1)+size(er_temp_t1,1)*(sub_ind-1),day_ind,:) = er_temp_t1;
            er_fig_t2(1+size(er_temp_t2,1)*(sub_ind-1):size(er_temp_t2,1)+size(er_temp_t2,1)*(sub_ind-1),day_ind,:) = er_temp_t2;
            er_fig_t3(1+size(er_temp_t3,1)*(sub_ind-1):size(er_temp_t3,1)+size(er_temp_t3,1)*(sub_ind-1),day_ind,:) = er_temp_t3;
            
            if config.pos_label(day_ind) == 1
                er_N_t1 = [er_N_t1; er_temp_t1];
                er_N_t2 = [er_N_t2; er_temp_t2];
                er_N_t3 = [er_N_t3; er_temp_t3];            
            else
                if config.pos_label(day_ind) == 2
                    er_I_t1 = [er_I_t1; er_temp_t1];
                    er_I_t2 = [er_I_t2; er_temp_t2];
                    er_I_t3 = [er_I_t3; er_temp_t3];
                else
                    er_O_t1 = [er_O_t1; er_temp_t1];
                    er_O_t2 = [er_O_t2; er_temp_t2];
                    er_O_t3 = [er_O_t3; er_temp_t3];                  
                end
            end
        end       
    end
    
    er_t1_lib = [er_t1_lib; er_all_t1]; er_t2_lib = [er_t2_lib; er_all_t2]; er_t3_lib = [er_t3_lib; er_all_t3];
    er_n_t1_lib = [er_n_t1_lib; er_N_t1]; er_n_t2_lib = [er_n_t2_lib; er_N_t2]; er_n_t3_lib = [er_n_t3_lib; er_N_t3];
    er_i_t1_lib = [er_i_t1_lib; er_I_t1]; er_i_t2_lib = [er_i_t2_lib; er_I_t2]; er_i_t3_lib = [er_i_t3_lib; er_I_t3];
    er_o_t1_lib = [er_o_t1_lib; er_O_t1]; er_o_t2_lib = [er_o_t2_lib; er_O_t2]; er_o_t3_lib = [er_o_t3_lib; er_O_t3];
end


er_N_t1_lib = []; er_N_t2_lib = []; er_N_t3_lib = [];
er_I_t1_lib = []; er_I_t2_lib = []; er_I_t3_lib = [];
er_O_t1_lib = []; er_O_t2_lib = []; er_O_t3_lib = [];

for day_ind = 1:config.day_num + 4    
    figure(6)
    if day_ind <= config.day_num
        er_fig_temp_t1 = squeeze(er_fig_t1(:,day_ind,:));
        er_fig_temp_t1 = er_fig_temp_t1(:);
        er_fig_temp_t2 = squeeze(er_fig_t2(:,day_ind,:));
        er_fig_temp_t2 = er_fig_temp_t2(:);
        er_fig_temp_t3 = squeeze(er_fig_t3(:,day_ind,:));
        er_fig_temp_t3 = er_fig_temp_t3(:);
        
        if config.pos_label(day_ind) == 1
            bar(x(1+(day_ind-1)*3),mean(er_fig_temp_t1(:),1),'FaceColor',[1,0,0],'FaceAlpha',0.8,'EdgeColor','none');
            if day_ind == 1
                hold on
            end
            bar(x(2+(day_ind-1)*3),mean(er_fig_temp_t2,1),'FaceColor',[1,0,0],'FaceAlpha',0.6,'EdgeColor','none');
            bar(x(3+(day_ind-1)*3),mean(er_fig_temp_t3,1),'FaceColor',[1,0,0],'FaceAlpha',0.4,'EdgeColor','none');
            errorbar(x(1+(day_ind-1)*3),mean(er_fig_temp_t1,1),std(er_fig_temp_t1,1)/sqrt(length(er_fig_temp_t1)),'k','LineWidth',1); 
            errorbar(x(2+(day_ind-1)*3),mean(er_fig_temp_t2,1),std(er_fig_temp_t2,1)/sqrt(length(er_fig_temp_t2)),'k','LineWidth',1);
            errorbar(x(3+(day_ind-1)*3),mean(er_fig_temp_t3,1),std(er_fig_temp_t3,1)/sqrt(length(er_fig_temp_t3)),'k','LineWidth',1);
            
            er_N_t1_lib = [er_N_t1_lib; er_fig_temp_t1];
            er_N_t2_lib = [er_N_t2_lib; er_fig_temp_t2];
            er_N_t3_lib = [er_N_t3_lib; er_fig_temp_t3];
        else
            if config.pos_label(day_ind) == 2
                bar(x(1+(day_ind-1)*3),mean(er_fig_temp_t1,1),'FaceColor',[0,1,1],'FaceAlpha',0.8,'EdgeColor','none');
                    bar(x(2+(day_ind-1)*3),mean(er_fig_temp_t2,1),'FaceColor',[0,1,1],'FaceAlpha',0.6,'EdgeColor','none');
                    bar(x(3+(day_ind-1)*3),mean(er_fig_temp_t3,1),'FaceColor',[0,1,1],'FaceAlpha',0.4,'EdgeColor','none');
                    errorbar(x(1+(day_ind-1)*3),mean(er_fig_temp_t1,1),std(er_fig_temp_t1,1)/sqrt(length(er_fig_temp_t1)),'k','LineWidth',1);
                    errorbar(x(2+(day_ind-1)*3),mean(er_fig_temp_t2,1),std(er_fig_temp_t2,1)/sqrt(length(er_fig_temp_t2)),'k','LineWidth',1);
                    errorbar(x(3+(day_ind-1)*3),mean(er_fig_temp_t3,1),std(er_fig_temp_t3,1)/sqrt(length(er_fig_temp_t3)),'k','LineWidth',1);
                    
                    er_I_t1_lib = [er_I_t1_lib; er_fig_temp_t1];
                    er_I_t2_lib = [er_I_t2_lib; er_fig_temp_t2];
                    er_I_t3_lib = [er_I_t3_lib; er_fig_temp_t3];
                else
                    bar(x(1+(day_ind-1)*3),mean(er_fig_temp_t1,1),'FaceColor',[0,0,1],'FaceAlpha',0.8,'EdgeColor','none');
                    bar(x(2+(day_ind-1)*3),mean(er_fig_temp_t2,1),'FaceColor',[0,0,1],'FaceAlpha',0.6,'EdgeColor','none')
                    bar(x(3+(day_ind-1)*3),mean(er_fig_temp_t3,1),'FaceColor',[0,0,1],'FaceAlpha',0.4,'EdgeColor','none');
                    errorbar(x(1+(day_ind-1)*3),mean(er_fig_temp_t1,1),std(er_fig_temp_t1,1)/sqrt(length(er_fig_temp_t1)),'k','LineWidth',1);
                    errorbar(x(2+(day_ind-1)*3),mean(er_fig_temp_t2,1),std(er_fig_temp_t2,1)/sqrt(length(er_fig_temp_t2)),'k','LineWidth',1);
                    errorbar(x(3+(day_ind-1)*3),mean(er_fig_temp_t3,1),std(er_fig_temp_t3,1)/sqrt(length(er_fig_temp_t3)),'k','LineWidth',1);
                    
                    er_O_t1_lib = [er_O_t1_lib; er_fig_temp_t1];
                    er_O_t2_lib = [er_O_t2_lib; er_fig_temp_t2];
                    er_O_t3_lib = [er_O_t3_lib; er_fig_temp_t3];
                end
            end
        else
            if day_ind == config.day_num + 1 % N
                bar(x(1+(day_ind-1)*3),mean(er_N_t1_lib,1),'FaceColor',[1,0,0],'FaceAlpha',0.8,'EdgeColor','none');
                bar(x(2+(day_ind-1)*3),mean(er_N_t2_lib,1),'FaceColor',[1,0,0],'FaceAlpha',0.6,'EdgeColor','none');
                bar(x(3+(day_ind-1)*3),mean(er_N_t3_lib,1),'FaceColor',[1,0,0],'FaceAlpha',0.4,'EdgeColor','none');
                errorbar(x(1+(day_ind-1)*3),mean(er_N_t1_lib,1),std(er_N_t1_lib,1)/sqrt(length(er_N_t1_lib)),'k','LineWidth',1); 
                errorbar(x(2+(day_ind-1)*3),mean(er_N_t2_lib,1),std(er_N_t2_lib,1)/sqrt(length(er_N_t2_lib)),'k','LineWidth',1);
                errorbar(x(3+(day_ind-1)*3),mean(er_N_t3_lib,1),std(er_N_t3_lib,1)/sqrt(length(er_N_t3_lib)),'k','LineWidth',1);
            else
                if day_ind == config.day_num + 2 % I
                    bar(x(1+(day_ind-1)*3),mean(er_I_t1_lib,1),'FaceColor',[0,1,1],'FaceAlpha',0.8,'EdgeColor','none');
                    bar(x(2+(day_ind-1)*3),mean(er_I_t2_lib,1),'FaceColor',[0,1,1],'FaceAlpha',0.6,'EdgeColor','none');
                    bar(x(3+(day_ind-1)*3),mean(er_I_t3_lib,1),'FaceColor',[0,1,1],'FaceAlpha',0.4,'EdgeColor','none');
                    errorbar(x(1+(day_ind-1)*3),mean(er_I_t1_lib,1),std(er_I_t1_lib,1)/sqrt(length(er_I_t1_lib)),'k','LineWidth',1); 
                    errorbar(x(2+(day_ind-1)*3),mean(er_I_t2_lib,1),std(er_I_t2_lib,1)/sqrt(length(er_I_t2_lib)),'k','LineWidth',1);
                    errorbar(x(3+(day_ind-1)*3),mean(er_I_t3_lib,1),std(er_I_t3_lib,1)/sqrt(length(er_I_t3_lib)),'k','LineWidth',1);                      
                else
                    if day_ind == config.day_num + 3 % O
                        bar(x(1+(day_ind-1)*3),mean(er_O_t1_lib,1),'FaceColor',[0,0,1],'FaceAlpha',0.8,'EdgeColor','none');
                        bar(x(2+(day_ind-1)*3),mean(er_O_t2_lib,1),'FaceColor',[0,0,1],'FaceAlpha',0.6,'EdgeColor','none');
                        bar(x(3+(day_ind-1)*3),mean(er_O_t3_lib,1),'FaceColor',[0,0,1],'FaceAlpha',0.4,'EdgeColor','none');
                        errorbar(x(1+(day_ind-1)*3),mean(er_O_t1_lib,1),std(er_O_t1_lib,1)/sqrt(length(er_O_t1_lib)),'k','LineWidth',1); 
                        errorbar(x(2+(day_ind-1)*3),mean(er_O_t2_lib,1),std(er_O_t2_lib,1)/sqrt(length(er_O_t2_lib)),'k','LineWidth',1);
                        errorbar(x(3+(day_ind-1)*3),mean(er_O_t3_lib,1),std(er_O_t3_lib,1)/sqrt(length(er_O_t3_lib)),'k','LineWidth',1); 
                    else % All
                        bar(x(1+(day_ind-1)*3),mean(er_all_t1(:),1),'FaceColor',[0,0,0],'FaceAlpha',0.8);
                        bar(x(2+(day_ind-1)*3),mean(er_all_t2(:),1),'FaceColor',[0,0,0],'FaceAlpha',0.6);
                        bar(x(3+(day_ind-1)*3),mean(er_all_t3(:),1),'FaceColor',[0,0,0],'FaceAlpha',0.4);
                        errorbar(x(1+(day_ind-1)*3),mean(er_all_t1(:),1),std(er_all_t1(:),1)/sqrt(length(er_all_t1(:))),'k','LineWidth',1);
                        errorbar(x(2+(day_ind-1)*3),mean(er_all_t2(:),1),std(er_all_t2(:),1)/sqrt(length(er_all_t2(:))),'k','LineWidth',1);
                        errorbar(x(3+(day_ind-1)*3),mean(er_all_t3(:),1),std(er_all_t3(:),1)/sqrt(length(er_all_t3(:))),'k','LineWidth',1);
                        hold off
                    end
                end
            end
        end
        grid on
        ylim([0 17])
        set(gca,'FontSize',24,'FontName','Times New Roman')
        ylabel('Error (%)')
        xlabel('Day')
end


conf_t1 = squeeze(conf_t(1,:,:))./sum(squeeze(conf_t(1,:,:)),2);
conf_t2 = squeeze(conf_t(2,:,:))./sum(squeeze(conf_t(2,:,:)),2);
conf_t3 = squeeze(conf_t(3,:,:))./sum(squeeze(conf_t(3,:,:)),2);

figure(7)
subplot(1,3,1)
heatmap(conf_t1,'Colormap',copper);
subplot(1,3,2)
heatmap(conf_t2,'Colormap',copper);
subplot(1,3,3)
heatmap(conf_t3,'Colormap',copper);

save('conf.mat','conf_t1','conf_t2','conf_t3');

% anova
tr1 = [er_n_t1_lib(:),er_i_t1_lib(:),er_o_t1_lib(:)];
tr2 = [er_n_t2_lib(:),er_i_t2_lib(:),er_o_t2_lib(:)];
tr3 = [er_n_t3_lib(:),er_i_t3_lib(:),er_o_t3_lib(:)];

tr_comp = [tr1; tr2; tr3];
[~,tbl,stats] = anova2(tr_comp,length(tr1));
c_tr = multcompare(stats,'Estimate','row');

cd(config.code_dir)