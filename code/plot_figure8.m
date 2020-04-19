function [inc, fix] = plot_figure8(config)

error_inc_n = zeros(config.sub_num,config.day_num);
error_fix_n = zeros(config.sub_num,config.day_num);
error_inc_i = zeros(config.sub_num,config.day_num);
error_fix_i = zeros(config.sub_num,config.day_num);
error_inc_o = zeros(config.sub_num,config.day_num);
error_fix_o = zeros(config.sub_num,config.day_num);

for sub_ind = 1:config.sub_num
    cd(config.save_dir);
    
    eval(sprintf('filename=[''DaytoDay_S%d'',''.mat''];',sub_ind));
    load(filename);
    
    for day_ind = 1:config.day_num
        error_inc_n_temp = error_inc_n_lib{day_ind};
        error_inc_n(sub_ind,day_ind) = mean(mean(error_inc_n_temp));
        error_inc_i_temp = error_inc_i_lib{day_ind};
        error_inc_i(sub_ind,day_ind) = mean(mean(error_inc_i_temp));
        error_inc_o_temp = error_inc_o_lib{day_ind};
        error_inc_o(sub_ind,day_ind) = mean(mean(error_inc_o_temp));        
        
        error_fix_n_temp = error_fix_n_lib{day_ind};
        error_fix_n(sub_ind,day_ind) = mean(mean(error_fix_n_temp));
        error_fix_i_temp = error_fix_i_lib{day_ind};
        error_fix_i(sub_ind,day_ind) = mean(mean(error_fix_i_temp));       
        error_fix_o_temp = error_fix_o_lib{day_ind};
        error_fix_o(sub_ind,day_ind) = mean(mean(error_fix_o_temp));
    end
end

error_inc_n(isnan(error_inc_n)) = 0;
error_inc_i(isnan(error_inc_i)) = 0;
error_inc_o(isnan(error_inc_o)) = 0;
error_fix_n(isnan(error_fix_n)) = 0;
error_fix_i(isnan(error_fix_i)) = 0;
error_fix_o(isnan(error_fix_o)) = 0;

plot_variance = @(x,lower,upper,color) set(fill([x,x(end:-1:1)],[upper,lower(end:-1:1)],color),'EdgeColor',color,'FaceAlpha',0.2);
x=1:1:30;

figure(6)
subplot(3,1,1)
plot_variance(x,mean(error_fix_n,1)-std(error_fix_n),mean(error_fix_n,1)+std(error_fix_n),[0.80 0.80 0.80]);hold on
plot_variance(x,mean(error_inc_n,1)-std(error_inc_n),mean(error_inc_n,1)+std(error_inc_n),[0.40 0.40 0.40]);hold on
plot(mean(error_inc_n,1),'-o','Color','k','Linewidth',1.5);
plot(mean(error_fix_n,1),'--o','Color','k','Linewidth',1);hold off
grid on
xlim([2 30])
ylim([0 40])
set(gca,'FontName','Times New Roman','FontSize',20)
subplot(3,1,2)
plot_variance(x,mean(error_fix_i,1)-std(error_fix_i),mean(error_fix_i,1)+std(error_fix_i),[0.80 0.80 0.80]);hold on
plot_variance(x,mean(error_inc_i,1)-std(error_inc_i),mean(error_inc_i,1)+std(error_inc_i),[0.40 0.40 0.40]);hold on
plot(mean(error_inc_i,1),'-o','Color','k','Linewidth',1.5);
plot(mean(error_fix_i,1),'--o','Color','k','Linewidth',1);hold off
grid on
xlim([3 30])
ylim([0 40])
set(gca,'FontName','Times New Roman','FontSize',20)
subplot(3,1,3)
plot_variance(x,mean(error_fix_o,1)-std(error_fix_o),mean(error_fix_o,1)+std(error_fix_o),[0.80 0.80 0.80]);hold on
plot_variance(x,mean(error_inc_o,1)-std(error_inc_o),mean(error_inc_o,1)+std(error_inc_o),[0.40 0.40 0.40]);hold on
plot(mean(error_inc_o,1),'-o','Color','k','Linewidth',1.5);
plot(mean(error_fix_o,1),'--o','Color','k','Linewidth',1);hold off
grid on
xlim([4 30])
ylim([0 40])
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