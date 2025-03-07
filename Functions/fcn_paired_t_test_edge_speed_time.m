function t_test_results = fcn_paired_t_test_edge_speed_time(bl_data, per_data)
    % Load the data from the CSV files
    bl_data = readtable(bl_data, 'Delimiter', ';');
    per_data = readtable(per_data, 'Delimiter', ';');
    
    % Initialize a structure to store t-test results
    t_test_results = dictionary;
    
    % Get the unique edges
    edges = unique(bl_data.edge_id);
    
    % Perform paired t-test for each edge as a function of time
    for i = 1:length(edges)
        edge = edges{i};
        bl_edge_speed = bl_data.edge_speed(strcmp(bl_data.edge_id, edge));
        per_edge_speed = per_data.edge_speed(strcmp(per_data.edge_id, edge));
        
        % Initialize a list to store t-test results for different sample sizes
        %t_test_results.(edge) = [];
        t_test_results(edge) = struct;
        t_test_results(edge).h = [];
        % t_test_results(edge).p = [];
        % t_test_results(edge).ci = [];
        % t_test_results(edge).stats = [];
        % Perform t-tests for increasing sample sizes
        for j = 2:length(bl_edge_speed)
            bl_samples = bl_edge_speed(1:j);
            per_samples = per_edge_speed(1:j);
            
            % Perform paired t-test
            [h, p, ci, stats] = ttest(bl_samples, per_samples);
            
            % Handle nan values by setting t-statistic and h to 0
            if isnan(stats.tstat)
                stats.tstat = 0;
                h = 0;
            end
            
            % Store the results in the list
            %t_test_results.(edge) = [t_test_results.(edge); struct('sample_size', j, 't_stat', stats.tstat, 'p_value', p, 'h', h)];
            
            t_test_results(edge).h(end+1) = h;
           
        end
    end
    
    % % Display the t-test results for each edge as a function of time
    % edges = fieldnames(t_test_results);
    % for i = 1:length(edges)
    %     edge = edges{i};
    %     fprintf('Edge: %s\n', edge);
    %     for j = 1:length(t_test_results.(edge))
    %         result = t_test_results.(edge)(j);
    %         fprintf('Sample Size: %d, t-statistic: %.3f, p-value: %.3f, h: %d\n', result.sample_size, result.t_stat, result.p_value, result.h);
    %     end
    % end
end