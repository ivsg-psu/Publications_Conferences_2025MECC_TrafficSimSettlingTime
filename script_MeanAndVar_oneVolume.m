close all;
emptySpeed = 11.17; 
corefigNum = 3;
figNum.mean = corefigNum;
figNum.SD = corefigNum+1;
figNum.pct2 = corefigNum+2;
figNum.pct5 = corefigNum+3;
%%%%%%%%%%%%%%% set user inputs %%%%%%%%%%%%%%%%%%
sim_name            = '300m_9x9_twoLane_twoDirection_remove1Lane';
sim_name             = 'PortionOfSC';
flag_xml2csv         = 0;  % do you need to parse xml to csv? 
flag_completionTime  = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder = fileparts(mfilename("fullpath"));
directory = fullfile(folder,'SUMO',sim_name,'3600vehPerHr','aggregatedResults_2024_09_22');
files = dir(fullfile(directory, 'bl_seed_*_aggreInterval_60aggregated.csv'));
dataField = 'edge_speed';

if flag_xml2csv
   fcn_xml2csv_multipleFiles(directory,'*.xml');    
end


for ii = 1:length(files)
    filePath = fullfile(directory,files(ii).name);   
    [h1{ii},intervalNum_hour{ii},dataMean{ii}] = fcn_MeanAndVar(filePath,dataField,figNum.mean, ...
        figNum.SD,emptySpeed);
    [~,settling_time_5pct(ii)] = fcn_settlingTime(intervalNum_hour{ii},dataMean{ii});

end
dataMean_all = horzcat(dataMean{:})';
SD = std(dataMean_all);
meanOfMean = mean(dataMean_all);
lowerBD = meanOfMean - 3*SD; % 95 percentile
upperBD = meanOfMean + 3*SD; % 95 percentile

figure(corefigNum);
h2 = plot(intervalNum_hour{1},lowerBD,'b','linewidth',2);
hold on;
plot(intervalNum_hour{1},upperBD,'b','linewidth',2);
legend([h1{1},h2],{'Mean speed of simulations','3-sigma boundary'});
% fill([intervalNum_hour{1}', fliplr(intervalNum_hour{1}')], [upperBD, fliplr(lowerBD)], [0.8, 0.8, 0.8], ...
%     'EdgeColor', 'none','FaceAlpha',0.5);  % Shaded area

print(figure(figNum.mean),[folder,'/Fig/',sim_name,'_mean',dataField,'_oneTrafficVolume'],'-dpng','-r300');


%% calculate trip completion time
if flag_completionTime
files = dir(fullfile(directory, 'bl_seed_*_outputPeriod_10.csv'));
for ii = 1:length(files)
    filePath = fullfile(directory,files(ii).name);  
    tic;
    tripCompletionTime{ii} = fcn_extractTripTime(filePath);
    toc; 
    fprintf("Extracted trip completion time of seed %d. \n",ii);
end
end

tripCompletionTime_all = readtable([sim_name,'_tripcompletiontime.csv']);



h_hist =figure();
histogram(tripCompletionTime_all.Duration/3600,80,'Normalization','probability');
ylabel('Probability');
xlabel('Trip completion time (hr)');
xlim([0,0.15]);
cls_SUMOplot.fcn_setFigureFormat;
print(h_hist,[folder,'/Fig/',sim_name,'tripCompletionTime'],'-dpng','-r300');

%% calculate steady state time

figure(figNum.pct5);
histogram(settling_time_5pct,22,'Normalization','probability');
pd2 = fitdist(settling_time_5pct','normal'); 
xlabel('Settling time (hr)');
ylabel('Probability');
cls_SUMOplot.fcn_setFigureFormat;
% Get the axis limits
x_limit = xlim;
y_limit = ylim;
% Calculate positions for the text
x_pos = mean(x_limit); % Middle of the x-axis
y_pos = y_limit(1) + 3/4 * (y_limit(2) - y_limit(1)); % 1/3 from the top
% Add text to the plot
% text(x_pos, y_pos, ['\mu = ' num2str(pd2.mu, '%.2f'), char(10), '\sigma = ' num2str(pd2.sigma, '%.2f')], ...
%      'HorizontalAlignment', 'center','FontSize',12);
print(figure(figNum.pct5),[folder,'/Fig/',sim_name,'_settlingTime_5PercentError'],'-dpng','-r300');


figure();
h_qq = qqplot(settling_time_5pct)
cls_SUMOplot.fcn_setFigureFormat;
ax = gca;
ax.Title.String = [];
set(h_qq(1), 'MarkerSize', 8);            % Change the marker size
set(h_qq(2), 'LineWidth', 2);  % Change the 45-degree reference line's width and color
set(h_qq(3), 'LineWidth', 2); 

print(gcf,[folder,'/Fig/',sim_name,'settlingTime_qqplot'],'-dpng','-r300');


t = table; 
t.settlingTime_med = median(settling_time_5pct);
t.settlingTime_mean = mean(settling_time_5pct,'all');
t.settlingTime_std = std(settling_time_5pct);
t.tripCompletionTime_med = median(tripCompletionTime_all.Duration/3600);
t.tripCompletionTime_mean = mean(tripCompletionTime_all.Duration/3600);
t.tripCompletionTime_std = std(tripCompletionTime_all.Duration/3600);
t.ratio_med = t.settlingTime_med/t.tripCompletionTime_med;
t.ratio_mean = t.settlingTime_mean / t.tripCompletionTime_mean;
writetable(t,[folder,'/Fig/',sim_name,'ratio.csv']);