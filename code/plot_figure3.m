function plot_figure3(config)

% find max and min values in 5 dimensions for 4th channel
% MAV, ZC, SSC, WL, and RMS
max_values = zeros(config.sub_num,5);
min_values = zeros(config.sub_num,5);
bin_num = 30;

% storage
N_lib = cell(1,config.sub_num); I_lib = cell(1,config.sub_num); O_lib = cell(1,config.sub_num);

for sub_ind = 1:config.sub_num
    N_lib_temp = []; I_lib_temp = []; O_lib_temp = [];
    
    eval(sprintf('dir_name=[config.data_dir, ''\\sub%d''];',sub_ind));
    cd(dir_name);
    
    eval(sprintf('filename=[''FS%d'',''.mat''];',sub_ind));
    load(filename);
    
    for day_ind = 1:config.day_num
        N_data = []; I_data = []; O_data = [];
        
        for cv_ind = 1:config.trial_num            
            te_F = F{day_ind,cv_ind}';
            te_F = te_F(:,[4,12,20,28,36]);
            %te_F = te_F(:,1:40);
            
            max_temp = max(te_F);
            min_temp = min(te_F);
            
            if day_ind == 1&&cv_ind == 1
                max_values(sub_ind,:) = max_temp;
                min_values(sub_ind,:) = min_temp;
            else
                for dim_ind = 1:size(te_F,2)
                    if max_temp(1,dim_ind) > max_values(sub_ind,dim_ind) 
                        max_values(sub_ind,dim_ind) = max_temp(1,dim_ind);
                    end
                    if min_temp(1,dim_ind) > min_values(sub_ind,dim_ind) 
                        min_values(sub_ind,dim_ind) = min_temp(1,dim_ind);
                    end
                end    
            end
            
            if config.pos_label(day_ind) == 1
                N_data = [N_data; te_F];
            else
                if config.pos_label(day_ind) == 2
                    I_data = [I_data; te_F];             
                else
                    O_data = [O_data; te_F];                           
                end
            end
        end
        
        N_lib_temp = [N_lib_temp; N_data];
        I_lib_temp = [I_lib_temp; I_data];
        O_lib_temp = [O_lib_temp; O_data];
    end
    N_lib{sub_ind} = N_lib_temp;
    I_lib{sub_ind} = I_lib_temp;
    O_lib{sub_ind} = O_lib_temp;
end

% set axis
for feat_ind = 1:size(max_values,2)
%     temp_max = max_values(:,1+config.ch_num*(feat_ind-1):config.ch_num+config.ch_num*(feat_ind-1));
%     temp_min = min_values(:,1+config.ch_num*(feat_ind-1):config.ch_num+config.ch_num*(feat_ind-1));
    temp_max = max_values(:,feat_ind);
    temp_min = min_values(:,feat_ind);

    max_max_value(feat_ind) = ceil(max(temp_max(:)));
    min_min_value(feat_ind) = fix(min(temp_min(:)));
end

% calculate histograms
for sub_ind = 1:config.sub_num
    for feat_ind = 1:size(max_values,2)
        edges = linspace(min_min_value(feat_ind),max_max_value(feat_ind),bin_num);
        
%         feat_N = N_lib{sub_ind}(:,1+config.ch_num*(feat_ind-1):config.ch_num+config.ch_num*(feat_ind-1));
%         feat_I = I_lib{sub_ind}(:,1+config.ch_num*(feat_ind-1):config.ch_num+config.ch_num*(feat_ind-1));
%         feat_O = O_lib{sub_ind}(:,1+config.ch_num*(feat_ind-1):config.ch_num+config.ch_num*(feat_ind-1));
        feat_N = N_lib{sub_ind}(:,feat_ind);
        feat_I = I_lib{sub_ind}(:,feat_ind);
        feat_O = O_lib{sub_ind}(:,feat_ind);
     
        feat_N = feat_N(:);
        feat_I = feat_I(:);
        feat_O = feat_O(:);
       
        N_N = histcounts(feat_N,edges,'Normalization', 'probability');
        N_I = histcounts(feat_I,edges,'Normalization', 'probability');
        N_O = histcounts(feat_O,edges,'Normalization', 'probability');
        
        figure(1)
        subplot(5,5,feat_ind+5*(sub_ind-1))
        histogram('BinEdges',edges,'BinCounts',N_O,'Normalization','probability','FaceColor',[0,0,1],'FaceAlpha',0.8,'EdgeAlpha',0.5);hold on        
        histogram('BinEdges',edges,'BinCounts',N_I,'Normalization','probability','FaceColor',[0,1,1],'FaceAlpha',0.8,'EdgeAlpha',0.5);      
        histogram('BinEdges',edges,'BinCounts',N_N,'Normalization','probability','FaceColor',[1,0,0],'FaceAlpha',0.8,'EdgeAlpha',0.5);hold off
        grid on
        set(gca,'FontName','Times New Roman')
    end
end
cd(config.code_dir);