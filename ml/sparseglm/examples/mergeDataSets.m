function [data] = mergeDataSets(names)
    load(names{1});
    tmp = data;
    for ii = 2:length(names)
        load(names{ii});
        fn = fieldnames(data);
        for jj = 1:length(fn)
            val = data.(fn{jj});
            if isnumeric(val) && length(val) > 1
                tmp.(fn{jj}) = cat(1,tmp.(fn{jj}),data.(fn{jj}));
            end
        end
    end
    data = tmp;
end