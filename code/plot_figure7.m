function [inc, fix] = plot_figure7(config)

error_inc_n = zeros(config.sub_num,config.day_num/3-1);
error_fix_n = zeros(config.sub_num,config.day_num/3-1);
error_inc_i = zeros(config.sub_num,config.day_num/3-1);
error_fix_i = zeros(config.sub_num,config.day_num/3-1);
error_inc_o = zeros(config.sub_num,config.day_num/3-1);
error_fix_o = zeros(config.sub_num,config.day_num/3-1);

for sub_ind = 1:config.sub_num
    cd(config.save_dir);
    
    eval(sprintf('filename=[''DaytoDay_SamePosS%d'',''.mat''];',sub_ind));
    load(filename);
    
    n_count = 1; i_count = 1; o_count =1;
    
    for day_ind = 4:config.day_num
        if config.pos_label(day_ind) == 1
            error_inc_temp = error_inc_n_lib{n_count};
            error_inc_n(sub_ind,n_count) = mean(mean(error_inc_temp));
        
            error_fix_temp = error_fix_n_lib{n_count};
            error_fix_n(sub_ind,n_count) = mean(mean(error_fix_temp));
            
            n_count = n_count + 1;
        else
            if config.pos_label(day_ind) == 2
                error_inc_temp = error_inc_i_lib{i_count};
                error_inc_i(sub_ind,i_count) = mean(mean(error_inc_temp));
        
                error_fix_temp = error_fix_i_lib{i_count};
                error_fix_i(sub_ind,i_count) = mean(mean(error_fix_temp));
                
                i_count = i_count + 1;
            else
                error_inc_temp = error_inc_o_lib{o_count};
                error_inc_o(sub_ind,o_count) = mean(mean(error_inc_temp));
        
                error_fix_temp = error_fix_o_lib{o_count};
                error_fix_o(sub_ind,o_count) = mean(mean(error_fix_temp));
                
                o_count = o_count + 1;
            end
        end
    end
end

figure(6)
subplot(1,3,1)
plot(error_inc_n(1,:),'-o','Color','k','LineWidth',1.5);hold on
plot(error_inc_n(2,:),'-^','Color','k','LineWidth',1.5);
plot(error_inc_n(3,:),'-s','Color','k','LineWidth',1.5);
plot(error_inc_n(4,:),'-x','Color','k','LineWidth',1.5);
plot(error_inc_n(5,:),'-p','Color','k','LineWidth',1.5);
plot(error_fix_n(1,:),'--o','Color','k','LineWidth',1.5);
plot(error_fix_n(2,:),'--^','Color','k','LineWidth',1.5);
plot(error_fix_n(3,:),'--s','Color','k','LineWidth',1.5);
plot(error_fix_n(4,:),'--x','Color','k','LineWidth',1.5);
plot(error_fix_n(5,:),'--p','Color','k','LineWidth',1.5);hold off
grid on
xlim([1 9])
ylim([0 35])
set(gca,'FontName','Times New Roman','FontSize',20)
subplot(1,3,2)
plot(error_inc_i(1,:),'-o','Color','k','LineWidth',1.5);hold on
plot(error_inc_i(2,:),'-^','Color','k','LineWidth',1.5);
plot(error_inc_i(3,:),'-s','Color','k','LineWidth',1.5);
plot(error_inc_i(4,:),'-x','Color','k','LineWidth',1.5);
plot(error_inc_i(5,:),'-p','Color','k','LineWidth',1.5);
plot(error_fix_i(1,:),'--o','Color','k','LineWidth',1.5);
plot(error_fix_i(2,:),'--^','Color','k','LineWidth',1.5);
plot(error_fix_i(3,:),'--s','Color','k','LineWidth',1.5);
plot(error_fix_i(4,:),'--x','Color','k','LineWidth',1.5);
plot(error_fix_i(5,:),'--p','Color','k','LineWidth',1.5);hold off
grid on
xlim([1 9])
ylim([0 35])
set(gca,'FontName','Times New Roman','FontSize',20)
subplot(1,3,3)
plot(error_inc_o(1,:),'-o','Color','k','LineWidth',1.5);hold on
plot(error_inc_o(2,:),'-^','Color','k','LineWidth',1.5);
plot(error_inc_o(3,:),'-s','Color','k','LineWidth',1.5);
plot(error_inc_o(4,:),'-x','Color','k','LineWidth',1.5);
plot(error_inc_o(5,:),'-p','Color','k','LineWidth',1.5);
plot(error_fix_o(1,:),'--o','Color','k','LineWidth',1.5);
plot(error_fix_o(2,:),'--^','Color','k','LineWidth',1.5);
plot(error_fix_o(3,:),'--s','Color','k','LineWidth',1.5);
plot(error_fix_o(4,:),'--x','Color','k','LineWidth',1.5);
plot(error_fix_o(5,:),'--p','Color','k','LineWidth',1.5);hold off
grid on
xlim([1 9])
ylim([0 35])
set(gca,'FontName','Times New Roman','FontSize',20)

% check variance
inc.ave.error_n = mean(error_inc_n,2);
inc.sd.error_n = std(error_inc_n,[],2);
inc.ave.error_i = mean(error_inc_i,2);
inc.sd.error_i = std(error_inc_i,[],2);
inc.ave.error_o = mean(error_inc_o,2);
inc.sd.error_o = std(error_inc_o,[],2);

fix.ave.error_n = mean(error_fix_n,2);
fix.sd.error_n = std(error_fix_n,[],2);
fix.ave.error_i = mean(error_fix_i,2);
fix.sd.error_i = std(error_fix_i,[],2);
fix.ave.error_o = mean(error_fix_o,2);
fix.sd.error_o = std(error_fix_o,[],2);

cd(config.code_dir);