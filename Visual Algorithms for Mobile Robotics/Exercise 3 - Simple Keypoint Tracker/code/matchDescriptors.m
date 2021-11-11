function matches = matchDescriptors(...
    query_descriptors, database_descriptors, lambda)
% Returns a 1xQ matrix where the i-th coefficient is the index of the
% database descriptor which matches to the i-th query descriptor.
% The descriptor vectors are MxQ and MxD where M is the descriptor
% dimension and Q and D the amount of query and database descriptors
% respectively. matches(i) will be zero if there is no database descriptor
% with an SSD < lambda * min(SSD). No two non-zero elements of matches will
% be equal.
    D = pdist2(query_descriptors', database_descriptors');
    dmin = min(min(D));
    delta = lambda * dmin;


    matches = [];
    for i = 1:size(query_descriptors,2)
        [C,I] = mink(D(i,:), size(query_descriptors,2));
        
        flag = 0;
        for j = 1:length(I)
            if(C(j)<delta && ~ismember(I(j), matches))
                matches = [matches, I(j)];
                flag = 1;
                break;
            end
        end
        if(flag==0)
            matches = [matches, 0];
        end
    end
    

