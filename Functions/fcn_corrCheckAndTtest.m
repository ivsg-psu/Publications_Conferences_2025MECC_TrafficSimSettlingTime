function [h,p,R1_crop,R2_crop,pd1,pd2] = fcn_corrCheckAndTtest(directory,fileRegExp,emptyRoadSpeed, ...
    coreFigNum,timeInterval,featureKeyWord,sim_name)
figpath = '/home/wushuang/Documents/GitHub/ThesisWork/Fig/';
fignum1 = coreFigNum;
fignum2 = coreFigNum + 1;
fignum3 = coreFigNum + 2;
timeCut = 3600/timeInterval;



R1 = fcn_CorrWithinSim(directory,fileRegExp,emptyRoadSpeed,fignum1,featureKeyWord);
R1_crop = R1.R(1:9,timeCut:end);
R1_crop = reshape(R1_crop,[numel(R1_crop),1]);

R2 = fcn_CorrAcrossSim(directory,fileRegExp,emptyRoadSpeed,fignum2,featureKeyWord);
R2_crop = R2.R(:,timeCut:end-1);
R2_crop = reshape(R2_crop,[numel(R2_crop),1]);

f = figure(fignum3);
histogram(R1_crop,10,'Normalization','probability');
hold on;
histogram(R2_crop,10,'Normalization','probability');
legend('Correlation coefficients within simulations','Correlation coefficients across simulations');
[h,p,ci,stats] = ttest2(R1_crop,R2_crop);
fprintf('The h value of the t test is %d\n',h);
xlabel('Correlation coefficients');
ylabel('Probability');
cls_SUMOplot.fcn_setFigureFormat;

pd1 = fitdist(R1_crop,'normal')
pd2 = fitdist(R2_crop,'normal')
% Add text of mu and sigma 
% Get the axis limits
x_limit = xlim;
y_limit = ylim;
% Calculate positions for the text
x_pos1 = x_limit(1) + 1/6*(x_limit(2) - x_limit(1)); 
x_pos2 = x_limit(1) + 5/6*(x_limit(2) - x_limit(1)); 
y_pos = y_limit(1) + 2/3 * (y_limit(2) - y_limit(1)); % 1/3 from the top
% Add text to the plot
text(x_pos1, y_pos, ['\mu_{within} = ' num2str(pd1.mu, '%.2f'), char(10), '\sigma_{within} = ' num2str(pd1.sigma, '%.2f')], ...
     'HorizontalAlignment', 'center','FontSize',12);
text(x_pos2, y_pos, ['\mu_{across} = ' num2str(pd2.mu, '%.2f'), char(10), '\sigma_{across} = ' num2str(pd2.sigma, '%.2f')], ...
     'HorizontalAlignment', 'center','FontSize',12);


print(f,[figpath,sim_name,'_aggreInterval_',num2str(timeInterval),featureKeyWord,'Correlation'],'-dsvg');
disp('=========================');
end