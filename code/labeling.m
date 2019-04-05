function struct = labeling(struct)

struct.class_labels = 1:struct.mov_num;
struct.class_labels = struct.class_labels';
%struct.class_labels = repmat(struct.class_labels,[struct.trial_num,1]);
%struct.class_labels = struct.class_labels(:);

% translate label to -1 and 1 for each classifier model
struct.labels = NaN(size(struct.class_labels,1),5);

for i = 1:size(struct.class_labels,1)
    % resting(-1)・actual movement(1)
    if struct.class_labels(i,1) ~= 1
        struct.labels(i,1) = 1;
    else
        struct.labels(i,1) = -1;
    end
    
    % flexion(1)・extension(-1)
    if (struct.class_labels(i,1) == 2) || (struct.class_labels(i,1) == 9) || (struct.class_labels(i,1) == 13) || (struct.class_labels(i,1) == 17)
        struct.labels(i,2) = 1;
    else
        if (struct.class_labels(i,1) == 3) || (struct.class_labels(i,1) == 10) || (struct.class_labels(i,1) == 14) || (struct.class_labels(i,1) == 18)
            struct.labels(i,2) = -1;
        end
    end
    
    % radial deviation(1)・ulnar deviation(-1)
    if (struct.class_labels(i,1) == 4) || (struct.class_labels(i,1) == 11) || (struct.class_labels(i,1) == 15) || (struct.class_labels(i,1) == 19)
        struct.labels(i,3) = 1;
    else
        if (struct.class_labels(i,1) == 5) || (struct.class_labels(i,1) == 12) || (struct.class_labels(i,1) == 16) || (struct.class_labels(i,1) == 20)
            struct.labels(i,3) = -1;
        end
    end
    
    % pronation(1)・supination(-1)
    if (struct.class_labels(i,1) == 6) || (struct.class_labels(i,1) == 9) || (struct.class_labels(i,1) == 10) || (struct.class_labels(i,1) == 11) || (struct.class_labels(i,1) == 12) || (struct.class_labels(i,1) == 21)
        struct.labels(i,4) = 1;
    else
        if (struct.class_labels(i,1) == 7) || (struct.class_labels(i,1) == 13) || (struct.class_labels(i,1) == 14) || (struct.class_labels(i,1) == 15) || (struct.class_labels(i,1) == 16) || (struct.class_labels(i,1) == 22)
            struct.labels(i,4) = -1;
        end
    end
    
    % hand open(-1)・hand close(1)
    if (struct.class_labels(i,1) == 8) || (struct.class_labels(i,1) == 17) || (struct.class_labels(i,1) == 18) || (struct.class_labels(i,1) == 19) || (struct.class_labels(i,1) == 20) || (struct.class_labels(i,1) == 21) || (struct.class_labels(i,1) == 22)
        struct.labels(i,5) = 1;
    else
        if struct.class_labels(i,1) == 1
            struct.labels(i,5) = -1;
        end
    end
end
